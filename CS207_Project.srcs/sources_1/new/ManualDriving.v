`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/07 17:07:56
// Design Name: 
// Module Name: MannualDriving
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ManualDriving(
    input power_state,
    input [1:0] mode,
    input clk,
    input reset,

    input throttle,brake,clutch,shift,turn_left,turn_right,

    output reg turn_left_signal,
    output reg turn_right_signal,
    output reg move_forward_signal,
    output reg move_backward_signal,
    
    output reg power_off_manual,//手动挡中更改power状态
    output reg[1:0] manual_state
    );
    //reg[1:0] manual_state;移至output
    
    parameter not_starting=2'b00,starting=2'b01,moving=2'b10;
   
    reg prev_shift;


    always @(posedge clk) begin
        if (reset) begin
            turn_left_signal<=0;
            turn_right_signal<=0;
            move_forward_signal<=0;
            move_backward_signal<=0;
    
            power_off_manual<=0;//手动挡中更改power状态
            manual_state<=not_starting;
            prev_shift<=0;
            


            
        end
        else if (~power_state) begin
             turn_left_signal<=0;
            turn_right_signal<=0;
            move_forward_signal<=0;
            move_backward_signal<=0;
    
            power_off_manual<=0;
            manual_state<=not_starting;
            prev_shift<=0;
            

        end
        begin
            case (manual_state)
            not_starting:
            if ({throttle,brake,clutch}==3'b101) begin

                manual_state<=starting;
            end
            else if({throttle,clutch}==2'b10) begin
                power_off_manual<=1'b1;
                manual_state<=not_starting;
            
            end
            else begin
                manual_state<=manual_state;
            end
            starting:
            if ({throttle,brake,clutch}==3'b100) begin
                manual_state<=moving;
                prev_shift<=shift;
            end
            else if (brake) begin
                manual_state<=not_starting;
            end
            else begin
                manual_state<=manual_state;
            end
            moving:
            if (~throttle||clutch) begin
                manual_state<=starting;
            end
            
            else if(prev_shift!=shift) begin
                power_off_manual<=1'b1;
                manual_state<=not_starting;
            end




            else if(brake) begin
                manual_state<= not_starting;
            end
            else begin
                manual_state<=manual_state;
            end
            default:manual_state<=manual_state;
            endcase

        end
        if(manual_state==moving) begin
                case (shift)
                    1'b0: {move_forward_signal,move_backward_signal}<=2'b10;
                    1'b1:{move_forward_signal,move_backward_signal}<=2'b01;
                    default: {move_forward_signal,move_backward_signal}<={move_forward_signal,move_backward_signal};
                endcase
            end
            else begin
                {move_forward_signal,move_backward_signal}<=2'b00;



            end        
        if(manual_state!=not_starting) begin
                case ({turn_left,turn_right})
                    2'b00: {turn_left_signal,turn_right_signal}<=2'b00;
                    2'b01: {turn_left_signal,turn_right_signal}<=2'b01;
                    2'b10: {turn_left_signal,turn_right_signal}<=2'b10;
                    2'b11: {turn_left_signal,turn_right_signal}<=2'b11;
                    default: {turn_left_signal,turn_right_signal}<={turn_left_signal,turn_right_signal};
                endcase
        end else

        begin
                {turn_left_signal,turn_right_signal}<=2'b00;
        end    

    end

    
        


    
   

            
        
        
    


endmodule

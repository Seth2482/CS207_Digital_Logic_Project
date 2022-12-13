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
    reg break=0;


    always @(posedge clk) begin
        if (reset) begin
            turn_left_signal<=0;
            turn_right_signal<=0;
            move_forward_signal<=0;
            move_backward_signal<=0;
    
            power_off_manual<=0;//手动挡中更改power状态
            manual_state<=not_starting;
            


            
        end
        else if (~power_state) begin
             turn_left_signal<=0;
            turn_right_signal<=0;
            move_forward_signal<=0;
            move_backward_signal<=0;
    
            power_off_manual<=0;
            manual_state<=not_starting;
            

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
            starting:
            if ({throttle,brake,clutch}==3'b100) begin
                manual_state<=moving;
            end
            else if (brake) begin
                manual_state<=not_starting;
            end
            
            moving:
            if (~throttle||clutch) begin
                manual_state<=starting;
            end
            // else if ({shift,clutch}==2'b10) begin
            //     power_off_manual<=1'b1;
            //     manual_state<=not_starting;
            // end
            else if (break) begin
                power_off_manual<=1'b1;
                manual_state<=not_starting;
                
            end
            else if(brake) begin
                manual_state<= not_starting;
            end
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

    //倒车
    
    // always @(shift) begin
    //     if(manual_state==moving&&shift) begin
    //         break<=1;
    //     end else if (reset||~power_state) begin
    //         break<=0;
    //     end
    //      else begin
    //         break<=break;

    //     end

    // end        




        // if(manual_state==moving)begin
        //     case ({turn_left,turn_right,shift})//左转右转倒车
        //         3'b000: {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}<=4'b0010;//左右前后
        //         3'b001: {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}<=4'b0001;
        //         3'b010: {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}<=4'b0110;
        //         3'b011: {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}<=4'b0101;
        //         3'b100: {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}<=4'b1010;
        //         3'b101: {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}<=4'b1001;
        //         3'b110: {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}<=4'b0010;
        //         3'b111: {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}<=4'b0001;
        //         default:{turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}<={turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal};
        //     endcase
        // end  
        // else begin
        //     {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}<=4'b0000;
        // end
        


    
   

            
        
        
    


endmodule

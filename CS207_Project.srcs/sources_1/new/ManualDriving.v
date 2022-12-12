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


    always @(posedge clk,posedge reset) begin
        if (reset || ~power_state) begin
            turn_left_signal<=0;
            turn_right_signal<=0;
            move_forward_signal<=0;
            move_backward_signal<=0;
    
            power_off_manual<=0;//手动挡中更改power状态
            manual_state<=not_starting;


            
        end
        else
        begin
            case (manual_state)
            not_starting:
            if ({throttle,brake,clutch}==3'b101) begin

                manual_state<=starting;
            end
            else if({throttle,clutch}==2'b10) begin
                power_off_manual<=1'b1;
            
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
            else if ({shift,clutch}==2'b10) begin
                power_off_manual<=1'b1;
                
            end
            else if(brake) begin
                power_off_manual<=1'b1;
            end
        endcase
        end
        
        
    end

    always @(manual_state,turn_left,turn_right,shift ) begin
        if(manual_state==moving)begin
        
            case ({turn_left,turn_right,shift})//左转右转倒车
                3'b000: {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}=4'b0010;//左右前后
                3'b001: {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}=4'b0001;
                3'b010: {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}=4'b0110;
                3'b011: {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}=4'b0101;
                3'b100: {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}=4'b1010;
                3'b101: {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}=4'b1001;
                3'b110: {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}=4'b0010;
                3'b111: {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}=4'b0001;
            endcase
        end  
        
        else begin
            {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal}=4'b0000;
        end

            
        
        
    end


endmodule

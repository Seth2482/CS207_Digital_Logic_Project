`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/12/14 11:26:52
// Design Name:
// Module Name: semi_auto
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


module semi_auto(input turn_left_semi,            // 左转 button
                 input turn_right_semi,           // 右转 button
                 input go_straight_semi,
                 input clk,
                 output reg turn_left_signal,
                 output reg turn_right_signal,
                 output reg move_forward_signal,
                 output reg move_backward_signal,
                 input reset,
                 input back_detector,
                 input left_detector,
                 input right_detector,
                 input front_detector);
    reg [1:0] semi_state;//00 waiting,01 turning right
    //10 turning left,11 going straight
    
    reg [3:0] pos;
    always @(posedge clk) begin
        if (reset) begin
            semi_state <= 2'b00;
            pos        <= {back_detector,front_detector,left_detector,right_detector};
        end
        else begin
            case(semi_state)
                2'b00:begin
                    if (go_straight_semi) begin
                        semi_state <= 2'b11;
                    end
                    else if (turn_left_semi) begin
                        semi_state <= 2'b01;
                    end
                    else if (turn_right_semi) begin
                        semi_state <= 2'b10;
                    end
                    else
                    
                    semi_state <= semi_state;
                    pos        <= {back_detector,front_detector,left_detector,right_detector};
                    
                    
                end
                2'b01:
                if (pos!= {back_detector,front_detector,left_detector,right_detector}) begin
                    semi_state <= 2'b00;
                end
                
                2'b10:
                if (pos!= {back_detector,front_detector,left_detector,right_detector}) begin
                    semi_state <= 2'b00;
                end
                
                2'b11:
                
                if (front_detector||~left_detector||~right_detector) begin
                    semi_state <= 2'b00;
                end
            endcase
            
            case (semi_state)
                2'b00: {move_backward_signal,move_forward_signal,turn_right_signal,turn_left_signal}   <= 4'b0000;
                2'b01: {move_backward_signal,move_forward_signal,turn_right_signal,turn_left_signal}   <= 4'b0001;
                2'b10: {move_backward_signal,move_forward_signal,turn_right_signal,turn_left_signal}   <= 4'b0010;
                2'b11: {move_backward_signal,move_forward_signal,turn_right_signal,turn_left_signal}   <= 4'b0100;
                default: {move_backward_signal,move_forward_signal,turn_right_signal,turn_left_signal} <= {move_backward_signal,move_forward_signal,turn_right_signal,turn_left_signal};
            endcase
            
            
            
            
            
            
            
            
            
            
            
            
            
        end
        
        
        
    end
    
    
endmodule

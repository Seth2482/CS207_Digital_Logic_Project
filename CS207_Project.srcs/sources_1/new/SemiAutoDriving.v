`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/07 17:10:13
// Design Name: 
// Module Name: Semi-Auto Driving
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


module SemiAutoDriving(
    input turn_left_Semi,            // 左转 switch
    input turn_right_Semi,           // 右转 switch
    input go_straight_Semi,
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
    wire clk_10hz;
    reg [2:0] Semi_state;// 000 auto drive
                    // 010 waiting for command
                    // 100 turn left 
                    // 001 turn right
                    // 011 turning right
                    // 110 turning left
                    // 111 go straight
    clk_divider #(.period(10000000)) cd5(.clk(clk), .reset(reset), .clk_out(clk_10hz));//~(activation_state == 2'b01)
    reg [3:0] pos;
    always @(posedge clk_10hz) 
    begin
        if(reset)begin
            Semi_state <= 3'b000;
            pos<={back_detector,front_detector,left_detector,right_detector};

        end
        else begin
            case(Semi_state)
                3'b010:begin
                if(go_straight_Semi)begin
                    Semi_state <= 3'b000;
                end
                else if(turn_left_Semi) begin
                    Semi_state <= 3'b100;
                end
                else if(turn_right_Semi)begin
                    Semi_state <= 3'b001;
                end
                else Semi_state <= Semi_state;
                pos <= {back_detector,front_detector,left_detector,right_detector};
                end
                3'b001:
                if (pos!= {back_detector,front_detector,left_detector,right_detector}) begin
                    Semi_state <= 3'b010;
                end
                
                3'b100:
                if (pos!= {back_detector,front_detector,left_detector,right_detector}) begin
                    Semi_state <= 3'b010;
                end
                
                3'b000:
                if (front_detector||~left_detector||~right_detector) begin
                    Semi_state <= 3'b010;
                end
            endcase
            
        case(Semi_state)
        3'b001:{move_forward_signal,turn_right_signal,turn_left_signal}<=3'b010;
        3'b100:{move_forward_signal,turn_right_signal,turn_left_signal}<=3'b001;
        3'b000:{move_forward_signal,turn_right_signal,turn_left_signal}<=3'b100;
        3'b010:{move_forward_signal,turn_right_signal,turn_left_signal}<=3'b000;
        default{move_forward_signal,turn_right_signal,turn_left_signal}<={move_forward_signal,turn_right_signal,turn_left_signal};
        endcase
        end 
    
    end



   // 灯是怎么亮的
    
       



endmodule

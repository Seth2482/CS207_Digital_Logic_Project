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

//////////////////////////////////////////////////////////////////////////////////


module SemiAutoDriving(input turn_left_Semi,            // 左转 switch
                       input turn_right_Semi,           // 右转 switch
                       input go_straight_Semi,          //直走 switch
                       input clk,                       //系统时钟
                       output reg turn_left_signal,//输出左转信号到顶层模块
                       output reg turn_right_signal,//输出右转信号到顶层模块
                       output reg move_forward_signal,//输出前进信号到顶层模块
                       output reg move_backward_signal,//输出后退信号到顶层模块
                       input reset,//重置信号
                       input back_detector,//四个检测器
                       input left_detector,//
                       input right_detector,//
                       input front_detector//
                       );
    wire clk_100hz;
    reg [2:0] Semi_state;
    // 000 waiting for command
    // 001 turn left
    // 010 turn right
    // 011 buffer state
    // 100 force go straight
    // 111 auto go straight
    clk_divider #(.period(1_0000_00)) cd5(.clk(clk), .reset(reset), .clk_out(clk_100hz));//~(activation_state == 2'b01)
    reg [3:0] pos;
    reg [7:0] counter;
    
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            pos <= 4'b1111;
        end
        else begin
            pos <= {front_detector,back_detector,left_detector,right_detector};
        end
    end
    
    always @(posedge clk_100hz, posedge reset)
    begin
        if (reset)begin
            Semi_state <= 3'b011;
            counter    <= 8'b0;
        end
        else begin
            case(Semi_state)
                // waiting for command
                3'b000:begin
                    if (go_straight_Semi && ~front_detector)begin
                        Semi_state <= 3'b100;
                        counter    <= 8'b0;
                    end
                    else if (turn_left_Semi) begin
                        Semi_state <= 3'b001;
                        counter    <= 8'b0;
                    end
                    else if (turn_right_Semi)begin
                        Semi_state <= 3'b010;
                        counter    <= 8'b0;
                    end
                    else Semi_state <= 3'b000;
                end
                // turn left
                3'b001: begin
                    if (counter == 8'd90) begin
                        Semi_state <= 3'b011; // buffer state
                        counter    <= 8'b0;
                    end
                    else
                    counter <= counter + 1;
                end
                
                // turn right
                3'b010: begin 
                    if (counter == 8'd90) begin
                        Semi_state <= 3'b011;
                        counter    <= 8'b0;
                    end
                    else
                    counter <= counter + 1;
                end
                
                // buffer state
                3'b011: begin
                    if(counter == 8'd100) begin 
                        case(pos)
                        4'b0011: begin 
                            Semi_state <= 3'b111; // go straight
                        end
                        4'b0101: begin
                            Semi_state <= 3'b111; // go straight
                        end
                        4'b0110: begin
                            Semi_state <= 3'b111; // go straight
                        end
                        4'b1001: begin
                            Semi_state <= 3'b001; // turn left
                        end            
                        4'b1010: begin
                            Semi_state <= 3'b010; // turn right
                        end            

                        4'b1100: begin 
                            Semi_state <= 3'b000; // waiting for command
                        end
                        4'b0111: begin 
                            Semi_state <= 3'b111; // go straight
                        end
                        4'b1011: begin
                            Semi_state <= 3'b010; // turn around(turn right first)
                        end
                        4'b1101: begin
                            Semi_state <= 3'b001; // turn left
                        end
                        4'b1110: begin
                            Semi_state <= 3'b010; // turn right                        
                        end
                        default: begin
                            Semi_state <= 3'b000; // waiting for command
                        end
                        endcase
                        counter <= 8'b0;
                    end else
                        counter <= counter + 1;
                end
                
                // force go straight
                3'b100: begin
                    if (counter == 8'd30) begin
                        Semi_state <= 3'b111;
                        counter    <= 8'b0;
                    end
                    else
                    counter <= counter + 1;
                end
                
                // auto go straight
                3'b111: begin
                    if((front_detector || pos == 4'b0001 || pos == 4'b0010 || pos == 4'b0000)) begin // 0.1s for correction
                        if(counter == 8'd10)
                            // go buffer state 
                            Semi_state <= 3'b011;
                        else
                            counter = counter + 1;
                    end else begin 
                        Semi_state <= 3'b111;
                        counter <= 8'b0;
                    end
                end
                default:
                    // handler exception
                    Semi_state = 3'b011;
            endcase
        end
    end
    
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            {move_forward_signal,move_backward_signal,turn_right_signal,turn_left_signal} <= 3'b0000;
        end
        else begin
            case(Semi_state)
                // waiting for command
                3'b000:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b000;
                // turn left
                3'b001:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b001;
                // turn right
                3'b010:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b010;
                // buffer state
                3'b011:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b000;
                // force go straight
                3'b100:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b100;
                // auto go straight
                3'b111:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b100;
            endcase
        end
    end
    
endmodule

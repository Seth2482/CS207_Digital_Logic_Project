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
                       input go_straight_Semi, //直走 switch
                       input turn_back_Semi,   //倒车 switch
                       input clk,              //系统时钟
                       output reg turn_left_signal, //输出左转信号到顶层模块
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
    reg [3:0] Semi_state;
    // 0000 waiting for command
    // 0001 turn left
    // 0010 turn right
    // 0011 buffer state
    // 0100 force go straight
    // 0111 auto go straight
    // 0101 force turn back
    // 1001 force turn left
    // 1010 force turn right
    clk_divider #(.period(1_0000_00)) cd5(.clk(clk), .reset(reset), .clk_out(clk_100hz));//~(activation_state == 2'b01)
    reg [3:0] pos;
    reg [7:0] counter;
    
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            pos <= 4'b1111;
        end
        else begin
            pos <= {front_detector,back_detector,left_detector,right_detector};//前后左右
        end
    end
    
    always @(posedge clk_100hz, posedge reset)
    begin
        if (reset)begin
            Semi_state <= 4'b0011;
            counter    <= 8'b0;
        end
        else begin
            case(Semi_state)
                // waiting for command
                4'b0000:begin
                    if (go_straight_Semi && ~front_detector)begin
                        Semi_state <= 4'b0100;
                        counter    <= 8'b0;
                    end
                    else if (turn_left_Semi) begin
                        Semi_state <= 4'b1001;
                        counter    <= 8'b0;
                    end
                    else if (turn_right_Semi)begin
                        Semi_state <= 4'b1010;
                        counter    <= 8'b0;
                    end
                    else if (turn_back_Semi) begin
                        Semi_state <= 4'b0101;
                        counter    <= 8'b0;
                    end
                    else Semi_state <= 4'b0000;
                end
                // turn left
                4'b0001: begin
                    if (counter == 8'd90) begin
                        Semi_state <= 4'b0011; // buffer state
                        counter    <= 8'b0;
                    end
                    else
                    counter <= counter + 1;
                end
                
                // turn right
                4'b0010: begin 
                    if (counter == 8'd90) begin
                        Semi_state <= 4'b0011; // buffer state
                        counter    <= 8'b0;
                    end
                    else
                    counter <= counter + 1;
                end
                
                // buffer state
                4'b0011: begin
                    if(counter == 8'd100) begin 
                        case(pos)
                        4'b0011: begin 
                            Semi_state <= 4'b0111; // go straight
                        end
                        4'b0101: begin
                            Semi_state <= 4'b0111; // go straight
                        end
                        4'b0110: begin
                            Semi_state <= 4'b0111; // go straight
                        end
                        4'b1001: begin
                            Semi_state <= 4'b0001; // turn left
                        end            
                        4'b1010: begin
                            Semi_state <= 4'b0010; // turn right
                        end            

                        4'b1100: begin 
                            Semi_state <= 4'b0000; // waiting for command
                        end
                        4'b0111: begin 
                            Semi_state <= 4'b0111; // go straight
                        end
                        4'b1011: begin
                            Semi_state <= 4'b0010; // turn around(turn right first)
                        end
                        4'b1101: begin
                            Semi_state <= 4'b0001; // turn left
                        end
                        4'b1110: begin
                            Semi_state <= 4'b0010; // turn right                        
                        end
                        default: begin
                            Semi_state <= 4'b0000; // waiting for command
                        end
                        endcase
                        counter <= 8'b0;
                    end else
                        counter <= counter + 1;
                end
                
                // force go straight
                4'b0100: begin
                    if (counter == 8'd30) begin
                        Semi_state <= 4'b0111;
                        counter    <= 8'b0;
                    end
                    else
                    counter <= counter + 1;
                end

                // force turn left
                4'b1001: begin
                    if (counter == 8'd90) begin
                        Semi_state <= 4'b0100; // force go straight
                        counter    <= 8'b0;
                    end
                    else
                    counter <= counter + 1;
                end
                
                // force turn right
                4'b1010: begin 
                    if (counter == 8'd90) begin
                        Semi_state <= 4'b0100; // buffer state
                        counter    <= 8'b0;
                    end
                    else
                    counter <= counter + 1;
                end

                // force turn back
                4'b0101:begin 
                    if (counter == 8'd180) begin
                        Semi_state <= 4'b0100; // buffer state
                        counter    <= 8'b0;
                    end
                    else
                    counter <= counter + 1;
                end
                
                // auto go straight
                4'b0111: begin
                    if((front_detector || pos == 4'b0001 || pos == 4'b0010 || pos == 4'b0000)) begin // 0.1s for correction
                        if(counter == 8'd10)
                            // go buffer state 
                            Semi_state <= 4'b0011;
                        else
                            counter = counter + 1;
                    end else begin 
                        Semi_state <= 4'b0111;
                        counter <= 8'b0;
                    end
                end
                default:
                    // handler exception
                    Semi_state = 4'b0011;
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
                4'b0000:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b000;
                // turn left
                4'b0001:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b001;
                // turn right
                4'b0010:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b010;
                // buffer state
                4'b0011:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b000;
                // force go straight
                4'b0100:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b100;
                // force turn back
                4'b0101:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b010;
                // auto go straight
                4'b0111:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b100;
                // force turn left
                4'b1001:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b001; 
                // force turn right
                4'b1010:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b010;
                endcase
        end
    end
    
endmodule

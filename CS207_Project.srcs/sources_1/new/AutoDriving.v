`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/12/10 21:38:13
// Design Name:
// Module Name: AutoDriving
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


module AutoDriving(input reset,// 重置信号
                   input clk,//系统时钟
                   input front_detector,//检测器
                   input back_detector,//
                   input right_detector,//
                   input left_detector,//
                   output reg turn_left_signal,//输出到顶层模块的左转信号
                   output reg turn_right_signal,//输出到顶层模块的右转信号
                   output reg move_forward_signal,//输出到顶层模块的前进信号
                   output reg move_backward_signal,//输出到顶层模块的后退信号
                   output reg place_barrier_signal,//输出到顶层模块的放障碍信号
                   output reg destroy_barrier_signal//输出到顶层模块的摧毁障碍信号
                   );
    wire clk_100hz;
    reg [3:0] auto_state;
    // 000 Place barrier
    // 001 try go straight (after complex turn right)
    // 010 complex turn right (after complex state)
    // 011 buffer state
    // 100 force go straight
    // 101 auto turn right
    // 110 auto turn left
    // 111 auto go straight
    // 1000 destroy a barrier then turn
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
        if (reset || !power_state)begin
            auto_state <= 4'b011;
            counter    <= 8'b0;
        end
        else begin
            case(auto_state)
                4'b000: begin
                    if (counter == 8'd10) begin
                        auto_state <= 3'b111; // continue to go straight
                        counter    <= 8'b0;
                    end
                    else
                    counter <= counter + 1;
                end
                
                // 001 try go straight (after complex turn right)
                4'b001: begin
                    if (counter == 8'd30) begin
                        if (!front_detector) begin
                            auto_state <= 3'b100; // force go straight
                        end
                        else begin
                            auto_state <= 3'b010; // continue to turn right
                        end
                        counter <= 8'b0;
                    end
                    else
                    counter <= counter + 1;
                end
                
                // 010 complex turn right
                4'b010: begin
                    if (counter == 8'd90) begin
                        auto_state <= 3'b001;
                        counter    <= 8'b0;
                    end
                    else
                    counter <= counter + 1;
                end
                
                // buffer state
                4'b011: begin
                    if (counter == 8'd50) begin
                        counter <= 8'b0;
                        case(pos)
                            4'b0011: begin
                                auto_state <= 4'b111; // go straight
                            end
                            4'b0101: begin
                                auto_state <= 4'b111; // go straight
                            end
                            4'b0110: begin
                                auto_state <= 4'b111; // go straight
                            end
                            4'b1001: begin
                                auto_state <= 4'b110; // auto turn left
                            end
                            4'b1010: begin
                                counter <= 8'b0;
                                auto_state <= 4'b101; // auto turn right
                            end
                            4'b1100: begin
                                auto_state <= 4'b010; // complex turn right
                            end
                            4'b0111: begin
                                auto_state <= 4'b111; // go straight
                            end
                            4'b1011: begin
                                auto_state <= 4'b1000; // turn around(auto turn right first)
                            end
                            4'b1101: begin
                                auto_state <= 4'b110; // auto turn left
                            end
                            4'b1110: begin
                                auto_state <= 4'b101; // auto turn right
                            end
                            4'b0001: begin
                                auto_state <= 4'b100; // force go straight
                            end
                            default: begin
                                auto_state <= 4'b010; // complex turn right
                            end
                        endcase
                    end
                    else
                    counter <= counter + 1;
                end
                
                // force go straight
                4'b100: begin
                    if (front_detector) begin 
                        auto_state = 4'b011;
                        counter    <= 8'b0;
                    end
                    else if (counter == 8'd90) begin
                        auto_state <= 4'b000; // place barrier
                        counter    <= 8'b0;
                    end
                    else
                    counter <= counter + 1;
                end
                
                // auto turn right
                4'b101: begin
                    if (counter == 8'd90) begin
                        auto_state <= 4'b011;
                        counter    <= 8'b0;
                    end
                    else
                    counter <= counter + 1;
                end
                
                // auto turn left
                4'b110: begin
                    if (counter == 8'd90) begin
                        auto_state <= 4'b011;
                        counter    <= 8'b0;
                    end
                    else
                    counter <= counter + 1;
                end
                
                // auto go straight
                4'b111: begin
                    if ((front_detector || pos == 4'b0001 || pos == 4'b0010 || pos == 4'b0000)) begin // 0.1s for correction
                        if (counter == 8'd10)
                        // go buffer state
                            auto_state <= 4'b011;
                        else
                            counter = counter + 1;
                            end else begin
                            auto_state <= 3'b111;
                            counter    <= 8'b0;
                    end
                end
                4'b1000: begin
                    if (counter == 8'd10) begin
                        auto_state <= 3'b101; // continue to turn around
                        counter    <= 8'b0;
                    end
                    else
                    counter <= counter + 1;
                end
                default:
                // handler exception
                auto_state = 3'b011;
            endcase
        end
    end
    
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            {move_forward_signal,move_backward_signal,turn_right_signal,turn_left_signal} <= 3'b0000;
        end
        else begin
            if (auto_state == 4'b000) begin
                place_barrier_signal <= 1;
            end
            else begin
                place_barrier_signal <= 0;
            end

            if (auto_state == 4'b1000) begin
                destroy_barrier_signal <= 1;
            end
            else begin
                destroy_barrier_signal <= 0;
            end
            
            case(auto_state)
                // try go straight
                4'b001:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b000;
                // complex turn right
                4'b010:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b010;
                // buffer state
                4'b011:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b000;
                // force go straight
                4'b100:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b100;
                // auto turn right
                4'b101:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b010;
                // auto turn left
                4'b110:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b001;
                // auto go straight
                4'b111:{move_forward_signal,turn_right_signal,turn_left_signal} <= 3'b100;
            endcase
        end
    end
    
endmodule

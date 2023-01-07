`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/12/10 21:56:36
// Design Name:
// Module Name: record_module
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

module turn_light_module(input reset,//重置信号
                         input clk,//系统时钟
                         input power_state,//是否开机
                         input [1:0] mode,//模式选择
                         input [1:0] manual_state,//
                         input turn_left_signal,//输入左转信号
                         input turn_right_signal,//输入右转信号
                         output reg left_led,//输出到顶层模块的左转信号
                         output reg right_led//输出到顶层模块的右转信号
                         );
    wire clk_2hz;
    reg [1:0] state; // turn light state
    // 00 two lights keep off
    // 01 two lights keep on
    // 10 left light flash
    // 11 right light flash
    clk_divider #(.period(5000_0000)) u_clk_2hz(.clk(clk), .reset(reset), .clk_out(clk_2hz));
    
    always @(posedge clk, posedge reset) begin
        if (reset || ~power_state) begin
            state <= 2'b00;
        end
        else begin
            case (state)
                2'b00: begin
                    if (mode == 2'b01 && manual_state == 2'b00) begin
                        state <= 2'b01;
                    end
                    else if (turn_left_signal) begin
                        state <= 2'b10;
                    end
                    else if (turn_right_signal) begin
                        state <= 2'b11;
                    end
                end
                2'b01: begin
                    if (~(mode == 2'b01 && manual_state == 2'b00)) begin
                        state <= 2'b00;
                    end
                end
                2'b10: begin
                    if (~turn_left_signal) begin
                        state <= 2'b00;
                    end
                end
                2'b11: begin
                    if (~turn_right_signal) begin
                        state <= 2'b00;
                    end
                end
            endcase
        end
    end
    
    always @(posedge clk) begin
        case (state)
            2'b00: begin
                left_led  <= 0;
                right_led <= 0;
            end
            2'b01: begin
                left_led  <= 1;
                right_led <= 1;
            end
            2'b10: begin
                left_led  <= clk_2hz;
                right_led <= 0;
            end
            2'b11: begin
                left_led  <= 0;
                right_led <= clk_2hz;
            end
        endcase
    end
    
endmodule

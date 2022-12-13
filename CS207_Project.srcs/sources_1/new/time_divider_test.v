`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/12/13 22:31:38
// Design Name:
// Module Name: time_divider_test
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


module time_divider_test(input clk,
                         input rst_n,
                         output led_1hz,
                         output led_2hz,
                         output led_5hz,
                         output led_10hz,
                         output led_100hz,
                         output led_1000hz);
    wire reset;
    assign reset = ~rst_n;
    clk_divider #(.period(1_0000_0000)) u_1hz(clk, reset, led_1hz);
    clk_divider #(.period(5_0000_000)) u_2hz(clk, reset, led_2hz);
    clk_divider #(.period(2_0000_000)) u_5hz(clk, reset, led_5hz);
    clk_divider #(.period(1_0000_000)) u_10hz(clk, reset, led_10hz);
    clk_divider #(.period(1_0000_00)) u_100hz(clk, reset, led_100hz);
    clk_divider #(.period(1_0000_0)) u_1000hz(clk, reset, led_1000hz);
endmodule

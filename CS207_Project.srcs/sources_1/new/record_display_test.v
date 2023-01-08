`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/12/14 10:14:43
// Design Name:
// Module Name: record_display_test
// Project Name:
// Target Devices:
// Tool Versions:
// Description: 里程表测试模块
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module record_display_test(input clk,
                           input rst_n,
                           output [7:0] seg_en, // enables of 8 lights
                           output [7:0] seg_out0,   // output of first 4 lights
                           output [7:0] seg_out1);
    reg [23:0] record;
    record_display record_display(clk, ~rst_n, 1, record, seg_en, seg_out0, seg_out1);

  always @(posedge clk) begin
    record = 24'd1234567;
  end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/28 09:39:57
// Design Name: 
// Module Name: flash_led_top
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


module flash_led_top(
    input clk,
    input rst_n,
    input sw0,
    output [7:0] led
    );
    wire clk_bps;
    counter cnt1(.clk(clk),.rst_n(rst_n),.clk_bps(clk_bps));
    flash_led_ctrl fled_ctrl(.clk(clk),.rst_n(rst_n),.dir(sw0),.clk_bps(clk_bps),.led(led));
endmodule

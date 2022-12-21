`timescale 1ns / 1ps
module vga_display(
    input vga_clk,
    input sys_rst_n,
    input [9:0] pixel_xpos,
    input [9:0] pixle_ypos,
    output reg [15:0] pixel_data
);

parameter H_DISP = 10'd640 ;
parameter V_DISP = 10'd480 ;
localparam POS_X = 10'd288 ;
localparam POS_Y = 10'd232 ;
localparam WIDTH = 10'd64;
localparam HEIGHT = 10'd16;
localparam RED = 16'b11111_000000_00000;
localparam BLUE =16'b00000_000000_11111;
localparam BLACK=16'b00000_000000_00000;

reg [63:0] char[15:0];


endmodule
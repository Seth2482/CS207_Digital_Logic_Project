`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/06 13:06:47
// Design Name: 
// Module Name: vga_test
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


module vga_test(
    input clk,
    input rst_n,
    output [11:0] rgb,
    output hsync,
    output vsync
);

reg [23:0] record;
reg [1:0] mode;
assign  reset = ~rst_n;

always @(posedge clk) begin
    record <= 24'd7654321;
    mode <= 2'b11;
end

vga_top m_vga_top(
    .clk_100MHz(clk),
    .reset(reset),
    .record(record),
    .mode(mode),
    .hsync(hsync),
    .vsync(vsync),
    .rgb(rgb)
);
endmodule

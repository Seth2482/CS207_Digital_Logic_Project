`timescale 1ns / 1ps

module vga(
    input sys_clk, //系统时钟
    input sys_rst_n, //复位信号
    output vga_hs,
    output vga_vs,
    output [15:0] vga_rgb
);
wire vga_clk_w;
wire locked_w;
wire rst_n_w;
wire [15:0] pixel_data_w;
wire [9:0] pixel_xpos_w;
wire [9:0] pixel_ypos_w;
assign rst_n_w= sys_rst_n&&locked_w;


vga_pll u_vga_driver(
    .vga_clk(vga_clk_w),
    .sys_rst_n(rst_n_w),
    .vga_hs(vga_hs),
    .vga_vs(vga_vs),
    .vga_rgb(vga_rgb),
    .pixel_data(pixel_data_w),
    .pixel_xpos(pixel_xpos_w),
    .pixle_ypos(pixel_ypos_w)
);

vga_display u_vga_display(
    .vga_clk(vga_clk_w),
    .sys_rst_n(rst_n_w),
    .pixel_xpos(pixel_xpos_w),
    .pixel_ypos(pixel_ypos_w),
    .pixel_data(pixel_data_w)
);

endmodule
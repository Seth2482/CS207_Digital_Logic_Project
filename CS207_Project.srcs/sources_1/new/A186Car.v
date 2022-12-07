`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/06 21:42:02
// Design Name: 
// Module Name: A186Car
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


module A186Car(
    input clk,           
    input power_on,         // 点火 button
    input power_off,        // 熄火 button
    input throttle,         // 油门 switch 
    input clutch,           // 离合 switch
    input break,            // 刹车 switch
    input reverse_gear,     // 倒车 switch
    input turn_left,        // 左转 switch
    input turn_right,       // 右转 switch
    output turn_left_light, // 左转灯 led
    output turn_right_light,// 右转灯 led
    output [7:0] seg_en,    // 8 个流水灯开关
    output [7:0] seg_out0,  // 前 4 个流水灯输出
    output [7:0] seg_out1,  // 后 4 个流水灯输出
);


endmodule

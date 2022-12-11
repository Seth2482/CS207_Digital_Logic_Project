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
// 
//////////////////////////////////////////////////////////////////////////////////


module SemiAutoDriving(
input wire [1:0] x,//输入的转向信号。
input wire clk,
output reg [7:0]y//输出的灯。
    );
    reg [1:0] state;
    always @(posedge clk) 
    begin
        if(state == 2'b0&&x == 2'b01)//00 是waiting for command状态,turn right.
        begin
        y <= 8'b00001111;
        state <= 2'b01;//01 is turing right 
        end
        else if(state == 2'b0&&x == 2'b10)            //turn left.
        begin
        y <= 8'b11110000;
        state <= 2'b10;//10 is turning left.
        end
        
    end





endmodule

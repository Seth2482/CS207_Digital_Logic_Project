`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/12/08 22:54:05
// Design Name: 分频器 1Hz
// Module Name: clk_divider
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


module clk_divider(input clk,
                   reset,
                   output reg clk_out);
    parameter period = 1_0000_0000;
    reg [31:0] cnt;
    always@(posedge clk)
    begin
        if (reset)begin
            cnt     <= 0;
            clk_out <= 0;
        end
        else
            if (cnt == ((period>>1)-1))begin
                clk_out <= ~clk_out;
                cnt     <= 0;
            end
            else begin
                cnt <= cnt+1;
            end
    end
endmodule

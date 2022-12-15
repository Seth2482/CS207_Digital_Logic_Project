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


module record_module(input reset,
                     input clk,
                     input power_state,
                     input [1:0] mode,
                     input [1:0] manual_state,
                     input turn_left_signal,
                     input turn_right_signal,
                     input move_forward_signal,
                     input move_backward_signal,
                     output reg [23:0] record);
    wire clk_2hz;
    clk_divider_with_enable u_clk_2hz(.clk(clk),
    .reset(reset || ~power_state),
    .enable(turn_left_signal || turn_right_signal || move_forward_signal || move_backward_signal || (mode == 2'b01 && manual_state == 2'b10)),
    .clk_out(clk_2hz));
    
    always @(negedge clk_2hz, posedge reset) begin
        if (reset || ~power_state) begin
            record <= 0;
        end
        else begin
        record = record + 1;
        end
    end
endmodule

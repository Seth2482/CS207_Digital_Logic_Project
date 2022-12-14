`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/12/10 21:38:13
// Design Name:
// Module Name: AutoDriving
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


module AutoDriving(input reset,
                   input clk,
                   input front_detector,
                   input back_detector,
                   input right_detector,
                   input left_detector,
                   output reg turn_left_signal,
                   output reg turn_right_signal,
                   output reg move_forward_signal,
                   output reg move_backward_signal,
                   output reg place_barrier_signal,
                   output reg destroy_barrier_signal);
  always @(posedge clk, posedge reset) begin
    if(reset) begin 
        turn_left_signal <= 0;
        turn_right_signal <= 0;
        move_forward_signal <= 0;
        move_backward_signal <= 0;
        place_barrier_signal <= 0;
        destroy_barrier_signal <= 0;
    end
  end
endmodule

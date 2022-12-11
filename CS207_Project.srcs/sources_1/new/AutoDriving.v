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
                   input front_detector,
                   input back_detector,
                   input right_detector,
                   input left_detector,
                   output turn_left_signal,
                   output turn_right_signal,
                   output move_forward_signal,
                   output move_backward_signal,
                   output place_barrier_signal,
                   output destroy_barrier_signal
                   );
endmodule

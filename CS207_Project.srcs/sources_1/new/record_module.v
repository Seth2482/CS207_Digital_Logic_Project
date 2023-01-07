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
                     input [1:0] mode,//the type of mode
                     input [1:0] manual_state,// state in manualDriving
                     input turn_left_signal,// four command
                     input turn_right_signal,
                     input move_forward_signal,
                     input move_backward_signal,
                     output reg [23:0] record// the number of road that the car has gotten through
                     );
    wire clk_2hz;
    clk_divider u_clk_2hz(.clk(clk),
    .reset(reset),
    .clk_out(clk_2hz));
    
    always @(negedge clk_2hz, posedge reset) begin
        if (reset || !power_state) begin
            record <= 0;
        end
        else begin
            if (move_forward_signal||move_backward_signal) begin
                record = record + 1;
                
            end
        
        end
    end
endmodule

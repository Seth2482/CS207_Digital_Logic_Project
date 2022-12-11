`timescale  1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/12/10 22:56:36
// Design Name:
// Module Name: record_module_sim
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


module record_module_sim;


// record_module Parameters
parameter PERIOD  = 10;


// record_module Inputs
reg   reset                                = 1 ;
reg   clk                                  = 0 ;
reg   power_state                          = 0 ;
reg   turn_left_signal                     = 0 ;
reg   turn_right_signal                    = 0 ;
reg   move_forward_signal                  = 0 ;
reg   move_backward_signal                 = 0 ;

// record_module Outputs
wire  [7:0]  record                        ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) reset  =  0;
    move_forward_signal = 1;
    power_state = 1;
    #49990 move_forward_signal = 0;
    #100 move_backward_signal = 1;
    #20010 move_backward_signal = 0;
    #20 power_state = 0;
end

record_module  u_record_module (
    .reset                   ( reset                       ),
    .clk                     ( clk                         ),
    .power_state             ( power_state                 ),
    .turn_left_signal        ( turn_left_signal            ),
    .turn_right_signal       ( turn_right_signal           ),
    .move_forward_signal     ( move_forward_signal         ),
    .move_backward_signal    ( move_backward_signal        ),

    .record                  ( record                [7:0] )
);
defparam u_record_module.u_clk_2hz.period = 5_00;
endmodule
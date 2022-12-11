`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/09 10:57:05
// Design Name: 
// Module Name: clk_divider_1hz_sim
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



module clk_divider_sim;

// clk_divider_1hz Parameters
parameter PERIOD  = 10         ;
parameter period  = 1_000; // 跑仿真的时候加速100000倍

// clk_divider_1hz Inputs
reg   clk                                  = 0 ;
reg   reset                                = 1 ;

// clk_divider_1hz Outputs
wire  clk_out                              ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(period) reset = 0;
end

clk_divider #(
    .period ( period ))
 u_clk_divider_1hz (
    .clk                     ( clk       ),
    .reset                   ( reset     ),

    .clk_out                 ( clk_out   )
);

endmodule

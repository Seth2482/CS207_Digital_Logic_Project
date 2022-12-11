`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/09 10:39:39
// Design Name: 
// Module Name: launch_module_sim
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

module power_module_sim;

// !!!! Before running the sim, you should change the parameter 'period' in clk_divider_1hz into 1000

// power_module Parameters
parameter PERIOD  = 10;


// power_module Inputs
reg   clk                                  = 0 ;
reg   power_on                             = 0 ;
reg   power_off                            = 0 ;
reg   reset                                = 1 ;

// power_module Outputs
wire  power_state                          ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) reset  =  0;

    #(40) power_on <= 1;
    #(40) power_on <= 0;

    #(40) power_on <= 1;
    #(10010) power_on <= 0;

    #(2000) power_off <= 1;
    #(20) power_off <= 0;
end

power_module  u_power_module (
    .clk                     ( clk           ),
    .power_on                ( power_on      ),
    .power_off               ( power_off     ),
    .reset                   ( reset         ),

    .power_state             ( power_state   )
);


endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/12/13 23:54:50
// Design Name:
// Module Name: power_module_test
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


module power_module_test(input clk,
                         input power_on,
                         input power_off,
                         input rst_n,
                         output power_state,
                         output power_on_button,
                         output power_off_button);
    assign power_on_button  = power_on;
    assign power_off_button = power_off;
    power_module u_power_module(.clk(clk), .reset(~rst_n), .power_on(power_on), .power_off(power_off), .power_state(power_state));
    
endmodule

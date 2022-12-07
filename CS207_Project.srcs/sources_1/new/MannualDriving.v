`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/07 17:07:56
// Design Name: 
// Module Name: MannualDriving
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


module MannualDriving(
    input power_state,mode,clk,

    input throttle,clutch,brake,shift,turn_left,turn_right,

    


    output turn_left_signal,
    output turn_right_signal,
    output move_forward_signal,
    output move_backward_signal,
    
    output led_left,
    output led_right,
    output [7:0] record

    );
    reg[1:0] mannual_state;
    parameter not_starting=2'b00,starting=2'b01,moving=2'b10;


endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/11 22:07:39
// Design Name: 
// Module Name: MannualDriving_sim
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


module MannualDriving_sim(

    );

    reg power_state=0;
    reg[1:0] mode=2'b00;
    reg clk=0;
    reg reset=0;
    reg throttle=0;
    reg brake=0;
    reg clutch=0;
    reg shift=0;
    reg turn_left=0;
    reg turn_right=0;

    wire turn_left_signal;
    wire turn_right_signal;
    wire move_forward_signal;
    wire move_backward_signal;
    wire power_off_mannual;
    wire [1:0] mannual_state;

    MannualDriving u_mannualdriving(
        .power_state(power_state),
        .mode(mode),
        .clk(clk),
        .reset(reset),
        .throttle(throttle),
        .brake(brake),
        .clutch(clutch),
        .shift(shift),
        .turn_left(turn_left),
        .turn_right(turn_right),
        .turn_left_signal(turn_left_signal),
        .turn_right_signal(turn_right_signal),
        .move_forward_signal(move_forward_signal),
        .move_backward_signal(move_backward_signal),

        .power_off_mannual(power_off_mannual),
        .mannual_state(mannual_state)
    );

    initial
    begin
        forever #5 clk=~clk;
    end

    initial begin
        #50 power_state=1'b1;
        #50 mode=2'b01;
        #50 {throttle,brake,clutch}=3'b101;
        #50 {throttle,brake,clutch}=3'b100;
        #500 $finish;

    end






endmodule

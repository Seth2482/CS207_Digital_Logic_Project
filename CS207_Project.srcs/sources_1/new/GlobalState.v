`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/06 22:00:30
// Design Name: 
// Module Name: GlobalState
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


module GlobalState(
    input power_on,power_off,clk,
    input [1:0] mode_selection

    );

parameter On =1'b1,Off=1'b0 ;
reg power_state;//电源状态
always @(posedge power_off) begin
    power_state<=Off;
end
always @(posedge clk) begin
    if (power_on) begin
        power_state<=On;
    end
end


reg [1:0] mode;//驾驶模式,01为手动，10为半自动，11为全自动
always @(mode_selection) begin
    if(power_on) begin
        mode<=2'b00;
    end
    else begin
        mode<=mode_selection;
    end
end 




MannualDriving();


//各个模式的输出，绑定在simulate的输入
reg turn_left_signal;
reg turn_right_signal;
reg move_forward_signal;
reg move_backward_signal;
reg place_barrier_signal;
reg destroy_barrier_signal;

reg rx;

wire tx;
wire front_detector;
wire back_detector;
wire left_detector;
wire right_detector;
SimulatedDevice simulate(
    clk,
    rx,
    tx,

    turn_left_signal,
    turn_right_signal,
    move_forward_signal,
    move_backward_signal,
    place_barrier_signal,
    destroy_barrier_signal,
    front_detector,
    back_detector,
    left_detector,
    right_detector
    
    // input sys_clk, //bind to P17 pin (100MHz system clock)
    // input rx, //bind to N5 pin
    // output tx, //bind to T4 pin
    
    // input turn_left_signal,
    // input turn_right_signal,
    // input move_forward_signal,
    // input move_backward_signal,
    // input place_barrier_signal,
    // input destroy_barrier_signal,
    // output front_detector,
    // output back_detector,
    // output left_detector,
    // output right_detector
);


endmodule

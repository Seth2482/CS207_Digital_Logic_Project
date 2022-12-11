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


module AE86Car(
    input clk,           
    input power_on,             // 点火 button
    input power_off,            // 熄火 button
    input throttle,             // 油门 switch 
    input clutch,               // 离合 switch
    input brake,                // 刹车 switch
    input reverse_gear,         // 倒车 switch
    input turn_left,            // 左转 switch
    input turn_right,           // 右转 switch
    input reset,
    input rx,                   // 输入 绑定到 N5
    output tx,                  // 输出 绑定到 T4
    input [1:0] mode_selection, // 模式选择 switch*2
    output turn_left_light,     // 左转灯 led
    output turn_right_light,    // 右转灯 led
    output [7:0] seg_en,        // 8 个流水灯开关
    output [7:0] seg_out0,      // 前 4 个流水灯输出
    output [7:0] seg_out1       // 后 4 个流水灯输出
    );

// Global States
wire power_state;//电源状态
reg [1:0] mode;//驾驶模式,01为手动，10为半自动，11为全自动
wire [1:0] mannual_state;//手动驾驶中的not_starting,starting,moving状态

//各个模式的输出，绑定在simulate的输入
wire turn_left_signal;
wire turn_right_signal;
wire move_forward_signal;
wire move_backward_signal;
wire place_barrier_signal;
wire destroy_barrier_signal;
wire front_detector;
wire back_detector;
wire left_detector;
wire right_detector;

parameter On =1'b1,Off=1'b0 ;

// 将power_state由power_module接管
reg power_off_signal;
wire power_off_mannual;
always @(posedge clk) begin
    power_off_signal <= power_off || power_off_mannual;
    
end
power_module u_power_module(.clk(clk), .power_on(power_on), .power_off(power_off_signal), .reset(reset), .power_state(power_state));



always @(mode_selection,power_on) begin
    if(power_on) begin
        mode<=2'b00;
    end
    else begin
        mode<=mode_selection;
    end
end 



MannualDriving u_mannualdriving(
.power_state(power_state),
.mode(mode),
.clk(clk),
.reset(reset),
.throttle(throttle),
.brake(brake),
.clutch(clutch),
.shift(reverse_gear),
.turn_left(turn_left),
.turn_right(turn_right),
.turn_left_signal(turn_left_signal),
.turn_right_signal(turn_left_signal),
.move_forward_signal(move_forward_signal),
.move_backward_signal(move_backward_signal),
.power_off_mannual(power_off_mannual),
.mannual_state(mannual_state)
);

SimulatedDevice simulate(
    .sys_clk(clk),
    .rx(rx),
    .tx(tx),

    .turn_left_signal(turn_left_signal),
    .turn_right_signal(turn_right_signal),
    .move_forward_signal(move_forward_signal),
    .move_backward_signal(move_backward_signal),
    .place_barrier_signal(place_barrier_signal),
    .destroy_barrier_signal(destroy_barrier_signal),
    .front_detector(front_detector),
    .back_detector(back_detector),
    .left_detector(left_detector),
    .right_detector(right_detector)
    
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

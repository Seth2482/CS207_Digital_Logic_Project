`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/12/08 22:40:57
// Design Name: 电源控制模块
// Module Name: launch_module
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


module power_module(input clk,
                    input power_on,// 开机键
                    input power_off,  // 如果其它模块要关闭电源，请通过此接口传入
                    input reset,//重置信号
                    output reg power_state// 输出到顶层模块
                    );
    
    wire clk_100hz;                // 100hz分频器
    reg [1:0] activation_state;    // 车辆power的状态
                                   // 00 等待启动按钮按下
                                   // 01 按钮已按下，等待1s后启动
                                   // 10 车辆已启动
    reg [6:0] timer;
    clk_divider #(.period(1_0000_00)) cd1(.clk(clk), .reset(reset), .clk_out(clk_100hz));
    assign state = activation_state;

    always @(posedge clk_100hz, posedge reset) begin
        if(reset || power_off) begin
            activation_state <= 2'b00;
            timer <= 0;
        end
        else begin 
            case(activation_state) 
                2'b00: begin 
                    if(power_on) begin 
                        activation_state <= 2'b01;
                        timer <= 0;
                    end
                end
                2'b01: begin 
                    if(power_off || ~power_on) begin
                        activation_state <= 2'b00;
                        timer <= 0;
                    end
                    else if(timer != 7'd100) begin 
                        timer <= timer + 1;
                    end
                    else begin
                        activation_state <= 2'b10;
                        timer <= 0;
                    end
                end
                2'b10: begin
                    if(power_off) begin 
                        activation_state <= 2'b00;
                    end
                end
            endcase
        end
    end

  always @(posedge clk) begin
    if(reset) begin
        power_state <= 0;
    end
    else begin 
        if(activation_state == 2'b10)
            power_state <= 1;
        else
            power_state <= 0;
    end
  end
endmodule

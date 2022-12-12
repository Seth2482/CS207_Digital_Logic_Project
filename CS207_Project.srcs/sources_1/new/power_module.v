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
                    input power_on,
                    input power_off,  // 如果其它模块要关闭电源，请通过此接口传入
                    input reset,
                    output reg power_state);
    
    wire clk_1hz;                  // 1hz分频器
    reg [1:0] activation_state;    // 车辆power的状态
                                // 00 等待启动按钮按下
                                // 01 按钮已按下，等待1s后启动
                                // 10 车辆已启动
    
    clk_divider cd1(clk, ~(activation_state == 2'b01), clk_1hz);

    always@(posedge clk, posedge reset) begin //删掉了, power_on ,power_off
        if (reset || power_off) begin
            activation_state <= 2'b00;
            power_state <= 0;
            $display("1");
        end
        else begin
            // 车辆未启动
            $display("2");
            case (activation_state)
                2'b00: begin 
            $display("3");

                    if(power_on) begin
                        activation_state <= 2'b01;
                        power_state <= 0;
                    end
                end
                2'b01: begin
                    if(~power_on) begin
                        activation_state <= 2'b00;
                        power_state <= 0;
                    end
                end
                2'b10: begin 
                    power_state <= 1;
                end
            endcase
        end
    end

    always @(negedge clk_1hz) begin
        if(activation_state == 2'b01) begin
            if(power_on) begin 
                // 启动
                activation_state <= 2'b10;
            end
        end
    end

endmodule

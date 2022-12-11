`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/12/11 13:41:28
// Design Name:
// Module Name: record_display
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


module record_display(input clk,
                      input reset,
                      input power_state,
                      input [23:0] record,
                      output reg [7:0] seg_en,    // enables of 8 lights
                      output [7:0] seg_out0,  // output of first 4 lights
                      output [7:0] seg_out1); // output of last 4 lights
    reg [3:0] num0, num1, num2, num3, num4, num5, num6; // num0 is MSB
    reg [3:0] state;
    reg [7:0] current_num0, current_num1;

    number_translator u_number_translator1(.number(current_num0), .seg_out(seg_out0));
    number_translator u_number_translator2(.number(current_num1), .seg_out(seg_out1));

    
    always@(record) begin
        num0 <= record/1_000_000;
        num1 <= (record%1_000_000_0)/1_000_00;
        num2 <= (record%1_000_000)/1_000_0;
        num3 <= (record%1_000_00)/1_000;
        num4 <= (record%1_000)/1_00;
        num5 <= (record%1_00)/1_0;
        num6 <= (record%1_0);
    end
    
    always@(posedge clk) begin
        if (reset) begin
            state    <= 4'b0000;
            seg_en   <= 8'b0000_0000;
            num0     <= 0;
            num1     <= 0;
            num2     <= 0;
            num3     <= 0;
            num4     <= 0;
            num5     <= 0;
            num6     <= 0;
        end
        else begin
            if (state != 4'b0001)
                state <= state >> 1;
            else
                state <= 4'b1000;
        end
        
    end
    
    always @(posedge clk) begin
        if (power_state) begin
            seg_en <= 8'b0000_0000;
        end
        else begin
            case(state)
                4'b1000: begin
                    current_num0 <= num0;
                    current_num1 <= num4;
                    seg_en <= 8'b1000_1000;
                end
                4'b0100: begin
                    current_num0 <= num1;
                    current_num1 <= num5;
                    seg_en <= 8'b0100_0100;
                end
                4'b0010: begin
                    current_num0 <= num2;
                    current_num1 <= num6;
                    seg_en <= 8'b0010_0010;
                end
                4'b0001: begin
                    current_num0 <= num3;
                    seg_en <= 8'b0001_0000;
                end
            endcase
        end
    end
endmodule

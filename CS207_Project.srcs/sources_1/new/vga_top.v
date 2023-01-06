`timescale 1ns / 1ps

module vga_top(
    input clk_100MHz,       // 100MHz on Basys 3
    input reset,            // btnC
    input [23:0] record,   //你传进来的东西
    input [1:0] mode,
    output hsync,           // to VGA Connector
    output vsync,           // to VGA Connector
    output [11:0] rgb       // to DAC, to VGA Connector
    );
    
    // Internal Connection Signals
    wire [9:0] w_x, w_y;
    wire video_on, p_tick;
    reg [3:0]  n1,n2,n3,n4,n5,n6,n7,n8;
    wire [3:0] num1,num2,num3,num4,num5,num6,num7,num8;
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;

    always@(posedge clk_100MHz) begin
        if (reset) begin
            n1  <= 0;
            n2  <= 0;
            n3  <= 0;
            n4  <= 0;
            n5  <= 0;
            n6  <= 0;
            n7  <= 0;
            n8  <= 0;
        end
        else begin
            // n8 <= record/1_000_0000%10;
            n8 <= mode;
            n7 <= record/1_000_000%10;
            n6 <= record/1_000_00%10;
            n5 <= record/1_000_0%10;
            n4 <= record/1_000%10;
            n3 <= record/1_00%10;
            n2 <= record/1_0%10;
            n1 <= record%10;
        end
    end
    BCD_conventer a1(
        .x(n1),
        .bcd_x(num1)
    );
    BCD_conventer a2(
        .x(n2),
        .bcd_x(num2)
    );
    BCD_conventer a3(
        .x(n3),
        .bcd_x(num3)
    );
    BCD_conventer a4(
        .x(n4),
        .bcd_x(num4)
    );
    BCD_conventer a5(
        .x(n5),
        .bcd_x(num5)
    );
    BCD_conventer a6(
        .x(n6),
        .bcd_x(num6)
    );
    BCD_conventer a7(
        .x(n7),
        .bcd_x(num7)
    );
    BCD_conventer a8(
        .x(n8),
        .bcd_x(num8)
    );

    
    // Instantiate Modules
    vga_controller vga(
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .video_on(video_on),
        .hsync(hsync),
        .vsync(vsync),
        .p_tick(p_tick),
        .x(w_x),
        .y(w_y)
        );

    pixel_clk_gen pclk(
        .clk(clk_100MHz),
        .video_on(video_on),
        .x(w_x),
        .y(w_y),
        .num1(num7),
        .num2(num6),
        .num3(num5),
        .num4(num4),
        .num5(num3),
        .num6(num2),
        .num7(num1),
        .num8(num8),
        .time_rgb(rgb_next)
        );
 
    // rgb buffer
    always @(posedge clk_100MHz)
        if(p_tick)
            rgb_reg <= rgb_next;
            
    // output
    assign rgb = rgb_reg; 
    
endmodule
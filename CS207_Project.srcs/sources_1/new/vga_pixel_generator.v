`timescale 1ns / 1ps

module vga_pixel_generator(
    input clk,
    input video_on,
    input [9:0] x, y,
    input [3:0] num1,num2,num3,num4,num5,num6,num7,num8,num9,
    output reg [11:0] time_rgb
    );
  
    // *** Constant Declarations ***
    localparam NUM1_X_L = 192;
    localparam NUM1_X_R = 223;
    localparam NUM1_Y_T = 192;
    localparam NUM1_Y_B = 256;
    

    localparam NUM2_X_L = 224;
    localparam NUM2_X_R = 255;
    localparam NUM2_Y_T = 192;
    localparam NUM2_Y_B = 256;
    
    localparam NUM3_X_L = 256;
    localparam NUM3_X_R = 287;
    localparam NUM3_Y_T = 192;
    localparam NUM3_Y_B = 256;
    
    localparam NUM4_X_L = 288;
    localparam NUM4_X_R = 319;
    localparam NUM4_Y_T = 192;
    localparam NUM4_Y_B = 256;
    
    localparam NUM5_X_L = 320;
    localparam NUM5_X_R = 351;
    localparam NUM5_Y_T = 192;
    localparam NUM5_Y_B = 256;
    
    localparam NUM6_X_L = 352;
    localparam NUM6_X_R = 383;
    localparam NUM6_Y_T = 192;
    localparam NUM6_Y_B = 256;
    
    localparam NUM7_X_L = 384;
    localparam NUM7_X_R = 415;
    localparam NUM7_Y_T = 192;
    localparam NUM7_Y_B = 256;

    localparam NUM8_X_L = 416;
    localparam NUM8_X_R = 447;
    localparam NUM8_Y_T = 256;
    localparam NUM8_Y_B = 320;
    
    localparam NUM9_X_L = 448;
    localparam NUM9_X_R = 479;
    localparam NUM9_Y_T = 256;
    localparam NUM9_Y_B = 320;

    
    // Object Status Signals
    wire num1_on, num2_on, num3_on, num4_on, num5_on, num6_on, num7_on, num8_on, num9_on;
    
    // ROM Interface Signals
    wire [10:0] rom_addr;
    reg [6:0] char_addr;   // 3'b011 + BCD value 
    wire [6:0] char_addr_num1, char_addr_num2, char_addr_num3, char_addr_num4, char_addr_num5, char_addr_num6, char_addr_num7, char_addr_num8, char_addr_num9;
    reg [3:0] row_addr;    // row address of digit
    wire [3:0] row_addr_num1, row_addr_num2, row_addr_num3, row_addr_num4, row_addr_num5, row_addr_num6, row_addr_num7, row_addr_num8, row_addr_num9;
    reg [2:0] bit_addr;    // column address of rom data
    wire [2:0] bit_addr_num1, bit_addr_num2, bit_addr_num3, bit_addr_num4, bit_addr_num5, bit_addr_num6, bit_addr_num7, bit_addr_num8, bit_addr_num9;
    wire [7:0] digit_word;  // data from rom
    wire digit_bit;
    
    
    assign char_addr_num1 = {3'b011, num1};
    assign row_addr_num1 = y[5:2];   // scaling to 32x64
    assign bit_addr_num1 = x[4:2];   // scaling to 32x64
    
    assign char_addr_num2 = {3'b011, num2};
    assign row_addr_num2 = y[5:2];   
    assign bit_addr_num2 = x[4:2];   
    
    assign char_addr_num7 = {3'b011, num3};
    assign row_addr_num7 = y[5:2];    
    assign bit_addr_num7 = x[4:2];    
    
    assign char_addr_num3 = {3'b011, num4};
    assign row_addr_num3 = y[5:2];   
    assign bit_addr_num3 = x[4:2];   
    
    assign char_addr_num4 = {3'b011, num5};
    assign row_addr_num4 = y[5:2];   
    assign bit_addr_num4 = x[4:2];   
    
    assign char_addr_num8 = {3'b011, num6};
    assign row_addr_num8 = y[5:2];    
    assign bit_addr_num8 = x[4:2];    
    
    assign char_addr_num5 = {3'b011, num7};
    assign row_addr_num5 = y[5:2];   
    assign bit_addr_num5 = x[4:2];   
    
    assign char_addr_num6 = {3'b011, num8};
    assign row_addr_num6 = y[5:2];   
    assign bit_addr_num6 = x[4:2];   

    assign char_addr_num9 = {3'b011, num9};
    assign row_addr_num9 = y[5:2];   
    assign bit_addr_num9 = x[4:2];   
    
    // Instantiate digit rom
    num_digit_rom cdr(.clk(clk), .addr(rom_addr), .data(digit_word));
    
    assign num1_on = (NUM1_X_L <= x) && (x <= NUM1_X_R) &&
                    (NUM1_Y_T <= y) && (y <= NUM1_Y_B);
    assign num2_on =  (NUM2_X_L <= x) && (x <= NUM2_X_R) &&
                    (NUM2_Y_T <= y) && (y <= NUM2_Y_B); 
    assign num3_on = (NUM3_X_L <= x) && (x <= NUM3_X_R) &&
                   (NUM3_Y_T <= y) && (y <= NUM3_Y_B);                              
    assign num4_on = (NUM4_X_L <= x) && (x <= NUM4_X_R) &&
                    (NUM4_Y_T <= y) && (y <= NUM4_Y_B);
    assign num5_on =  (NUM5_X_L <= x) && (x <= NUM5_X_R) &&
                    (NUM5_Y_T <= y) && (y <= NUM5_Y_B);                                 
    assign num6_on = (NUM6_X_L <= x) && (x <= NUM6_X_R) &&
                   (NUM6_Y_T <= y) && (y <= NUM6_Y_B);
    assign num7_on = (NUM7_X_L <= x) && (x <= NUM7_X_R) &&
                    (NUM7_Y_T <= y) && (y <= NUM7_Y_B);
    assign num8_on =  (NUM8_X_L <= x) && (x <= NUM8_X_R) &&
                    (NUM8_Y_T <= y) && (y <= NUM8_Y_B);                          
    assign num9_on =  (NUM9_X_L <= x) && (x <= NUM9_X_R) &&
                    (NUM9_Y_T <= y) && (y <= NUM9_Y_B); 
        
    // Mux for ROM Addresses and RGB    
    always @* begin
        time_rgb = 12'h222;             // black background
        if(num1_on) begin
            char_addr = char_addr_num1;
            row_addr = row_addr_num1;
            bit_addr = bit_addr_num1;
            if(digit_bit)
                time_rgb = 12'hF00;     // red
        end
        else if(num2_on) begin
            char_addr = char_addr_num2;
            row_addr = row_addr_num2;
            bit_addr = bit_addr_num2;
            if(digit_bit)
                time_rgb = 12'hF00;     // red
        end
        else if(num3_on) begin
            char_addr = char_addr_num7;
            row_addr = row_addr_num7;
            bit_addr = bit_addr_num7;
            if(digit_bit)
                time_rgb = 12'hF00;     // red
        end
        else if(num4_on) begin
            char_addr = char_addr_num3;
            row_addr = row_addr_num3;
            bit_addr = bit_addr_num3;
            if(digit_bit)
                time_rgb = 12'hF00;     // red
        end
        else if(num5_on) begin
            char_addr = char_addr_num4;
            row_addr = row_addr_num4;
            bit_addr = bit_addr_num4;
            if(digit_bit)
                time_rgb = 12'hF00;     // red
        end
        else if(num6_on) begin
            char_addr = char_addr_num8;
            row_addr = row_addr_num8;
            bit_addr = bit_addr_num8;
            if(digit_bit)
                time_rgb = 12'hF00;     // red
        end
        else if(num7_on) begin
            char_addr = char_addr_num5;
            row_addr = row_addr_num5;
            bit_addr = bit_addr_num5;
            if(digit_bit)
                time_rgb = 12'hF00;     // red
        end
        else if(num8_on) begin
            char_addr = char_addr_num6;
            row_addr = row_addr_num6;
            bit_addr = bit_addr_num6;
            if(digit_bit)
                time_rgb = 12'hF00;     // red
        end  
        else if(num9_on) begin
            char_addr = char_addr_num9;
            row_addr = row_addr_num9;
            bit_addr = bit_addr_num9;
            if(digit_bit)
                time_rgb = 12'hF00;     // red
        end  
    end    
    
    // ROM Interface    
    assign rom_addr = {char_addr, row_addr};
    assign digit_bit = digit_word[~bit_addr];
                          
endmodule
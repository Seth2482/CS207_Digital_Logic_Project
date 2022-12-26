`timescale 1ns / 1ps

module pixel_clk_gen(
    input clk,
    input video_on,
    //input tick_1Hz,       // use signal if blinking colon(s) is desired
    input [9:0] x, y,
    input [3:0] num1,num2,num3,num4,num5,num6,num7,num8,
    output reg [11:0] time_rgb
    );
  
    // *** Constant Declarations ***
    localparam A1_X_L = 192;
    localparam A1_X_R = 223;
    localparam A1_Y_T = 192;
    localparam A1_Y_B = 256;
    

    localparam A2_X_L = 224;
    localparam A2_X_R = 255;
    localparam A2_Y_T = 192;
    localparam A2_Y_B = 256;
    
    localparam C1_X_L = 256;
    localparam C1_X_R = 287;
    localparam C1_Y_T = 192;
    localparam C1_Y_B = 256;
    
    localparam B1_X_L = 288;
    localparam B1_X_R = 319;
    localparam B1_Y_T = 192;
    localparam B1_Y_B = 256;
    
    localparam B2_X_L = 320;
    localparam B2_X_R = 351;
    localparam B2_Y_T = 192;
    localparam B2_Y_B = 256;
    
    localparam C2_X_L = 352;
    localparam C2_X_R = 383;
    localparam C2_Y_T = 192;
    localparam C2_Y_B = 256;
    
    localparam D1_X_L = 384;
    localparam D1_X_R = 415;
    localparam D1_Y_T = 192;
    localparam D1_Y_B = 256;
    
    localparam D2_X_L = 416;
    localparam D2_X_R = 447;
    localparam D2_Y_T = 192;
    localparam D2_Y_B = 256;
    
    // Object Status Signals
    wire A1_on, A2_on, C1_on, B1_on, B2_on, C2_on, D1_on, D2_on;
    
    // ROM Interface Signals
    wire [10:0] rom_addr;
    reg [6:0] char_addr;   // 3'b011 + BCD value of time component
    wire [6:0] char_addr_a1, char_addr_a2, char_addr_b1, char_addr_b2, char_addr_d1, char_addr_d2, char_addr_c1, char_addr_c2;
    reg [3:0] row_addr;    // row address of digit
    wire [3:0] row_addr_a1, row_addr_a2, row_addr_b1, row_addr_b2, row_addr_d1, row_addr_d2, row_addr_c1, row_addr_c2;
    reg [2:0] bit_addr;    // column address of rom data
    wire [2:0] bit_addr_a1, bit_addr_a2, bit_addr_b1, bit_addr_b2, bit_addr_d1, bit_addr_d2, bit_addr_c1, bit_addr_c2;
    wire [7:0] digit_word;  // data from rom
    wire digit_bit;
    
    
    assign char_addr_a1 = {3'b011, num1};
    assign row_addr_a1 = y[5:2];   // scaling to 32x64
    assign bit_addr_a1 = x[4:2];   // scaling to 32x64
    
    assign char_addr_a2 = {3'b011, num2};
    assign row_addr_a2 = y[5:2];   // scaling to 32x64
    assign bit_addr_a2 = x[4:2];   // scaling to 32x64
    
    assign char_addr_c1 = {3'b011, num3};//!!!!!!
    assign row_addr_c1 = y[5:2];    // scaling to 32x64
    assign bit_addr_c1 = x[4:2];    // scaling to 32x64
    
    assign char_addr_b1 = {3'b011, num4};
    assign row_addr_b1 = y[5:2];   // scaling to 32x64
    assign bit_addr_b1 = x[4:2];   // scaling to 32x64
    
    assign char_addr_b2 = {3'b011, num5};
    assign row_addr_b2 = y[5:2];   // scaling to 32x64
    assign bit_addr_b2 = x[4:2];   // scaling to 32x64
    
    assign char_addr_c2 = {3'b011, num6};// !!!!!
    assign row_addr_c2 = y[5:2];    // scaling to 32x64
    assign bit_addr_c2 = x[4:2];    // scaling to 32x64
    
    assign char_addr_d1 = {3'b011, num7};
    assign row_addr_d1 = y[5:2];   // scaling to 32x64
    assign bit_addr_d1 = x[4:2];   // scaling to 32x64
    
    assign char_addr_d2 = {3'b011, num8};
    assign row_addr_d2 = y[5:2];   // scaling to 32x64
    assign bit_addr_d2 = x[4:2];   // scaling to 32x64
    
    // Instantiate digit rom
    num_digit_rom cdr(.clk(clk), .addr(rom_addr), .data(digit_word));
    
    // Hour sections assert signals
    assign A1_on = (A1_X_L <= x) && (x <= A1_X_R) &&
                    (A1_Y_T <= y) && (y <= A1_Y_B);
    assign A2_on =  (A2_X_L <= x) && (x <= A2_X_R) &&
                    (A2_Y_T <= y) && (y <= A2_Y_B);
    
    // Colon 1 ROM assert signals
    assign C1_on = (C1_X_L <= x) && (x <= C1_X_R) &&
                   (C1_Y_T <= y) && (y <= C1_Y_B);
                               
    // Minute sections assert signals
    assign B1_on = (B1_X_L <= x) && (x <= B1_X_R) &&
                    (B1_Y_T <= y) && (y <= B1_Y_B);
    assign B2_on =  (B2_X_L <= x) && (x <= B2_X_R) &&
                    (B2_Y_T <= y) && (y <= B2_Y_B);                             
    
    // Colon 2 ROM assert signals
    assign C2_on = (C2_X_L <= x) && (x <= C2_X_R) &&
                   (C2_Y_T <= y) && (y <= C2_Y_B);
                  
    // Second sections assert signals
    assign D1_on = (D1_X_L <= x) && (x <= D1_X_R) &&
                    (D1_Y_T <= y) && (y <= D1_Y_B);
    assign D2_on =  (D2_X_L <= x) && (x <= D2_X_R) &&
                    (D2_Y_T <= y) && (y <= D2_Y_B);
                          
        
    // Mux for ROM Addresses and RGB    
    always @* begin
        time_rgb = 12'h222;             // black background
        if(A1_on) begin
            char_addr = char_addr_a1;
            row_addr = row_addr_a1;
            bit_addr = bit_addr_a1;
            if(digit_bit)
                time_rgb = 12'hF00;     // red
        end
        else if(A2_on) begin
            char_addr = char_addr_a2;
            row_addr = row_addr_a2;
            bit_addr = bit_addr_a2;
            if(digit_bit)
                time_rgb = 12'hF00;     // red
        end
        else if(C1_on) begin
            char_addr = char_addr_c1;
            row_addr = row_addr_c1;
            bit_addr = bit_addr_c1;
            if(digit_bit)
                time_rgb = 12'hF00;     // red
        end
        else if(B1_on) begin
            char_addr = char_addr_b1;
            row_addr = row_addr_b1;
            bit_addr = bit_addr_b1;
            if(digit_bit)
                time_rgb = 12'hF00;     // red
        end
        else if(B2_on) begin
            char_addr = char_addr_b2;
            row_addr = row_addr_b2;
            bit_addr = bit_addr_b2;
            if(digit_bit)
                time_rgb = 12'hF00;     // red
        end
        else if(C2_on) begin
            char_addr = char_addr_c2;
            row_addr = row_addr_c2;
            bit_addr = bit_addr_c2;
            if(digit_bit)
                time_rgb = 12'hF00;     // red
        end
        else if(D1_on) begin
            char_addr = char_addr_d1;
            row_addr = row_addr_d1;
            bit_addr = bit_addr_d1;
            if(digit_bit)
                time_rgb = 12'hF00;     // red
        end
        else if(D2_on) begin
            char_addr = char_addr_d2;
            row_addr = row_addr_d2;
            bit_addr = bit_addr_d2;
            if(digit_bit)
                time_rgb = 12'hF00;     // red
        end  
    end    
    
    // ROM Interface    
    assign rom_addr = {char_addr, row_addr};
    // assign digit_bit = digit_word[~bit_addr];    //??用于反向的，我们应该不需要
                          
endmodule
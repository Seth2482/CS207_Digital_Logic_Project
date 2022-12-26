`timescale 1ns / 1ps
module BCD_conventer(
    input x,
    output reg [3:0] bcd_x
);

always@(*)
begin
    case(x)
    0:bcd_x <= 4'b0000;
    1:bcd_x <= 4'b0001;
    2:bcd_x <= 4'b0010;
    3:bcd_x <= 4'b0011;
    4:bcd_x <= 4'b0100;
    5:bcd_x <= 4'b0101;
    6:bcd_x <= 4'b0110;
    7:bcd_x <= 4'b0111;
    8:bcd_x <= 4'b1000;
    9:bcd_x <= 4'b1001;

    endcase
end





 endmodule
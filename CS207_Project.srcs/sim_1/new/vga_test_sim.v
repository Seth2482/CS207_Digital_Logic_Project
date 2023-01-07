//~ `New testbench
`timescale  1ns / 1ps

module vga_test_sim;

// vga_test Parameters
parameter PERIOD  = 10;


// vga_test Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;

// vga_test Outputs
wire  [11:0]  rgb                          ;
wire  hsync                                ;
wire  vsync                                ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

vga_test  u_vga_test (
    .clk                     ( clk           ),
    .rst_n                   ( rst_n         ),

    .rgb                     ( rgb    [11:0] ),
    .hsync                   ( hsync         ),
    .vsync                   ( vsync         )
);

initial
begin

    #20000000 $finish;
end

endmodule
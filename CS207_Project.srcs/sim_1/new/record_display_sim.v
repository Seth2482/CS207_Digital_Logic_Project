`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/14 13:35:15
// Design Name: 
// Module Name: record_display_sim
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


module record_display_sim;

// record_display Parameters
parameter PERIOD  = 10;


// record_display Inputs
reg   clk                                  = 0 ;
reg   reset                                = 1 ;
reg   power_state                          = 0 ;
reg   [23:0]  record                       = 0 ;

// record_display Outputs
wire  [7:0]  seg_en                        ;
wire  [7:0]  seg_out0                      ;
wire  [7:0]  seg_out1                      ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) reset  =  0;
    power_state = 1;
end

record_display  u_record_display (
    .clk                     ( clk                 ),
    .reset                   ( reset               ),
    .power_state             ( power_state         ),
    .record                  ( record       [23:0] ),

    .seg_en                  ( seg_en       [7:0]  ),
    .seg_out0                ( seg_out0     [7:0]  ),
    .seg_out1                ( seg_out1     [7:0]  )
);
defparam u_record_display.u_clk_1000hz.period = 10;

reg [3:0] running_number = 4'b0000;
reg [7:0] cnt = 0;
initial
begin
    while (cnt != 8'd7) begin
        cnt = cnt + 1;
        if(running_number != 4'd9) begin 
            running_number = running_number + 1;
        end else 
            running_number = 4'b0000;
        #1000 record = record * 10 + running_number;
    end
    #10000 $finish;
end

endmodule

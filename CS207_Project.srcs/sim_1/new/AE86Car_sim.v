`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/11 23:31:14
// Design Name: 
// Module Name: AE86Car_sim
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


module AE86Car_sim;

// AE86Car Parameters
parameter PERIOD = 10  ;
parameter On  = 1'b1;

// AE86Car Inputs
reg   clk                                  = 0 ;
reg   power_on                             = 0 ;
reg   power_off                            = 0 ;
reg   throttle                             = 0 ;
reg   clutch                               = 0 ;
reg   brake                                = 0 ;
reg   reverse_gear                         = 0 ;
reg   turn_left                            = 0 ;
reg   turn_right                           = 0 ;
reg   turn_left_Semi                       = 0 ;
reg   turn_right_Semi                      = 0 ;
reg   go_straight_Semi                     = 0 ;
reg   rst_n                                = 0 ;
reg   rx                                   = 0 ;
reg   [1:0]  mode_selection                = 0 ;

// AE86Car Outputs
wire  tx                                   ;
wire  turn_left_light                      ;
wire  turn_right_light                     ;
wire  [7:0]  seg_en                        ;
wire  [7:0]  seg_out0                      ;
wire  [7:0]  seg_out1                      ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

AE86Car #(
    .On ( On ))
 u_AE86Car (
    .clk                     ( clk                     ),
    .power_on                ( power_on                ),
    .power_off               ( power_off               ),
    .throttle                ( throttle                ),
    .clutch                  ( clutch                  ),
    .brake                   ( brake                   ),
    .reverse_gear            ( reverse_gear            ),
    .turn_left               ( turn_left               ),
    .turn_right              ( turn_right              ),
    .turn_left_Semi          ( turn_left_Semi          ),
    .turn_right_Semi         ( turn_right_Semi         ),
    .go_straight_Semi        ( go_straight_Semi        ),
    .rst_n                   ( rst_n                   ),
    .rx                      ( rx                      ),
    .mode_selection          ( mode_selection    [1:0] ),

    .tx                      ( tx                      ),
    .turn_left_light         ( turn_left_light         ),
    .turn_right_light        ( turn_right_light        ),
    .seg_en                  ( seg_en            [7:0] ),
    .seg_out0                ( seg_out0          [7:0] ),
    .seg_out1                ( seg_out1          [7:0] )
);
defparam u_AE86Car.u_power_module.cd1.period = 100;
initial
begin
    #(5*PERIOD) power_on = 1;
    #(1500) power_on = 0;

    #(1000) mode_selection = 2'b01;
    #1000 {throttle,brake,clutch}=3'b101;
    #4000 {throttle,brake,clutch}=3'b100;


    #5000 $finish;
end

endmodule

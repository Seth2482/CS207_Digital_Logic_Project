//~ `New testbench
`timescale  1ns / 1ps

module tb_SemiAutoDriving;

// SemiAutoDriving Parameters
parameter PERIOD  = 10;


// SemiAutoDriving Inputs
reg   turn_left__Semi                      = 0 ;
reg   turn_right_Semi                      = 0 ;
reg   go_straight_Semi                     = 0 ;
reg   clk                                  = 0 ;
reg   reset                                = 1 ;
reg   back_detector                        = 0 ;
reg   left_detector                        = 0 ;
reg   right_detector                       = 0 ;
reg   front_detector                       = 0 ;
reg   wire_clk_5hz                         = 0 ;

// SemiAutoDriving Outputs
wire  turn_left_signal                     ;
wire  turn_right_signal                    ;
wire  move_forward_signal                  ;
wire  move_backward_signal                 ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) reset  =  0;
    



end

SemiAutoDriving  u_SemiAutoDriving (
    .turn_left__Semi         ( turn_left__Semi        ),
    .turn_right_Semi         ( turn_right_Semi        ),
    .go_straight_Semi        ( go_straight_Semi       ),
    .clk                     ( clk                    ),
    .reset                   ( reset                  ),
    .back_detector           ( back_detector          ),
    .left_detector           ( left_detector          ),
    .right_detector          ( right_detector         ),
    .front_detector          ( front_detector         ),
    .wire_clk_5hz            ( wire_clk_5hz           ),

    .turn_left_signal        ( turn_left_signal       ),
    .turn_right_signal       ( turn_right_signal      ),
    .move_forward_signal     ( move_forward_signal    ),
    .move_backward_signal    ( move_backward_signal   )
);


endmodule
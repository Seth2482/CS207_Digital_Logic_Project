`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/07 17:10:13
// Design Name: 
// Module Name: Semi-Auto Driving
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


module SemiAutoDriving(
    input turn_left_Semi,            // 左转 switch
    input turn_right_Semi,           // 右转 switch
    input go_straight_Semi,
    input clk,
    output reg turn_left_signal,
    output reg turn_right_signal,
    output reg move_forward_signal,
    output reg move_backward_signal,
    input reset,
    input back_detector,
    input left_detector,
    input right_detector,
    input front_detector
    );
    wire clk_5hz;
    reg [2:0] state;// 000 auto drive
                    // 010 waiting for command
                    // 100 turn left 
                    // 001 turn right
                    //011 turning right
                    //110 turning left
                    // 111 go straight
    clk_divider #(.period(20000000)) cd5(clk, ~(activation_state == 2'b01), clk_5hz);

    always @(posedge clk) 
    begin
    if (reset) begin
        state <= 3'b000;
    end
    else begin
        case(state)
        3'b000: begin 
        //      if(~front_detector&&~left_detector&&~right_detector||front_detector&&~left_detector&&~right_detector||
        // left_detector&&~right_detector&&~front_detector||right_detector&&~left_detector&&~front_detector)//遇到了路口  4种情况
        if(~(~front_detector&&left_detector&&right_detector))///???????????????????????????????????????????
                begin
                    state <= 3'b010;// waiting for command
                end
        end
        3'b010: begin // command state
            if(go_straight_Semi)
            begin
                state<=3'b111;// also go straight.
            end
            if(turn_left_Semi)
            begin
                state<=3'b100;
            end
            if(turn_right_Semi)
            begin
                state<=3'b001;
            end
        end
        3'b001: begin
            if(right_detector)//1 conveys there is an obstical
            begin//有没有需要把小车转回去？
                state<=3'b010;// waiting for 
            end
        end
        3'b100: begin
            if(left_detector)
            begin
                state<=3'b010;// waiting for 
            end

        end
        3'b111: begin
            if(front_detector)
            begin
                state<=3'b010;// waiting for 
            end
            // if(~front_detector)
            // begin
            //     state<=3'b000;//go straigt
            // end
        end
        endcase
    end
end

always@(posedge clk_5hz)
       begin
        case(state)
            3'b001: state<= 3'b011;
            3'b011: state<= 3'b000;
            3'b100: state<= 3'b110;
            3'b110: state<= 3'b000;
            3'b111: state<= 3'b000;

        endcase

 end


    always@ (posedge clk)// 灯是怎么亮的
    begin
        case(state)
        3'b011:turn_right_signal<=1'b1;
        3'b110:turn_left_signal<=1'b1;
        3'b111:move_forward_signal<=1'b1;
        3'b000:move_forward_signal<=1'b1;
        endcase
    end


endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/21 17:24:09
// Design Name: 
// Module Name: semi_auto2
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


module semi_auto2(input turn_left_semi,            // 左转 button
                 input turn_right_semi,           // 右转 button
                 input go_straight_semi,
                 input turn_back_semi,
                 input clk,
                 output reg turn_left_signal,
                 output reg turn_right_signal,
                 output reg move_forward_signal,
                 output reg move_backward_signal,
                 input reset,
                 input back_detector,
                 input left_detector,
                 input right_detector,
                 input front_detector);
    reg [2:0] semi_state;//000 waiting,001 turning right
    //010 turning left,011 going straight,100 turning back
    reg [7:0] counter;
    wire clk_10hz;
    clk_divider #(.period(10000000)) cd5(.clk(clk), .reset(reset), .clk_out(clk_10hz));
    wire clk_100hz;
    clk_divider #(.period(1000000)) cd6(.clk(clk), .reset(reset), .clk_out(clk_100hz));

    
    

    wire [3:0] detectors;
    assign detectors={back_detector,front_detector,left_detector,right_detector};//后前左右，碰到障碍物为1


    always @(posedge clk_100hz) begin
        if (reset) begin
            semi_state<=3'b011;
            counter<=8'b00000000;
            {move_backward_signal,move_forward_signal,turn_left_signal,turn_right_signal}<=4'b0000;



        end
        else begin
                counter<=counter+1'b1;
            case(semi_state)
            3'b000:begin
                if (go_straight_semi) begin
                        semi_state <= 3'b011;
                        counter<=8'b00000000;
                    end
                    else if (turn_right_semi) begin
                        semi_state <= 3'b001;
                        counter<=8'b00000000;
                    end
                    else if (turn_left_semi) begin
                        semi_state <= 3'b010;
                        counter<=8'b00000000;
                    end
                    
                    else if(turn_back_semi) begin
                        semi_state<=3'b100;
                        counter<=8'b00000000;
                    end
            end
            3'b001:begin
                if (counter>=8'd90) begin
                    if (front_detector==0) begin
                        semi_state <= 3'b011;
                        counter<=8'b00000000;
                    end
                end


            end

            3'b010:begin

                if (counter>=8'd90) begin
                    if (front_detector==0) begin
                        semi_state <= 3'b011;
                        counter<=8'b00000000;
                    end
                end

            end

            3'b011:begin
                if (counter>=8'd90) begin
                    if (detectors==4'b0100||detectors==4'b0010||
                    detectors==4'b0001||detectors==4'b01000) begin
                        semi_state<=3'b000;
                        counter<=8'b00000000;
                    end 
                    else if (detectors==4'b0110) begin                        
                        semi_state <= 3'b001;
                        counter<=8'b00000000;   
                    end 
                    else if (detectors==4'b0101) begin
                        semi_state <= 3'b010;
                        counter<=8'b00000000;
                    end
                    else if (detectors==4'b0111) begin
                        semi_state<=3'b100;
                        counter<=8'b00000000;
                    end
                end

            end

            3'b100:begin
                if (counter>=8'd180) begin
                     semi_state <= 3'b011;
                        counter<=8'b00000000;
                end               
            end

            endcase

            case (semi_state)
                3'b000:  {move_backward_signal,move_forward_signal,turn_left_signal,turn_right_signal}<=4'b0000;
                3'b001:  {move_backward_signal,move_forward_signal,turn_left_signal,turn_right_signal}<=4'b0001;
                3'b010:  {move_backward_signal,move_forward_signal,turn_left_signal,turn_right_signal}<=4'b0010;
                3'b011:  {move_backward_signal,move_forward_signal,turn_left_signal,turn_right_signal}<=4'b0100;
                3'b100:  {move_backward_signal,move_forward_signal,turn_left_signal,turn_right_signal}<=4'b0001;
                default: {move_backward_signal,move_forward_signal,turn_left_signal,turn_right_signal}<={move_backward_signal,move_forward_signal,turn_left_signal,turn_right_signal};
            endcase
            


        end
        
    end
    // always @(posedge clk_10hz ) begin
    //     counter<=counter+1'b1;
    // end



    
endmodule

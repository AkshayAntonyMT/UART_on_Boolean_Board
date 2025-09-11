`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2025 10:02:36 PM
// Design Name: 
// Module Name: txx
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


module txx(
input clk,
input [7:0] data_in,
//output reg next = 1,
output reg tx  
);
 
 //parameters for setting baud rate
parameter  bit_period = 100_000_000 / 115200;       //clock_frequency/baud_rate

//paremeters for setting states
parameter IDLE  = 0;
parameter START = 1;
parameter DATA  = 2;
parameter STOP  = 3;

//registers
reg [1:0] state    = IDLE;
reg [30:0] clk_count = 0;
integer bit_index  = 0;


always@(posedge clk)
begin
    case(state)
    IDLE:begin
        tx <= 1;
        if (clk_count < 5)
            clk_count <= clk_count +1;
        else begin
        clk_count <= 0;
        bit_index <= 0;
        //next <= 0;                             
        state <= START;
        end
        end
    START:begin
          tx <= 0;
          if (clk_count < bit_period)
            clk_count <= clk_count +1;
          else 
            begin
            clk_count <= 0;
            state <= DATA;
            end
          end
    DATA:begin
         tx <= data_in[bit_index];
         if (clk_count < bit_period)
            clk_count <= clk_count +1;
         else 
            begin
            clk_count <= 0;
            if (bit_index < 7)
            bit_index <= bit_index + 1;
            else
                state <= STOP;
            end
         end
     STOP:begin
          tx <= 1;
          if (clk_count < bit_period)
            clk_count <= clk_count +1;
          else 
            begin
            clk_count<= 0;
            bit_index <= 0;
            //next <= 1;
            state <= IDLE;                                
            end
          end
    endcase
end
endmodule

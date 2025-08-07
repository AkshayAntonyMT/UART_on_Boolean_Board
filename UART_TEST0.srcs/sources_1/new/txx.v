`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 11:14:00 PM
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
input start_tx,
input [7:0] data_in,
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
reg [1:0] state      = IDLE;
reg [15:0] clk_count = 0;
reg [2:0] bit_index  = 0;
reg [7:0] tx_data    = 8'd0;

//always block
always@(posedge clk)
begin
    case(state)
    IDLE:begin
        tx <= 1;
        clk_count <= 0;
        bit_index <= 0;
        if (start_tx)                       //ith aavshyam illa.ith illelum data transfer aavilla
            begin                           //ee start or switch akki kodkkand puthiya value read avumbo transmitt enable aavanam.
            tx_data <= data_in;             
            state <= START;
            end
        end
    START:begin
          tx <= 0;
          if (clk_count < bit_period - 1)
            clk_count <= clk_count +1;
          else 
            begin
            clk_count <= 0;
            state <= DATA;
            end
          end
    DATA:begin
         tx <= tx_data[bit_index];
         if (clk_count < bit_period - 1)
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
          if (clk_count < bit_period - 1)
            clk_count <= clk_count +1;
          else 
            begin
            clk_count<= 0;
            bit_index <= 0;
            state <= IDLE;          //oru byte transmit cheyth kazhinj maathram read adress increment cheyth adtha value read aakkanam.
            end
          end
    endcase
end
endmodule

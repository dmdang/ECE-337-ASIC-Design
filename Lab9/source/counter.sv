// $Id: $
// File name:   counter.sv
// Created:     10/4/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: counter
 
module counter
(
	input wire clk,
	input wire n_rst,
	input wire cnt_up,
	input wire clear,
	output reg one_k_samples
);

reg [9:0] rollover_val1;

flex_counter #(10) COUNTER (.clk(clk), .n_rst(n_rst), .clear(clear), .count_enable(cnt_up), .rollover_val(10'b1111101000), .count_out(rollover_val1), .rollover_flag(one_k_samples));

endmodule 
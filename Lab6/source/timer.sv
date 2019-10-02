// $Id: $
// File name:   timer.sv
// Created:     9/30/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: timer

module timer
(
	input wire clk,
	input wire n_rst,
	input wire enable_timer,
	output reg shift_enable,
	output reg packet_done
);

reg [3:0] rollover_val1;
reg [3:0] rollover_val2;

flex_counter COUNT_CLOCK (.clk(clk), .n_rst(n_rst), .clear(packet_done), .count_enable(enable_timer), .rollover_val(4'b1010), .count_out(rollover_val1), .rollover_flag(shift_enable)); 

flex_counter COUNT_BIT (.clk(clk), .n_rst(n_rst), .clear(packet_done), .count_enable(shift_enable), .rollover_val(4'b1001), .count_out(rollover_val2), .rollover_flag(packet_done));


endmodule 
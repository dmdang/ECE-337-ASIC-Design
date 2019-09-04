// $Id: $
// File name:   adder_1bit.sv
// Created:     9/2/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: adder_1bit

module adder_1bit
(
	input wire a,
	input wire b,
	input wire carry_in,
	output wire sum,
	output wire carry_out
);

assign sum = carry_in ^ (a ^ b);
assign carry_out = ((!carry_in) & b & a) | (carry_in & (b | a));

endmodule 
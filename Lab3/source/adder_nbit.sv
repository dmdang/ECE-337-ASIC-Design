// $Id: $
// File name:   adder_nbit.sv
// Created:     9/3/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: adder_nbit
`timescale 1ns / 100ps
module adder_nbit
#(
	parameter BIT_WIDTH = 4
)
(
	input wire [BIT_WIDTH-1:0] a,
	input wire [BIT_WIDTH-1:0] b,
	input wire carry_in,
	output wire [BIT_WIDTH-1:0] sum,
	output wire overflow
);

	//Input validation
	integer x;
	always @ (a, b) begin
		for (x = 0; x <= BIT_WIDTH-1; x = x + 1) begin

			assert((a[x] == 1'b1) || (a[x] == 1'b0))
			else $error("input validation: Input 'a' of component is not a digital logic value");

			assert((b[x] == 1'b1) || (b[x] == 1'b0))
			else $error("input validation: Input 'b' of component is not a digital logic value");

			assert((carry_in == 1'b1) || (carry_in == 1'b0))
			else $error("carry_in is incorrect"); 

		end

	end

	// n bit adder
	wire [BIT_WIDTH:0] carrys;
	genvar i;

	assign carrys[0] = carry_in;
	generate
	for (i = 0; i <= BIT_WIDTH-1; i = i + 1) begin
	
		adder_1bit IX (.a(a[i]), .b(b[i]), .carry_in(carrys[i]), .sum(sum[i]), .carry_out(carrys[i+1]));

	end

	endgenerate

	integer y;
	always @ (a, b, carrys) begin
		for (y = 0; y <= BIT_WIDTH-1; y = y + 1) begin
			#(2) assert(((a[y] + b[y] + carrys[y]) % 2) == sum[y])
			else $error("n_bit_adder: Output 's' of 1 bit adder is not correct");
		end
	end


	assign overflow = carrys[BIT_WIDTH];

endmodule 
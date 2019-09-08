// 337 TA Provided Lab 2 8-bit adder wrapper file template
// This code serves as a template for the 8-bit adder design wrapper file 
// STUDENT: Replace this message and the above header section with an
// appropriate header based on your other code files

module adder_16bit
(
	input wire [15:0] a,
	input wire [15:0] b,
	input wire carry_in,
	output wire [15:0] sum,
	output wire overflow
);

	// STUDENT: Fill in the correct port map with parameter override syntax for using your n-bit ripple carry adder design to be an 8-bit ripple carry adder design

	//Input validation
	integer x;
	always @ (a, b) begin
		for (x = 0; x <= 15; x = x + 1) begin

			assert((a[x] == 1'b1) || (a[x] == 1'b0))
			else $error("input validation: Input 'a' of component is not a digital logic value");

			assert((b[x] == 1'b1) || (b[x] == 1'b0))
			else $error("input validation: Input 'b' of component is not a digital logic value");

			assert((carry_in == 1'b1) || (carry_in == 1'b0))
			else $error("carry_in is incorrect");

		end

	end

	adder_nbit #(.BIT_WIDTH(16)) IX (.a(a), .b(b), .carry_in(carry_in), .sum(sum), .overflow(overflow));
	
endmodule

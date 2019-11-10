// $Id: $
// File name:   magnitude.sv
// Created:     10/4/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: magnitude

module magnitude
(
	input wire [16:0] in,
	output reg [15:0] out
);

reg [16:0] temp;

always_comb begin

	if (in[16] == 1) begin

		temp = in - 1;
		temp = ~temp;
		out = temp[15:0];
	end
	else begin

		out = in[15:0];
	end

end


endmodule 
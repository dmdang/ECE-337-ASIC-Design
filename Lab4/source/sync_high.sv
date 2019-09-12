// $Id: $
// File name:   sync_high.sv
// Created:     9/11/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: sync_high

module sync_high
(
	input reg clk,
	input reg n_rst,
	input reg async_in,
	output wire sync_out
);

reg ff1out;
reg out;

always_ff @ (posedge clk, negedge n_rst) begin

	if (1'b0 == n_rst) begin

		ff1out <= 1'b1;
		out <= 1'b1;
	end
	else begin

		ff1out <= async_in;
		out <= ff1out;
	end
end

assign sync_out = out;


endmodule 
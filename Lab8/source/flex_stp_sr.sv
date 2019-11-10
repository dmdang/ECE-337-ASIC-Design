// $Id: $
// File name:   flex_stp_sr.sv
// Created:     9/19/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: flex_stp_sr

module flex_stp_sr
#(
	parameter NUM_BITS = 4,
	parameter SHIFT_MSB = 1
)
(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire serial_in,
	output reg [NUM_BITS-1:0] parallel_out
);

reg [NUM_BITS-1:0] nxtParallel_out;

always_ff @ (posedge clk, negedge n_rst) begin

	if (!n_rst) begin

		parallel_out <= '1;
	end
	else begin
	
		parallel_out <= nxtParallel_out;
	end
end

always_comb begin

	nxtParallel_out = parallel_out;

	if (shift_enable == 1) begin

		if (SHIFT_MSB == 1) begin

			nxtParallel_out = {parallel_out[NUM_BITS-2:0], serial_in};
		end
		else begin
			
			nxtParallel_out = {serial_in, parallel_out[NUM_BITS-1:1]};
		end
	end
	

end

endmodule 
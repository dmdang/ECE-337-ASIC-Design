// $Id: $
// File name:   flex_counter.sv
// Created:     9/16/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: flex_counter

module flex_counter
#(
	parameter NUM_CNT_BITS = 4
)
(
	input reg clk,
	input reg n_rst,
	input reg clear,
	input reg count_enable,
	input reg [NUM_CNT_BITS-1:0] rollover_val,
	output reg [NUM_CNT_BITS-1:0] count_out,
	output reg rollover_flag
);

// intermediate values
reg [NUM_CNT_BITS-1:0] nxtCount_out;
reg nxtRollover_flag;

always_ff @ (posedge clk, negedge n_rst) begin

	if (1'b0 == n_rst) begin

		count_out <= '0;
		rollover_flag <= 1'b0;
	end
	else begin

		count_out <= nxtCount_out;
		rollover_flag <= nxtRollover_flag;
	end


end

always_comb begin

	nxtCount_out = count_out;
	nxtRollover_flag = 0;

	if (clear) begin
		
		nxtCount_out = '0;
		nxtRollover_flag = 0;
	end
	else if (count_enable) begin
		if (rollover_flag == 0) begin
		
			nxtCount_out = count_out + 1;
		end


		else if (rollover_flag == 1) begin
		
			nxtCount_out = 1;
		end


		if (nxtCount_out == rollover_val) begin
		
			nxtRollover_flag = 1;
		end

	end

	if (!count_enable) begin
		
		if (count_out == rollover_val) begin
		
			nxtRollover_flag = 1;
		end	
	end


end
endmodule




 
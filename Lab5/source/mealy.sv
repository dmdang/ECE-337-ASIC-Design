// $Id: $
// File name:   mealy.sv
// Created:     9/24/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: mealy

module mealy
(
	input wire clk,
	input wire n_rst,
	input wire i,
	output reg o
);

typedef enum bit [2:0] {state0, state1, state2, idle} stateType; 
stateType state;
stateType nxtState;

always_ff @ (posedge clk, negedge n_rst)
begin : REG_LOGIC

	if (!n_rst) begin

		state <= idle;
	end
	else begin

		state <= nxtState;
	end

end

always_comb
begin : NXT_LOGIC

	nxtState = state;

	case(state)
		idle:
		begin
			if (i == 0) begin
				nxtState = idle;
			end
			else if (i == 1) begin
				nxtState = state0;
			end
		end

		state0:
		begin
			if (i == 0) begin
				nxtState = idle;
			end
			else if (i == 1) begin
				nxtState = state1;
			end
		end

		state1:
		begin
			if (i == 0) begin
				nxtState = state2;
			end
			else if (i == 1) begin
				nxtState = state1; 
			end
		end

		state2:
		begin
			if (i == 0) begin
				nxtState = idle;
			end
			else if (i == 1) begin
				nxtState = state0;
			end
		end

	endcase

end

always_comb
begin : OUT_LOGIC 

	o = 'd0;

	if (state == state2 && i == 1) begin

		o = 'd1;
	end

end

endmodule 
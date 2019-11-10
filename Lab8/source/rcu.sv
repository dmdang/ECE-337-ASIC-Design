// $Id: $
// File name:   rcu.sv
// Created:     9/30/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: rcu

module rcu
(
	input wire clk,
	input wire n_rst,
	input wire start_bit_detected,
	input wire packet_done,
	input wire framing_error,
	output reg sbc_clear,
	output reg sbc_enable, 
	output reg load_buffer,
	output reg enable_timer
);

typedef enum bit [2:0] {sbcClear, waitForSbc, enableTimer, sbcEnable, loadBuffer, idle} stateType; 
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
	
	sbc_enable = 0;
	load_buffer = 0;
	sbc_clear = 0;
	enable_timer = 0;

	nxtState = state;
	
	case(state)
		idle: 
		begin
			sbc_enable = 0;
			load_buffer = 0;
			sbc_clear = 0;
			enable_timer = 0;

			if (start_bit_detected == 1) begin
				nxtState = sbcClear;
			end
			else if (start_bit_detected == 0) begin
				nxtState = idle;
			end
		end

		sbcClear:
		begin
			sbc_enable = 0;
			load_buffer = 0;
			sbc_clear = 1;
			enable_timer = 0;

			nxtState = enableTimer;
		
		end
	
		enableTimer:
		begin
			sbc_enable = 0;
			load_buffer = 0;
			sbc_clear = 0;
			enable_timer = 1;
		
			if (packet_done == 1) begin

				nxtState = sbcEnable;
			end
			else if (packet_done == 0) begin

				nxtState = enableTimer;
			end
		
		end

		sbcEnable:
		begin
			sbc_enable = 1;
			load_buffer = 0;
			sbc_clear = 0;
			enable_timer = 0;
			
			nxtState = waitForSbc;

		end
		
		waitForSbc:
		begin

			sbc_enable = 0;
			load_buffer = 0;
			sbc_clear = 0;
			enable_timer = 0;

			if (framing_error == 1) begin

				nxtState = idle;
			end
			else if (framing_error == 0) begin

				nxtState = loadBuffer;
			end


		end

		loadBuffer:
		begin
			sbc_enable = 0;
			load_buffer = 1;
			sbc_clear = 0;
			enable_timer = 0;

			nxtState = idle;

		end

	endcase

end

endmodule 
// $Id: $
// File name:   controller.sv
// Created:     10/4/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: controller

module controller
(
	input wire clk,
	input wire n_rst,
	input wire dr,
	input wire lc,
	input wire overflow,
	output reg cnt_up,
	output reg clear,
	output reg modwait,
	output reg [2:0] op,
	output reg [3:0] src1,
	output reg [3:0] src2,
	output reg [3:0] dest,
	output reg err
);

reg nxtModwait;

typedef enum bit [4:0] {idle, eidle, store, inc_count, load0, wait0, load1, wait1, load2, wait2, load3, zero, sort1, sort2, sort3, sort4, mul1, add1, mul2, sub2, mul3, add3, mul4, sub4} stateType; 
stateType state;
stateType nxtState;

always_ff @ (posedge clk, negedge n_rst)
begin : REG_LOGIC

	if (!n_rst) begin

		state <= idle;
		modwait <= 0;
	end
	else begin

		state <= nxtState;
		modwait <= nxtModwait;
	end

end

always_comb begin

	nxtState = state;

	op = 3'b000;
	src1 = 4'b0000;
	src2 = 4'b0000;
	dest = 4'b0000;
	err = 0;
	nxtModwait = 1;
	cnt_up = 0;
	clear = 0;

	case(state)
		idle:
		begin
			op = 3'b000;
			src1 = 4'b0000;
			src2 = 4'b0000;
			dest = 4'b0000;
			err = 0;
			nxtModwait = 0;
			cnt_up = 0;
			clear = 0;

			if (dr == 1) begin

				nxtState = store;
			end
			else if (lc == 1) begin

				nxtState = load0;
			end
			else begin

				nxtState = idle;
			end

		end

		store:
		begin

			op = 3'b010;
			src1 = 4'b0000;
			src2 = 4'b0000;
			dest = 4'b0101;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 0;
			
			if (dr == 0) begin

				nxtState = eidle;
			end
			else begin
				
				nxtState = inc_count;
			end

		end
		
		inc_count:
		begin
			op = 3'b000;
			src1 = 4'b0000;
			src2 = 4'b0000;
			dest = 4'b0000;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 1;
			clear = 0;

			nxtState = zero;
		end
		
		zero:
		begin
			op = 3'b101;   
			src1 = 4'b0000;
			src2 = 4'b0000;
			dest = 4'b0000;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 0;
			
			nxtState = sort1;
		end
		
		sort1:
		begin
			op = 3'b001;
			src1 = 4'b0010;
			src2 = 4'b0000;
			dest = 4'b0001;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 0;

			nxtState = sort2;
		
		end

		sort2:
		begin
			op = 3'b001;
			src1 = 4'b0011;
			src2 = 4'b0000;
			dest = 4'b0010;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 0;

			nxtState = sort3;

		end
		sort3:
		begin
			op = 3'b001;
			src1 = 4'b0100;
			src2 = 4'b0000;
			dest = 4'b0011;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 0;
			
			nxtState = sort4;

		end
		sort4: 
		begin
			op = 3'b001;
			src1 = 4'b0101;
			src2 = 4'b0000;
			dest = 4'b0100;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 0;

			nxtState = mul1;
		end
		mul1:
		begin
			op = 3'b110;
			src1 = 4'b0001;
			src2 = 4'b0110;
			dest = 4'b1010;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 0;
	
			nxtState = add1;

		end
		
		add1:
		begin
			op = 3'b100;
			src1 = 4'b0000;
			src2 = 4'b1010;
			dest = 4'b0000;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 0;
			
			if (overflow == 1) begin

				nxtState = eidle;
			end
			else begin
	
				nxtState = mul2;
			end

		end

		mul2:
		begin
			op = 3'b110;
			src1 = 4'b0010;
			src2 = 4'b0111;
			dest = 4'b1010;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 0;

			nxtState = sub2;

		end
		
		sub2:
		begin
			op = 3'b101;
			src1 = 4'b0000;
			src2 = 4'b1010;
			dest = 4'b0000;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 0;

			if (overflow == 1) begin

				nxtState = eidle;
			end
			else begin
	
				nxtState = mul3;
			end

		end

		mul3:
		begin
			op = 3'b110;
			src1 = 4'b0011;
			src2 = 4'b1000;
			dest = 4'b1010;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 0;
			
			nxtState = add3;

		end
		
		add3:
		begin
			op = 3'b100;
			src1 = 4'b0000;
			src2 = 4'b1010;
			dest = 4'b0000;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 0;

			if (overflow == 1) begin

				nxtState = eidle;
			end
			else begin
	
				nxtState = mul4;
			end

		end

		mul4:
		begin
			op = 3'b110;
			src1 = 4'b0100;
			src2 = 4'b1001;
			dest = 4'b1010;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 0;

			nxtState = sub4;

		end
		
		sub4:
		begin
			op = 3'b101;
			src1 = 4'b0000;
			src2 = 4'b1010;
			dest = 4'b0000;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 0;

			if (overflow == 1) begin

				nxtState = eidle;
			end
			else begin
	
				nxtState = idle;
			end

		end

		load0:
		begin
			op = 3'b011;
			src1 = 4'b0000;
			src2 = 4'b0000;
			dest = 4'b1001;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 1;      // changed

			nxtState = wait0;

		end
		
		wait0:
		begin
			op = 3'b000;
			src1 = 4'b0000;
			src2 = 4'b0000;
			dest = 4'b0000;
			err = 0;
			nxtModwait = 0;
			cnt_up = 0;
			clear = 0;

			if (lc == 1) begin

				nxtState = load1;
			end
			else begin

				nxtState = wait0;
			end

		end

		load1:
		begin
			op = 3'b011;
			src1 = 4'b0000;
			src2 = 4'b0000;
			dest = 4'b1000;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 0;

			nxtState = wait1;
			
		end

		wait1:
		begin
			op = 3'b000;
			src1 = 4'b0000;
			src2 = 4'b0000;
			dest = 4'b0000;
			err = 0;
			nxtModwait = 0;
			cnt_up = 0;
			clear = 0;

			if (lc == 1) begin

				nxtState = load2;
			end
			else begin

				nxtState = wait1;
			end


		end

		load2:
		begin
			op = 3'b011;
			src1 = 4'b0000;
			src2 = 4'b0000;
			dest = 4'b0111;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 0;
		
			nxtState = wait2;

		end
		
		wait2:
		begin
			op = 3'b000;
			src1 = 4'b0000;
			src2 = 4'b0000;
			dest = 4'b0000;
			err = 0;
			nxtModwait = 0;
			cnt_up = 0;
			clear = 0;

			if (lc == 1) begin

				nxtState = load3;
			end
			else begin

				nxtState = wait2;
			end
		end

		load3:
		begin
			op = 3'b011;
			src1 = 4'b0000;
			src2 = 4'b0000;
			dest = 4'b0110;
			err = 0;
			//nxtModwait = 1;
			cnt_up = 0;
			clear = 0;
		
			nxtState = idle;

		end

		eidle:
		begin
			op = 3'b000;
			src1 = 4'b0000;
			src2 = 4'b0000;
			dest = 4'b0000;
			err = 1;
			nxtModwait = 0;
			cnt_up = 0;
			clear = 0;

			if (dr == 1) begin

				nxtState = store;
			end
			else begin
				
				nxtState = eidle;
			end

		end

	endcase

end

endmodule 
// $Id: $
// File name:   apb_slave.sv
// Created:     10/14/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: apb_slave

module apb_slave
(
	input wire clk,
	input wire n_rst,
	input wire [7:0] rx_data,
	input wire data_ready,
	input wire overrun_error,
	input wire framing_error,
	output reg data_read,
	input wire psel,
	input wire [2:0] paddr,
	input wire penable,
	input wire pwrite,
	input wire [7:0] pwdata,
	output reg [7:0] prdata,
	output reg pslverr,
	output wire [3:0] data_size,
	output wire [13:0] bit_period
);

reg [7:0] data_size_reg;
reg [7:0] nxtData_size_reg;
//reg [13:0] bit_period_reg;
//reg [13:0] nxtBit_period_reg;
reg [7:0] bit_period_reg_low;
reg [7:0] bit_period_reg_high;
reg [7:0] nxtBit_period_reg_low;
reg [7:0] nxtBit_period_reg_high;
reg [1:0] error_status_reg;
reg [1:0] nxtError_status_reg;
reg [0:0] data_status_reg;
reg [0:0] nxtData_status_reg;
reg [7:0] data_buffer;
reg [7:0] nxtData_buffer;	

assign rx_data = data_buffer;
assign data_size = data_size_reg[3:0];
assign bit_period = {bit_period_reg_high, bit_period_reg_low};

typedef enum bit [2:0] {read, write, idle, error} stateType; 
stateType state;
stateType nxtState;

always_ff @ (posedge clk, negedge n_rst)
begin : REG_LOGIC

	if (!n_rst) begin

		state <= idle;
		
		data_size_reg <= 8'b00000000;
		bit_period_reg_low <= 8'b00000000;
		bit_period_reg_high <= 8'b00000000;
		error_status_reg <= 2'b00;
		data_status_reg <= 1'b0;
		data_buffer <= 8'b00000000;
	end
	else begin

		state <= nxtState;

		data_size_reg <= nxtData_size_reg;
		//bit_period_reg <= nxtBit_period_reg;
		bit_period_reg_low <= nxtBit_period_reg_low;
		bit_period_reg_high <= nxtBit_period_reg_high;
		error_status_reg <= nxtError_status_reg;
		data_status_reg <= nxtData_status_reg;
		data_buffer <= nxtData_buffer;
	end

end

// state logic
always_comb
begin : NXT_LOGIC

	nxtState = state;
	prdata = 0;
	pslverr = 0;
	data_read = 0;
	nxtData_size_reg = data_size_reg;
	nxtBit_period_reg_low = bit_period_reg_low;
	nxtBit_period_reg_high = bit_period_reg_high;
	nxtError_status_reg = error_status_reg;
	nxtData_status_reg = data_status_reg;
	nxtData_buffer = data_buffer;

	case(state)
		idle:
		begin
			prdata = 0;
			
			if (psel == 1 && pwrite == 1) begin

				if (paddr == 3'b000 || paddr == 3'b001 || paddr == 3'b110) begin

					nxtState = error;
				end
				else begin

					nxtState = write;
				end
			end
			else if (psel == 1 && pwrite == 0) begin

				nxtState = read;
			end
			else if (psel == 0) begin
				
				nxtState = idle;
			end


		end

		read:
		begin
			//prdata = nxtData_buffer[paddr];

			if (paddr == 0) begin
				
				if (data_ready && !data_read) begin

					nxtData_status_reg = 1;
				end
			
				prdata = nxtData_status_reg;
			end
			
			else if (paddr == 1) begin
				
				if (framing_error) begin

					nxtError_status_reg = 1;

				end
				else if (overrun_error) begin

					nxtError_status_reg = 2;

				end
				else begin

					nxtError_status_reg = 0;
				end
				
				prdata = nxtError_status_reg;

			end
			else if (paddr == 2) begin

				prdata = nxtBit_period_reg_low;
			end

			else if (paddr == 3) begin

				prdata = nxtBit_period_reg_high;	
			end

			else if (paddr == 4) begin
				
				prdata = nxtData_size_reg;
			end

			else if (paddr == 5) begin

				pslverr = 1;
			end

			else if (paddr == 6) begin
		
				data_read = 1;
				nxtData_status_reg = 0;

				if (nxtData_size_reg == 5) begin

					prdata = {3'b000, nxtData_buffer[7:3]};
				end
				else if (nxtData_size_reg == 7) begin
			
					prdata = {1'b0, nxtData_buffer[7:1]};
				end
				else if (nxtData_size_reg == 8) begin

					prdata = nxtData_buffer;
				end
			end
			
			nxtState = idle;

		end

		write:
		begin

			if (paddr == 2) begin
				
				nxtBit_period_reg_low = pwdata;	
			end

			else if (paddr == 3) begin

				nxtBit_period_reg_high = pwdata;
			end

			else if (paddr == 4) begin

				nxtData_size_reg = pwdata;
			end 
			
			else if (paddr == 5) begin

				pslverr = 1;
			end
			
			nxtState = idle;

		end

		error:
		begin
			pslverr = 1;
			nxtState = idle;

		end
	
	endcase
end

// reg logic
/*
always_comb begin

	nxtData_status_reg = 0;
	nxtError_status_reg = 0;

	if (state == read) begin

		data_read = 1;
		nxtData_buffer = prdata;
	end
	else if (state == write) begin	// do i need this condition for write?

		nxtData_buffer = pwdata;
	end
	
	if (data_ready == 1) begin

		nxtData_status_reg = 1;
	end

	if (framing_error) begin

		nxtError_status_reg = 1;
	end
	else if (overrun_error) begin

		nxtError_status_reg = 2;
	end

end
*/
endmodule 
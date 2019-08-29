// $Id: $
// File name:   sensor_b.sv
// Created:     8/28/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: sensor_b

module sensor_b
(
	input wire [3:0] sensors,
	output reg error
);

always_comb
begin
	if (sensors[0] == 1'b1 || sensors[3:1] == 3'b111 || (sensors[1] && sensors[3] == 1'b1) || (sensors[1] && sensors[2] == 1'b1)) begin
		
		error = 1;

	end else begin
	
		error = 0;
	end


end

endmodule 
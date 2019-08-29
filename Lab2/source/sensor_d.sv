// $Id: $
// File name:   sensor_d.sv
// Created:     8/28/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: sensor_d

module sensor_d
(
	input wire [3:0] sensors,
	output wire error
);

	wire wandy;
	wire xandy;
	wire or1;

assign wandy = sensors[3] & sensors[1];
assign xandy = sensors[2] & sensors[1];
assign or1 = sensors[0] | xandy;
assign error = or1 | wandy;

endmodule 
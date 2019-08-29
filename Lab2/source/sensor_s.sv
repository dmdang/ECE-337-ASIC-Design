// $Id: $
// File name:   sensor_s.sv
// Created:     8/28/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: sensor_s

module sensor_s
(
	input wire [3:0] sensors,
	output wire error
);

wire wandy;
wire xandy;
wire zorxandy;

AND2X1 A1 (.A(sensors[3]), .B(sensors[1]), .Y(wandy));
AND2X1 A2 (.A(sensors[2]), .B(sensors[1]), .Y(xandy));
OR2X1 A3 (.A(sensors[0]), .B(xandy), .Y(zorxandy));
OR2X1 A4 (.A(wandy), .B(zorxandy), .Y(error));

endmodule 
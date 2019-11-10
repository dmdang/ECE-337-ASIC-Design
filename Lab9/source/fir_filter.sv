// $Id: $
// File name:   fir_filter.sv
// Created:     10/4/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: fir_filter

module fir_filter
(
	input wire clk,
	input wire n_reset,
	input wire [15:0] sample_data,
	input wire [15:0] fir_coefficient,
	input wire load_coeff,
	input wire data_ready,
	output reg one_k_samples,
	output reg modwait,
	output reg [15:0] fir_out,
	output reg err
);

reg sync_data_ready;
reg sync_load_coeff;
reg [16:0] outreg_data;
reg overflow;
reg cnt_up;
reg clear;
reg [2:0] op;
reg [3:0] src1;
reg [3:0] src2;
reg [3:0] dest;

sync_low SYNC_DATA_READY (.clk(clk), .n_rst(n_reset), .async_in(data_ready), .sync_out(sync_data_ready));
sync_low SYNC_LOAD_COEFF (.clk(clk), .n_rst(n_reset), .async_in(load_coeff), .sync_out(sync_load_coeff));

controller CONTROLLER (.clk(clk), .n_rst(n_reset), .dr(sync_data_ready), .lc(sync_load_coeff), .overflow(overflow), .cnt_up(cnt_up), .clear(clear), .modwait(modwait), .op(op), .src1(src1), .src2(src2), .dest(dest), .err(err)); 

counter COUNTER (.clk(clk), .n_rst(n_reset), .cnt_up(cnt_up), .clear(clear), .one_k_samples(one_k_samples));

datapath DATAPATH (.clk(clk), .n_reset(n_reset), .op(op), .src1(src1), .src2(src2), .dest(dest), .ext_data1(sample_data), .ext_data2(fir_coefficient), .outreg_data(outreg_data), .overflow(overflow));

magnitude MAGNITUDE (.in(outreg_data), .out(fir_out));


endmodule 
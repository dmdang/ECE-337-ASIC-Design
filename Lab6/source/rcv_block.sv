// $Id: $
// File name:   rcv_block.sv
// Created:     10/1/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: rcv_block

module rcv_block
(
	input wire clk,
	input wire n_rst,
	input wire serial_in,
	input wire data_read,
	output reg [7:0] rx_data,
	output reg data_ready,
	output reg overrun_error,
	output reg framing_error
);

reg load_buffer;
reg [7:0] packet_data;
reg sbc_clear;
reg sbc_enable;
reg stop_bit;
reg start_bit_detected;
reg shift_strobe;
reg packet_done;
reg enable_timer;

rx_data_buff RXDBUFF (.clk(clk), .n_rst(n_rst), .load_buffer(load_buffer), .packet_data(packet_data), .data_read(data_read), .rx_data(rx_data), .data_ready(data_ready), .overrun_error(overrun_error));

stop_bit_chk STOPBC (.clk(clk), .n_rst(n_rst), .sbc_clear(sbc_clear), .sbc_enable(sbc_enable), .stop_bit(stop_bit), .framing_error(framing_error));

start_bit_det STARTBD (.clk(clk), .n_rst(n_rst), .serial_in(serial_in), .start_bit_detected(start_bit_detected));

sr_9bit SR9BIT (.clk(clk), .n_rst(n_rst), .shift_strobe(shift_strobe), .serial_in(serial_in), .packet_data(packet_data), .stop_bit(stop_bit));

rcu RCU (.clk(clk), .n_rst(n_rst), .start_bit_detected(start_bit_detected), .packet_done(packet_done), .framing_error(framing_error), .sbc_clear(sbc_clear), .sbc_enable(sbc_enable), .load_buffer(load_buffer), .enable_timer(enable_timer));

timer TIMER (.clk(clk), .n_rst(n_rst), .enable_timer(enable_timer), .shift_enable(shift_strobe), .packet_done(packet_done));


endmodule 
/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Wed Sep 11 18:42:51 2019
/////////////////////////////////////////////////////////////


module sync_low ( clk, n_rst, async_in, sync_out );
  input clk, n_rst, async_in;
  output sync_out;
  wire   ff1out;

  DFFSR ff1out_reg ( .D(async_in), .CLK(clk), .R(n_rst), .S(1'b1), .Q(ff1out)
         );
  DFFSR out_reg ( .D(ff1out), .CLK(clk), .R(n_rst), .S(1'b1), .Q(sync_out) );
endmodule


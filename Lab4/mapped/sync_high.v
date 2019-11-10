/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Wed Sep 11 19:10:41 2019
/////////////////////////////////////////////////////////////


module sync_high ( clk, n_rst, async_in, sync_out );
  input clk, n_rst, async_in;
  output sync_out;
  wire   ff1out;

  DFFSR ff1out_reg ( .D(async_in), .CLK(clk), .R(1'b1), .S(n_rst), .Q(ff1out)
         );
  DFFSR out_reg ( .D(ff1out), .CLK(clk), .R(1'b1), .S(n_rst), .Q(sync_out) );
endmodule


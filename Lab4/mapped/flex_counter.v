/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Thu Sep 19 06:12:19 2019
/////////////////////////////////////////////////////////////


module flex_counter ( clk, n_rst, clear, count_enable, rollover_val, count_out, 
        rollover_flag );
  input [3:0] rollover_val;
  output [3:0] count_out;
  input clk, n_rst, clear, count_enable;
  output rollover_flag;
  wire   nxtRollover_flag, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47,
         n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61,
         n62, n63, n64, n65, n66, n67, n68, n69, n70;

  DFFSR \count_out_reg[0]  ( .D(n41), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[0]) );
  DFFSR rollover_flag_reg ( .D(nxtRollover_flag), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(rollover_flag) );
  DFFSR \count_out_reg[1]  ( .D(n40), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[1]) );
  DFFSR \count_out_reg[2]  ( .D(n39), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[2]) );
  DFFSR \count_out_reg[3]  ( .D(n38), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[3]) );
  MUX2X1 U39 ( .B(n42), .A(n43), .S(count_enable), .Y(nxtRollover_flag) );
  NAND3X1 U40 ( .A(n44), .B(n45), .C(n46), .Y(n43) );
  NOR2X1 U41 ( .A(n47), .B(n48), .Y(n46) );
  NAND2X1 U42 ( .A(n49), .B(n50), .Y(n48) );
  XOR2X1 U43 ( .A(n51), .B(rollover_val[2]), .Y(n49) );
  XNOR2X1 U44 ( .A(rollover_val[1]), .B(n52), .Y(n47) );
  XOR2X1 U45 ( .A(rollover_val[0]), .B(n53), .Y(n45) );
  XOR2X1 U46 ( .A(n54), .B(rollover_val[3]), .Y(n44) );
  NAND3X1 U47 ( .A(n55), .B(n56), .C(n57), .Y(n42) );
  NOR2X1 U48 ( .A(n58), .B(n59), .Y(n57) );
  XOR2X1 U49 ( .A(rollover_val[3]), .B(count_out[3]), .Y(n59) );
  XOR2X1 U50 ( .A(rollover_val[0]), .B(count_out[0]), .Y(n58) );
  XOR2X1 U51 ( .A(rollover_val[1]), .B(n60), .Y(n56) );
  XOR2X1 U52 ( .A(n61), .B(rollover_val[2]), .Y(n55) );
  OAI22X1 U53 ( .A(n62), .B(n63), .C(n53), .D(n64), .Y(n41) );
  OAI22X1 U54 ( .A(n60), .B(n63), .C(n52), .D(n64), .Y(n40) );
  OAI21X1 U55 ( .A(n53), .B(n65), .C(n66), .Y(n52) );
  NOR2X1 U56 ( .A(rollover_flag), .B(n60), .Y(n65) );
  INVX1 U57 ( .A(count_out[1]), .Y(n60) );
  OAI22X1 U58 ( .A(n61), .B(n63), .C(n51), .D(n64), .Y(n39) );
  XNOR2X1 U59 ( .A(n66), .B(n67), .Y(n51) );
  OAI22X1 U60 ( .A(n68), .B(n63), .C(n54), .D(n64), .Y(n38) );
  NAND2X1 U61 ( .A(n63), .B(n50), .Y(n64) );
  INVX1 U62 ( .A(clear), .Y(n50) );
  XOR2X1 U63 ( .A(n69), .B(n70), .Y(n54) );
  NOR2X1 U64 ( .A(n66), .B(n67), .Y(n70) );
  OR2X1 U65 ( .A(n61), .B(rollover_flag), .Y(n67) );
  INVX1 U66 ( .A(count_out[2]), .Y(n61) );
  NAND2X1 U67 ( .A(count_out[1]), .B(n53), .Y(n66) );
  NOR2X1 U68 ( .A(n62), .B(rollover_flag), .Y(n53) );
  INVX1 U69 ( .A(count_out[0]), .Y(n62) );
  OR2X1 U70 ( .A(n68), .B(rollover_flag), .Y(n69) );
  OR2X1 U71 ( .A(count_enable), .B(clear), .Y(n63) );
  INVX1 U72 ( .A(count_out[3]), .Y(n68) );
endmodule


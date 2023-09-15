// MU0 design - structural style
// P W Nutter (based on a design by Jeff Pepper)
// Date 20/8/2021
// 

// Do not touch the following line it is required for simulation 
`timescale 1ns/100ps
`default_nettype none

module MU0 (
           input  wire         Clk,
           input  wire         Reset,
           input  wire [15:0]  Din,
           output wire         Rd,
           output wire         Wr,
           output wire [11:0]  Addr,
           output wire [15:0]  Dout,
           output wire         Halted,
	   input wire   [1:0]   srcC,
	   output wire         fetch,
	   output wire [1:0]   cc,
	   output wire [15:0]  regC
	   );

// Internal flags
wire N;
wire Z;

// Define any internal signals
wire [15:0] net1, net2, net3, net4;
wire [3:0] F;
wire IR_En;
wire PC_En;
wire Acc_En;
wire X_sel;
wire Y_sel;
wire Addr_sel;
wire [1:0] M;
wire [15:0] PC;
wire [15:0] Acc;


//Instantiate Datapath



MU0_Datapath Datapath (.Clk(Clk), .Reset(Reset), .Din(Din), .X_sel(X_sel),
  			.Y_sel(Y_sel), .Addr_sel(Addr_sel), .PC_En(PC_En),
			.IR_En(IR_En), .Acc_En(Acc_En), .M(M), .F(F),
                        .Address(Addr), .Dout(Dout), .N(N), .Z(Z), .PC(PC), .Acc(Acc));

// Instantiate Control

MU0_Control Control (.Clk(Clk), .Reset(Reset), .F(F),  .N(N), .Z(Z),
                      .fetch(fetch), .PC_En(PC_En), .IR_En(IR_En), .Acc_En(Acc_En),
                      .X_sel(X_sel), .Y_sel(Y_sel), .Addr_sel(Addr_sel),
                      .M(M), .Rd(Rd), .Wr(Wr), .Halted(Halted));

// Required by Monitor (Ackie) JSP

AND3B2  I1[15:0] ( .O(net1), .I2(Acc), .I1(srcC[1]), .I0(srcC[0]));
AND3B1  I2[15:0] ( .O(net2), .I2(PC), .I1(srcC[0]), .I0(srcC[1]));
AND3B1  I3[15:0] ( .O(net3), .I2({14'd0,N,Z}), .I1(srcC[1]), .I0(srcC[0]));
AND3    I4[15:0] ( .O(net4), .I2({14'd0,N,Z}), .I1(srcC[1]), .I0(srcC[0]));
OR4     I5[15:0] ( .O(regC), .I3(net4), .I2(net3), .I1(net2), .I0(net1));
BUF     I6 (.O(cc[0]), .I(Z));
BUF     I7 (.O(cc[1]), .I(N));

endmodule 

// for simulation purposes, do not delete
`default_nettype wire

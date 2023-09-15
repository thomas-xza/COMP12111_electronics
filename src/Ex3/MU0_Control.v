// MU0 control design - unisim gates
// P W Nutter (based on a design by Jeff Pepper)
// Date 2/9/2020
// 

// Do not touch the following line it is required for simulation 
`timescale 1ns/100ps

// for simulation purposes, do not delete
`default_nettype none

// module definition

module MU0_Control(
                   input  wire         Clk,      // System clock
                   input  wire         Reset,    // System reset
                   input  wire  [3:0]  F,        // Bits [15:12] of the IR
                   input  wire         N,        // Negative flag
                   input  wire         Z,        // Zero flag
                   output wire          fetch,    // Used for debug
                   output wire          PC_En,    // Update PC
                   output wire          IR_En,    // Update IR
                   output wire          Acc_En,   // Update Acc
                   output wire          X_sel,    // Data Out mux(X port on ALU) 0 for Acc, 1 for PC
                   output wire          Y_sel,    // mux, Y port on ALU, 0 for Data In, 1 for Instr 
                   output wire          Addr_sel, // mux, 0 for PC, 1 for IR
                   output wire   [1:0]  M,        // ALU op, 0) Y, 1) X+Y, 2) X+1, 3) X-Y
                   output wire          Rd,       // Memory read
                   output wire          Wr,       // Memory write
                   output wire          Halted);  // MU0 stopped

wire net103, net110, net120, net123, net126;
wire lda, sta, add, sub, jmp, jge, jne, stp; 
wire execute;


AND4B3  ID4 ( .I0(F[2]), .I1(F[1]), .I2(F[0]), .I3(execute), .O(lda));
AND4B1  ID1 ( .I0(F[0]), .I1(F[2]), .I2(F[1]), .I3(execute), .O(jne));
AND4B1  ID2 ( .I0(F[1]), .I1(F[2]), .I2(F[0]), .I3(execute), .O(jge));
AND4B1  ID7 ( .I0(F[2]), .I1(F[1]), .I2(F[0]), .I3(execute), .O(sub));
AND4    ID0 ( .I0(F[2]), .I1(F[1]), .I2(F[0]), .I3(execute), .O(stp));
AND4B2  ID3 ( .I0(F[1]), .I1(F[0]), .I2(F[2]), .I3(execute), .O(jmp));
AND4B2  ID5 ( .I0(F[2]), .I1(F[1]), .I2(F[0]), .I3(execute), .O(sta));
AND4B2  ID6 ( .I0(F[2]), .I1(F[0]), .I2(F[1]), .I3(execute), .O(add));
BUF     ID8 ( .I(execute), .O(Addr_sel));

BUF  I10 ( .I(F[2]), .O(Y_sel));
BUF  I8 ( .I(stp), .O(Halted));
FDC  I0 ( .C(Clk), .CLR(Reset), .Q(execute), .D(net110));
AND2  I12 ( .I0(net120), .I1(execute), .O(M[0]));
AND2  I9 ( .I0(net103), .I1(execute), .O(Acc_En));
AND2  I4 ( .I0(sta), .I1(execute), .O(Wr));
INV  I3 ( .I(execute), .O(X_sel));
INV  I11 ( .I(execute), .O(IR_En));
INV  I5 ( .I(execute), .O(fetch));
AND2B1  I15 ( .I0(Z), .I1(jne), .O(net123));
AND2B1  I17 ( .I0(N), .I1(jge), .O(net126));
OR4  I16 ( .I0(net123), .I1(net126), .I2(jmp), .I3(fetch), .O(PC_En));
OR2B1  I14 ( .I0(execute), .I1(sub), .O(M[1]));
OR2B1  I1 ( .I0(execute), .I1(stp), .O(net110));
OR2B1  I6 ( .I0(execute), .I1(net103), .O(Rd));
OR2  I13 ( .I0(sub), .I1(add), .O(net120));
OR3  I7 ( .I0(add), .I1(sub), .I2(lda), .O(net103));


endmodule 
// for simulation purposes, do not delete
`default_nettype wire


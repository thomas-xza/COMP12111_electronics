// MU0 ALU design 
// P W Nutter (based on a design by Jeff Pepper)
// Date 7/7/2021

// Do not touch the following line it is required for simulation 
`timescale 1ns/100ps
`default_nettype none

// module header

//  Define the different operations that the ALU can handle.

`define ADD  2'b01
`define SUB  2'b11
`define INC  2'b10
`define PASS 2'b00

module MU0_Alu (
               input  wire [15:0]  X, 
               input  wire [15:0]  Y, 
               input  wire [1:0]   M, 
               output reg  [15:0]  Q
	       );

// behavioural description for the ALU

//  Was originally thinking to implement an adder
//    and build a ripple-carry-adder, however Verilog
//    does actually allow much more abstraction than expected.

//  Combinatorial as ALU does not store any state.

always @ (*)
  case(M)
    `ADD: Q = X + Y;
    `SUB: Q = X + ~Y + 1;
    `INC: Q = X + 0 + 1;
    `PASS: Q = Y;
	default: Q = 16'hxxxx;
  endcase

endmodule 

// for simulation purposes, do not delete
`default_nettype wire

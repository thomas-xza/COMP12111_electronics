// MU0 12 bit register design - behavioural style
// P W Nutter (based on a design by Jeff Pepper)
// Date 20/8/2021
// 

// Do not touch the following line it is required for simulation 
`timescale 1ns/100ps

// for simulation purposes, do not delete
`default_nettype none

// module header

module MU0_Reg12 (
input  wire        Clk, 
input  wire        Reset,     
input  wire        En, 
input  wire [11:0] D, 
output reg  [11:0] Q
);

// behavioural code - clock driven

always @ (posedge Clk)
  if (En)
	Q <= D;
  else
    Q <= Q;

//  The specification says "the reset signal acts asynchronously"
//    therefore, implemented this as a stateless block.

always @ (Reset)
  Q = 12'b0000_0000_0000;






endmodule 

// for simulation purposes, do not delete
`default_nettype wire

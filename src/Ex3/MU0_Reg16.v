// MU0 16 bit register design - behavioural style
// P W Nutter (based on a design by Jeff Pepper)
// Date 20/8/2021
// 

// Do not touch the following line it is required for simulation 
`timescale 1ns/100ps

// for simulation purposes, do not delete
`default_nettype none

// module header

module MU0_Reg16 (
input  wire        Clk, 
input  wire        Reset,     
input  wire        En, 
input  wire [15:0] D, 
output reg  [15:0] Q
);

// behavioural code - clock driven

reg [15:0] temp_Q;

//  On every clock tick, if `En` is high,
//    then set Q with contents of D,
//    else Q remains unchanged.

always @ (posedge Clk)
  if (En)
	temp_Q <= D;
  else
    temp_Q <= Q;

//  The specification says "the reset signal acts asynchronously".
//    Therefore, implemented this as a stateless block.

//  Note that we only want to reset Q when reset is high,
//		not whenever it changes.

always @ (*)
  if (Reset == 1'b1)
  	Q = 16'b0000_0000_0000_0000;
  else
    Q = temp_Q;




endmodule 

// for simulation purposes, do not delete
`default_nettype wire

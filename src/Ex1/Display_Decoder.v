// COMP12111 Exercise 1 - Combinatorial Design
//
// Version 2023. P W Nutter
//
// This is the Verilog module for the display decoder
//
// The aim of this exercise is complete the combinatorial design
// for the alphanumeric Display_Decoder. 
//
// DO NOT change the interface to this design or it may not be marked completely
// when submitted.
//
// Make sure you document your code and marks may be awarded/lost for the 
// quality of the comments given. Please document in the header the changes 
// made, when and by whom.
//
// Comments:
//

`timescale  1ns / 100ps
`default_nettype none

module Display_Decoder (input wire  [3:0]  input_code,       // bcd input
			    output reg 	[14:0] segment_pattern); // segment code output

// provide Verilog that described the required behaviour of the
// combinatorial design
// -----------------------------------------------------------------


always @ (*)
begin
  case(input_code)
    4'b0000: segment_pattern = 15'b000_1100_0011_1111;
    4'b0001: segment_pattern = 15'b000_1100_0000_0110;
    4'b0010: segment_pattern = 15'b000_0000_1101_1011;
    4'b0011: segment_pattern = 15'b000_0000_1100_1111;   
    4'b0100: segment_pattern = 15'b000_0000_1110_0110;  
    4'b0101: segment_pattern = 15'b000_0000_1110_1101;  
    4'b0110: segment_pattern = 15'b000_0000_1111_1101; 
    4'b0111: segment_pattern = 15'b001_0100_0000_0001;  
    4'b1000: segment_pattern = 15'b000_0000_1111_1111;
    default: segment_pattern = 15'h000_0000_0000_0000;
  endcase
end




endmodule  // end of module Display_Decoder

`default_nettype wire

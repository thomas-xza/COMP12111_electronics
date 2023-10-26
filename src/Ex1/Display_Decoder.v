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
    default: segment_pattern = 15'b000_0000_0000_0000;
  endcase
end


endmodule  // end of module Display_Decoder




module Riscv_decoder (input wire  [31:0] instruction,
			    output reg [3:0] inst_type);

wire [6:0] opcode;

assign opcode[6:0] = instruction[6:0];

//  https://inst.eecs.berkeley.edu/~cs61c/fa18/img/riscvcard.pdf

//  Tried to look for a pattern, but when you look at the 
//    numerically ordered opcodes, they are not ordered by type.

//  Below wire assignments to be replaced by further module calls,
//    to do further decoding, e.g. of register source/target.

always @ (*)
begin
  case(opcode)
    7'b0000011: inst_type = 3'b000_0001;  // I
    7'b0010011: inst_type = 3'b000_0010;  // I
    7'b0010111: inst_type = 3'b000_0011;  // U
    7'b0011011: inst_type = 3'b000_0100;  // I
    7'b0100011: inst_type = 3'b000_0101;  // S
    7'b0110011: inst_type = 3'b000_0110;  // R
    7'b0110111: inst_type = 3'b000_0111;  // U
    7'b0111011: inst_type = 3'b000_1000;  // R
    7'b1100011: inst_type = 3'b000_1001;  // SB
    7'b1100111: inst_type = 3'b000_1010;  // I
    7'b1101111: inst_type = 3'b000_1011;  // UJ
    7'b1110011: inst_type = 3'b000_1100;  // I
    default: inst_type = 3'b000_0000;     // INVALID OPCODE
  endcase
end


endmodule




`default_nettype wire

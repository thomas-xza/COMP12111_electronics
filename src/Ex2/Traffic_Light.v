// COMP12111 - Exercise 2 Sequential Design
//
// Version 2. April 2023. P W Nutter
//
// This is the Verilog module for the pedestrian/cyclist crossing Controller
//
// The aim of this exercise is complete the finite state machine using the
// state transition diagram given in the laboratory notes. 
//
// DO NOT change the interface to this design or it may not be marked completely
// when submitted.
//
// Make sure you document your code and marks may be awarded/lost for the 
// quality of the comments given.
//
// Add your comments:
// [All comments inline]
//

//  Presumably so many states so that some light sequences hold during multiple clock ticks.

`define STATE_0 4'b0000
`define STATE_1 4'b0001
`define STATE_2 4'b0010
`define STATE_3 4'b0011
`define STATE_4 4'b0100
`define STATE_5 4'b0101
`define STATE_6 4'b0110
`define STATE_7 4'b0111
`define STATE_8 4'b1000
`define STATE_9 4'b1001
`define STATE_10 4'b1010


//  The 4 potential light sequences, plus test sequence. 

`define R__G 5'b01001  //  Red pedestrian, green traffic.
`define R__A 5'b01010  //  Red pedestrian, amber traffic.
`define G__R 5'b10100  //  Green pedestrian, red traffic.
`define R__R 5'b01110  //  Red pedestrian, amber & red traffic.
`define TEST 5'b11111  //  All lights on.


`timescale  1ns / 100ps
`default_nettype none

module Traffic_Light ( output reg [4:0] 	lightseq,	//the 5-bit light sequence
		           input  wire              clock,		//clock that drives the fsm
		           input  wire              reset,		//reset signal 
		           input  wire              start);		//input from pedestrian


//  11 states, so 2^4 minimum bits required for state

reg [3:0] current_state, next_state;


//  Combinatorial logic (stateless) for input.
//  Derives next_state from current_state and start.
//  Note that this assumes that start is never undefined, for simplicity.
//  Could do case-statements inside if-statements, alternatively.

always @ (*)
  case(current_state)
    `STATE_0:
		if (start)
			next_state = `STATE_1;
		else
			next_state = current_state;  //  Explicitly remain unchanged.
    `STATE_1: next_state = `STATE_2;
    `STATE_2: next_state = `STATE_3;
    `STATE_3: next_state = `STATE_4;
    `STATE_4: next_state = `STATE_5;
    `STATE_5: 
		if (start)
			next_state = `STATE_8;
		else
			next_state = `STATE_6;
    `STATE_6:
		if (start)
			next_state = `STATE_9;
		else
			next_state = `STATE_7;
    `STATE_7:
		if (start)
			next_state = `STATE_10;
		else
			next_state = `STATE_0;
    `STATE_8: next_state = `STATE_9;
    `STATE_9: next_state = `STATE_10;
    `STATE_10: next_state = `STATE_1;
    default: next_state = `STATE_0;
  endcase


//  Sequential logic (stateful)
//  Updates current_state with next_state, when the clock rises.

always @ (posedge clock)
  if (reset)
	current_state <= `STATE_0;
  else
    current_state <= next_state;


//  Combinatorial logic for output
//  Takes the current state, and outputs the light sequence based on it.

always @(*)
  case(current_state)
    `STATE_0: lightseq = `R__G;
    `STATE_1: lightseq = `R__A;
    `STATE_2: lightseq = `G__R;
    `STATE_3: lightseq = `G__R;
    `STATE_4: lightseq = `G__R;
    `STATE_5: lightseq = `R__R;
    `STATE_6: lightseq = `R__G;
    `STATE_7: lightseq = `R__G;
    `STATE_8: lightseq = `R__G;
    `STATE_9: lightseq = `R__G;
    `STATE_10: lightseq = `R__G;
	default: lightseq = `TEST;
  endcase


endmodule

`default_nettype wire

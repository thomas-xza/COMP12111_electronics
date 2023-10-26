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
// [All comments inline, at present]
//

//  Not sure why so many states exist (yet).

`define STATE_0 6'b0000
`define STATE_1 6'b0001
`define STATE_2 6'b0010
`define STATE_3 6'b0011
`define STATE_4 6'b0100
`define STATE_5 6'b0101
`define STATE_6 6'b0110
`define STATE_7 6'b0111
`define STATE_8 6'b1000
`define STATE_9 6'b1001
`define STATE_10 6'b1010


//  The 4 potential light sequences. 

`define R__G 6'b01001  //  Red pedestrian, green traffic.
`define R__A 6'b01010  //  Red pedestrian, amber traffic.
`define G__R 6'b10100  //  Green pedestrian, red traffic.
`define R__R 6'b01110  //  Red pedestrian, amber & red traffic.


`timescale  1ns / 100ps
`default_nettype none

module Traffic_Light ( output reg [4:0] 	lightseq,	//the 5-bit light sequence
		           input  wire              clock,		//clock that drives the fsm
		           input  wire              reset,		//reset signal 
		           input  wire              start);		//input from pedestrian


//  11 states, so 2^4 minimum bits required for state

reg [3:0] current_state, next_state;



//  Combinatorial logic for input
always @ (*)
  case(current_state)
    STATE_0: next_state = STATE_1;
    STATE_1: next_state = STATE_2;
    STATE_2: next_state = STATE_3;
    STATE_3: next_state = STATE_4;
    STATE_4: next_state = STATE_5;
    STATE_5: 
		if (start)
			next_state = STATE_8;
		else
			next_state = STATE_6;
    STATE_6:
		if (start)
			next_state = STATE_9;
		else
			next_state = STATE_7;
    STATE_7:
		if (start)
			next_state = STATE_10;
		else
			next_state = STATE_0;
    STATE_8: next_state = STATE_9;
    STATE_9: next_state = STATE_10;
    STATE_10: next_state = STATE_1;
    

// determine next_state value
// from inputs and current_state value


//  Sequential logic (stateful)
//always @ (posedge clock)

// perform reset action then perform the
// next_state to current_state assignment


//  Combinatorial logic for output
//always @(*)
// determine output signals
// from current_state



endmodule

`default_nettype wire

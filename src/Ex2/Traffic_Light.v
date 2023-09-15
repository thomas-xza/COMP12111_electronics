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
//
//

`timescale  1ns / 100ps
`default_nettype none

module Traffic_Light ( output reg [4:0] 	lightseq,	//the 5-bit light sequence
		           input  wire              clock,		//clock that drives the fsm
		           input  wire              reset,		//reset signal 
		           input  wire              start);		//input from pedestrian


// declare internal variables here (how many bits required?)
	


// implement your next state combinatorial logic block here



// implement your current state assignment, register, here



// implement your output logic here




endmodule

`default_nettype wire

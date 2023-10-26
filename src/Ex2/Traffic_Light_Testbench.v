// COMP12111 Exercise 2 - Sequential Design Testbench
//
// Version 2023. P W Nutter
//
// This is the Verilog module for the traffic light testbench
// Tests for the traffic light should be added to this file


`timescale  1ns / 100ps
`default_nettype none


module Traffic_Light_Testbench;

wire [4:0]  lightseq;

reg   clock;
reg   reset;
reg   start;

Traffic_Light top(.clock(clock), .reset(reset), .start(start), .lightseq(lightseq));

//  Initialise some variables so they are not undefined - could cause bugs.

initial clock = 0;
initial reset = 0;
initial start = 0;


/*
#VALUE      creates a delay of VALUE ns
a=VALUE;    sets the value of input 'a' to VALUE
$stop;      tells the simulator to stop
*/


//  Clock for testing sequential (stateful) logic.
always // always do the following
  begin
  #50 // wait half a clock period
  clock = ~clock; // invert the clock
  end


//  There are 4 possible paths from STATE_0 to STATE_1:
//    0 1 2 3 4 5 8 9 10 1
//    0 1 2 3 4 5 6 9 10 1
//    0 1 2 3 4 5 7 10 0 1
//    0 1 2 3 4 5 7 0 1

//  When STATE_1 is activated, it takes 4 clock ticks to reach STATE_5 (#400 delay).


initial
begin

#100  //  Wait 100ns due to hardware quirk mentioned in exercise 1.

//  Test below: 0 1 2 3 4 5 7 0 1

#100
start=1;

#100
start=0;

#800
start=1;

#100
reset=1;

//  Test below: 0 1 2 3 4 5 7 10 0 1

#100
start=1;

#100
start=0;

#400
start=1;

#100
start=0;

#300
reset=1;

//  Test below: 0 1 2 3 4 5 6 9 10 1

#100
start=1;

#100
start=0;

#500
start=1;

#100
start=0;

#300
reset=1;

#100

//  Test below: 0 1 2 3 4 5 8 9 10 1

#100
start=1;

#100
start=0;

#600
start=1;

#100
start=0;

#200
reset=1;

#100

$stop;
end


// IMPORTANT: Do not alter the below line 
// required for simulation.
initial begin $init_testbench(); end

endmodule

`default_nettype wire


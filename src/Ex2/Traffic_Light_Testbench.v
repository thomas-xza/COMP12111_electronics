// COMP12111 Exercise 2 - Sequential Design Testbench
//
// Version 2023. P W Nutter
//
// This is the Verilog module for the traffic light testbench
// Tests for the traffic light should be added to this file
//


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



//  Begin sending input signals.
initial
begin

// Set input signals here, using delays where appropriate
// -----------------------------------------------------

#100  //  Wait 100ns due to hardware quirk mentioned in exercise 1.
#100 start=1;
#100 start=0;
#100 start=0;
#100 start=0;



#100 $stop;
end


// IMPORTANT: Do not alter the below line 
// required for simulation.
initial begin $init_testbench(); end

endmodule

`default_nettype wire

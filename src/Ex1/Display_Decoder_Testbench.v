// COMP12111 Exercise 1 - Combinatorial Design Testbench
//
// Version 2023. P W Nutter
//
// This is the Verilog module for the display decoder testbench
// Tests for the display decoder should be added to this file
//


`timescale  1ns / 100ps
`default_nettype none

module Display_Decoder_Testbench;

wire [14:0]  segment_pattern;
reg   [3:0]   input_code;


Display_Decoder top(.input_code(input_code), .segment_pattern(segment_pattern));


/* Comment block

#VALUE      creates a delay of VALUE ps
a=VALUE;    sets the value of input 'a' to VALUE
$stop;      tells the simulator to stop

*/

initial
begin
#100 input_code=0;  // Decimal format used

// Enter you stimulus below this line
// Make sure you test all input combinations with a delay
// -------------------------------------------------------





// -------------------------------------------------------
// Please make sure your stimulus is above this line

#100 $stop;
end



// IMPORTANT: Do not alter the below line 
// required for simulation.
initial begin $init_testbench(); end

endmodule

`default_nettype wire

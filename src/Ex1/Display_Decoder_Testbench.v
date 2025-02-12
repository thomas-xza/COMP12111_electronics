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

#100 input_code=4'b0001;
#100 input_code=4'b0010;
#100 input_code=4'b0011;
#100 input_code=4'b0100;
#100 input_code=4'b0101;
#100 input_code=4'b0110;
#100 input_code=4'b0111;
#100 input_code=4'b1000;
#100 input_code=4'b1001;
#100 input_code=4'b1010;
#100 input_code=4'b1011;
#100 input_code=4'b1100;
#100 input_code=4'b1101;
#100 input_code=4'b1110;
#100 input_code=4'b1111;
#100 input_code=4'b0000;

// -------------------------------------------------------
// Please make sure your stimulus is above this line

#100 $stop;
end


// IMPORTANT: Do not alter the below line 
// required for simulation.
initial begin $init_testbench(); end

endmodule


module Riscv_decoder_testbench;

wire [63:0]  instruction;
reg   [3:0]  inst_type;

Riscv_decoder top(.instruction(instruction), .inst_type(inst_type));

initial
begin
#100
//instruction=0;

//#100
//instruction=64'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000';

//#100
//instruction=64'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0011';

//#100
//instruction=64'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001_0011';

#100 $stop;

end

initial begin $init_testbench(); end

endmodule


`default_nettype wire

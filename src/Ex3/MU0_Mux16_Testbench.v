// COMP12111 Exercise 3 - MU0_Mux16 Testbench
//
// Version 2023. P W Nutter
//

//


`timescale  1ns / 100ps
`default_nettype none

module MU0_Mux16_Testbench();

//internal signals
reg   [15:0] A, B;
reg          S; 
wire  [15:0] Q;


MU0_Mux16 top(.A(A), .B(B), .S(S), .Q(Q) );
  
initial
begin
    // Test selection of input A  
    #100 S=0; A=0; B=16'bx; 
    // Expect Q  = 0
    #100 S=0; A=16'hFFFF; B=16'bx;   
    // Expect Q  = FFFF

    // Test selection of input B 
    #100 S=1; A=16'bx; B=0;  
    // Expect Q  = 0

    #100 S=1; A=16'bx;         B=16'hFFFF;    
    // Expect Q  = FFFF

    // We expect to see x propogate out of the 
    // multiplexer when the select signal is x
    #100 S=1'bx; A=0;          B=0;  
    // Expect Q = 12'dx
    #100 S=1'bx; A=16'hFFFF;    B=16'hFFFF;  
    // Expect Q = 12'dx 
end



// IMPORTANT: Do not alter the below line 
// required for simulation.
initial begin $init_testbench(); end


endmodule

`default_nettype wire

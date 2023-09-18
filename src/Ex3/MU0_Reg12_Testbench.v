// COMP12111 Exercise 3 - MU0_Reg12 Testbench
//
// Version 2023. P W Nutter
//

//


`timescale  1ns / 100ps
`default_nettype none

module MU0_Reg12_Testbench();

//internal signals
reg   [11:0] D;
reg          Clk;
reg          Reset;
reg          En; 
wire  [11:0] Q;


MU0_Reg12 top(.D(D), .Clk(Clk), .Reset(Reset), .En(En), .Q(Q) );
 
 
// Clk setup
initial
begin
    Clk = 0;
end

always
begin
    Clk = ~Clk;
    #50;
end
 

initial
begin
    #100;  

    // Enable the register  
    #50 D=0; Reset=0; En=1; 

    D = 1;          #100;
    // Expect (at next positive clock edge) Q = 1 
    D = 12'hFFF;    #100;
    // Expect (at next positive clock edge) Q = FFF 
    D = 12'hxxx;    #100;
    // Expect (at next positive clock edge) Q = x

    
    // Disable the register  
    En = 0;         #100;
    // Expect Q to remain unchanged
    D = 1;          #100;
    // Expect Q to remain unchanged
    D = 12'hFFF;    #100; 
    // Expect Q to remain unchanged
    D = 12'hxxx;    #100;


    // Test reseting the Register 
    Reset=1; En=0; D=12'hxxx;
    // Expect (immediately) Q = 0 
    #100;
    Reset=0; En=1; D=12'hFFF;
    // Expect (at next positive clock edge) Q = FFF 
    #100;  
    #100 $stop;
end

// IMPORTANT: Do not alter the below line 
// required for simulation.
initial begin $init_testbench(); end


endmodule

`default_nettype wire

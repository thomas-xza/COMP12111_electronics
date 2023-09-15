// COMP12111 Exercise 3 - MU0_Alu Testbench
// Version 2023. P W Nutter
//
// Description:
// 
//   Testing pairs of inputs, covering a range of positive 
//   and negative number combinations for each M input into the ALU.
//   Not an exhaustive test.
//    
//
//   All unused inputs set to X.
//   Xs will tend to propagate and expose faults in digital simulations
  


`timescale  1ns / 100ps
`default_nettype none

module MU0_Alu_Testbench();

//internal signals
reg     [15:0]  X;
reg     [15:0]  Y;
reg     [1:0]   M; 
wire    [15:0]  Q; 

// Instantiating ALU as top module
MU0_Alu top(.X(X), .Y(Y), .M(M), .Q(Q));

   
initial
begin 
    M = 2'bxx; // Unknown mode
    X = 16'hxxxx; 
    Y = 16'hxxxx;
    // Expect Q = 16'hxxxx

    #100; 
    M = 0; // Q = Y mode
    X = 16'hxxxx; 
    Y = 16'h0000;
    // Expect Q = 16'h0000
    
    #100;  // Large positive  
    X = 16'hxxxx; 
    Y = 16'h7FFF; 
    // Expect Q = 16'h7FFF
    
    #100; // Small negative
    X = 16'hxxxx; 
    Y = 16'hFFFF;
    // Expect Q = 16'hFFFF
         
    #100; // Alternate bit pattern
    X = 16'hxxxx; 
    Y = 16'h5555; 
    // Expect Q = 16'h5555
     
    #100; // Alternate bit pattern
    X = 16'hxxxx; 
    Y = 16'hAAAA; 
    // Expect Q = 16'hAAAA
    
    #100; 
    M = 1;  // Q = X + Y mode
    X = 16'h0000; 
    Y = 16'h0000; 
    // Expect Q = 16'h0000 
    
    #100;   // Simple add
    X = 16'h1234; 
    Y = 16'h5678; 
    // Expect Q = 16'h68AC 
    
    #100;   // Ripple add , positive + positive = positive
    X = 16'h0FFF; 
    Y = 16'h6FFF; 
    // Expect Q = 16'h7FFE 
 
    #100;   // Ripple add, negative + negative = negative
    X = 16'hFFFF; 
    Y = 16'hFFFE; 
    // Expect Q = 16'hFFFD / -3
    
    #100;  // positive + positive = negative
    X = 16'h7FFF;
    Y = 16'h0001;
    // Expect Q = 16'h8000
    
    
    #100;  // negative + negative = positive
    X = 16'h8000;
    Y = 16'h8001;
    // Expect Q = 16'h0001    
   
    #100
    M = 2; // Q = X + 1 
    X = 16'h0000; 
    Y = 16'hxxxx; 
    // Expect Q = 16'h0001 
    
    #100; // simple increment
    X = 16'h6542; 
    Y = 16'hxxxx; 
    // Expect Q = 16'h6543 
    
    #100; // ripple 
    X = 16'h6FFF; 
    Y = 16'hxxxx; 
    // Expect Q = 16'h7000
     
    #100; // positive to negative
    X = 16'h7FFF; 
    Y = 16'hxxxx; 
    // Expect Q = 16'h8000 
    
    #100; // simple negative
    X = 16'h8001; 
    Y = 16'hxxxx; 
    // Expect Q = 16'h8002
     
    #100; // negative to zero
    X = 16'hFFFF; 
    Y = 16'hxxxx; 
    // Expect Q = 16'h0000 
    
    #100;
    M = 3; // X-Y 
    X = 16'h0000; 
    Y = 16'h0000; 
    // Expect Q = 16'h0000
     
    #100; // simple positive
    X = 16'h7654; 
    Y = 16'h0123;
    // Expect Q = 16'h7531
         
    #100; // simple negative
    X = 16'hFFFD; // -3
    Y = 16'hFFFF; // -1
    // Expect Q = 16'hFFFE, -2

    #100; // negative - positive = negative
    X = 16'hFFFD; 
    Y = 16'h1234; 
    // Expect Q = 16'hEDC9
     
    #100; // positive - negative = positive
    X = 16'h1234; 
    Y = 16'hFFFD; 
    // Expect Q = 16'h1237
         
    #100; // negative - positive = positive
    X = 16'h8001; 
    Y = 16'h7FFF; 
    // Expect Q = 16'h0002 
    
    #100;
    // Test undefinied signals being passed to ALU
    M = 0; // Q = Y
    X = 16'h0000;
    Y = 16'hxxxx;
    // Expect Q = 16'hxxxx;
    
    #100;
    M = 1; // Q = X + Y
    X = 0;
    Y = 16'hxxxx; 
    // Expect Q = 16'hxxxx;
        
    #100;
    X = 16'hxxxx;
    Y = 0;
    // Expect Q = 16'hxxxx;
    
    #100;
    M=2; // Q = X + 1
    X = 16'hxxxx;
    Y = 16'h0000;
    // Expect Q = 16'hxxxx;
    
    #100;
    M=3; // Q = X - Y
    X = 16'hxxxx;
    Y = 16'h0000;
    // Expect Q = 16'hxxxx;
    
    #100;
    X = 16'h0000;
    Y = 16'hxxxx;
    // Expect Q = 16'hxxxx;
    
    #100;
    M=2'bxx; // unknow mode
    X = 16'h0000;
    Y = 16'h0000;
    // Expect Q = 16'hxxxx;
         
    #100;       
    $stop;
 

end


// IMPORTANT: Do not alter the below line 
// required for simulation.
initial begin $init_testbench(); end


endmodule

`default_nettype wire

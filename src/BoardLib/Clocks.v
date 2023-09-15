//Verilog HDL for "Board_lib", "Clocks" 
// Author J Pepper
// Date 09/05/2023

module Clocks (
output reg   Clk_1Hz,
output reg   Clk_1kHz,
output reg   Clk_25MHz,
input  wire  Clk
);
  
  reg [1:0] countA;
  reg [16:0] countB;
  reg [26:0] countC;
  
 initial countA=0;
 initial countB=0; 
 initial countC=0;
  
 always @(posedge Clk)
  begin
   if(countA == 1) begin Clk_25MHz <= 1; countA <= countA + 1; end
   else if(countA == 3) begin Clk_25MHz <= 0; countA <= 0; end
   else countA <= countA + 1;
   
   if(countB == 49999) begin Clk_1kHz <= 1; countB <= countB + 1; end
   else if(countB == 99999) begin Clk_1kHz <= 0; countB <= 0; end
   else countB <= countB + 1; 
   
   if(countC == 49_999_999) begin Clk_1Hz <= 1; countC <= countC + 1; end
   else if(countC == 99_999_999) begin Clk_1Hz <= 0; countC <= 0; end
   else countC <= countC + 1;   
     
   
  end
endmodule

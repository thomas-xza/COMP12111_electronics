// Verilog HDL for "COMP12111", "display_scan" "functional"


module Segments_Scan(
input wire Clk,
output reg [5:0]   Columns,
input wire [14:0]  Digit5,
input wire [14:0]  Digit4, 
input wire [14:0]  Digit3, 
input wire [14:0]  Digit2, 
input wire [14:0]  Digit1, 
input wire [14:0]  Digit0,
output reg [14:0]  Segments
);

reg  [2:0]  state;
reg  [14:0] Segments_raw;

// Display scanner
// Segments active high
always @ (posedge Clk)				
 case (state)
    0:begin state <= 1; Segments_raw <= Digit0; Columns <= 6'b100_000; end
    1:begin state <= 2; Segments_raw <= Digit1; Columns <= 6'b010_000; end
    2:begin state <= 3; Segments_raw <= Digit2; Columns <= 6'b001_000; end
    3:begin state <= 4; Segments_raw <= Digit3; Columns <= 6'b000_100; end
    4:begin state <= 5; Segments_raw <= Digit4; Columns <= 6'b000_010; end
    5:begin state <= 0; Segments_raw <= Digit5; Columns <= 6'b000_001; end
    default : begin state <= 0; Segments_raw <= 0; Columns <= 6'b000_000; end
 endcase 
    
always @(*)
 begin
  Segments[0] = Segments_raw[0];
  Segments[1] = Segments_raw[1];
  Segments[2] = Segments_raw[2];
  Segments[3] = Segments_raw[3];
  Segments[4] = Segments_raw[4];
  Segments[5] = Segments_raw[5];
  Segments[13] = Segments_raw[6];
  Segments[9] = Segments_raw[7];
  Segments[6] = Segments_raw[8];
  Segments[7]  = Segments_raw[9];
  Segments[8]  = Segments_raw[10];
  Segments[12]  = Segments_raw[11];
  Segments[11]  = Segments_raw[12];
  Segments[10]  = Segments_raw[13];
  Segments[14] = Segments_raw[14];
 end

endmodule

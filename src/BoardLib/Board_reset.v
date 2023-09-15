//Verilog HDL for "Board_lib", "Board_reset"

// Author J Pepper
// Date 09/05/2023

module Board_reset (
    input wire Clk,
    input wire Reset
);


  reg [3:0] icape_state;
  reg icape_cs;
  reg icape_wr;
  reg [31:0] icape_din;

  initial begin
    icape_state = 0;
    icape_cs = 1;
    icape_wr = 1;
    icape_din = 0;
  end

  always @(posedge Clk)
    // Following Xilinx provided sequence for a warm boot - reset bacj to bootloader
    case (icape_state)
      0:
      if(Reset)  // THE RESET BUTTON PRESSED
       begin
        icape_cs <= 0;
        icape_wr <= 0;
        icape_din <= 32'hFFFF_FFFF;
        icape_state <= 1;
      end
      1: begin
        icape_din   <= 32'h5599aa66;
        icape_state <= 2;
      end  // Sync Word, 0xAA995566, bitswapped
      2: begin
        icape_din   <= 32'h04000000;
        icape_state <= 3;
      end  // Type 1 NO OP, 0x20000000, bitswapped
      3: begin
        icape_din   <= 32'h0c400080;
        icape_state <= 4;
      end  // Type 1 Write 1 Words to WBSTAR, 0x30020001, bitswapped
      4: begin
        icape_din   <= 32'h00000000;
        icape_state <= 5;
      end  // Warm boot start address - wb_sector already bit swapped
      5: begin
        icape_din   <= 32'h0c000180;
        icape_state <= 6;
      end  // Type 1 Write 1 Words to CMD, 0x30008001, bitswapped
      6: begin
        icape_din   <= 32'h000000F0;
        icape_state <= 7;
      end  // IPROG command, 0x0000000F, bitswapped
      7: begin
        icape_din   <= 32'h04000000;
        icape_state <= 8;
      end  // Type 1 NO OP, 0x20000000, bitswapped
      8: begin
        icape_cs  <= 1;
        icape_wr  <= 1;
        icape_din <= 0;
      end
    endcase

  // Xilinx ICAPE component - used for warm boot
  ICAPE2 #(
      .ICAP_WIDTH("X32")
  ) u_icape2 (
      .CLK(Clk),
      .CSIB(icape_cs),
      .RDWRB(icape_wr),
      .I(icape_din),
      .O()
  );


endmodule

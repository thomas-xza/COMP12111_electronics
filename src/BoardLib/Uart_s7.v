 // Date:        16-12-2022   
// Author:      J Pepper
// Very simple uart - no buffered streams - you must keep up
// Fixed baud rate of 115200
// With a system clock of 25MHz - 216 clock cycles per uart bit
// 1 start bit, 8 data bits, no parity, at least 1 stop bit
// Bit order of RS232 is LSB 1st - MSB last
// RS232 byte format
// __               __
//   \__<D0 ... D7>/
 

module Uart_S7(
input  wire      Clk,        // 25MHz system clock
output reg [7:0] rx_byte,    // Byte constructed from rx bits
input  wire      [7:0] tx_byte,    // Byte transmitted via tx bits
output reg       rx_req,     // Rx byte ready
input  wire      tx_req,     // Tx byte ready
output reg       tx_ack,     // Acknowledge the we have the TX byte
input  wire      rx_ack,     // Acknowledgement of the RX byte
output reg       tx, // RS232 transmitter
input wire       rx // RS232 receiver
);


reg [3:0] tx_state;    // state machine for transmitter
reg [7:0] tx_counter;  // baudrate pulse length
reg [7:0] tx_data;     // internal transmitter byte to send

reg [3:0] rx_state;   // state machine variable for reciever 
reg [7:0] rx_counter; // baudrate pulse length

reg [7:0] rx_byte_int;


initial
 begin
  tx_counter = 0;
  tx_state = 0;
  tx = 1; // Set idle state high; will be taken low by transmitter to indicate start bit
  rx_counter = 0;
  rx_state = 0;
  rx_req = 0;
  tx_ack = 0;
 end


 // Transmitter state machine
 always @(posedge Clk)
   case(tx_state)
   0  : if(tx_req == 1) begin tx_data <= tx_byte; tx_ack <= 1; tx_counter <= 1; tx <= 0; tx_state <= 1; end // Get tx byte - transmit a start bit
        else begin tx <= 1; end //Stay idle - Don't send a start bit
   1  : if(tx_counter == 216) begin tx <= tx_data[0]; tx_counter <= 0; tx_state <= 2; end // Start transmition of LSB
        else begin tx_ack <= 0; tx_counter <= tx_counter + 1; end // create the reqired delay for the baudrate - this is the start bit delay
   2  : if(tx_counter == 216) begin tx <= tx_data[1]; tx_counter <= 0; tx_state <= 3; end // Next bit
        else tx_counter <= tx_counter + 1; // This is LSB delay
   3  : if(tx_counter == 216) begin tx <= tx_data[2]; tx_counter <= 0; tx_state <= 4; end // ETC
        else tx_counter <= tx_counter + 1;
   4  : if(tx_counter == 216) begin tx <= tx_data[3]; tx_counter <= 0; tx_state <= 5; end
        else tx_counter <= tx_counter + 1;
   5  : if(tx_counter == 216) begin tx <= tx_data[4]; tx_counter <= 0; tx_state <= 6; end
        else tx_counter <= tx_counter + 1;
   6  : if(tx_counter == 216) begin tx <= tx_data[5]; tx_counter <= 0; tx_state <= 7; end
        else tx_counter <= tx_counter + 1;
   7  : if(tx_counter == 216) begin tx <= tx_data[6]; tx_counter <= 0; tx_state <= 8; end
        else tx_counter <= tx_counter + 1;
   8  : if(tx_counter == 216) begin tx <= tx_data[7]; tx_counter <= 0; tx_state <= 9; end // MSB
        else tx_counter <= tx_counter + 1;
   9  : if(tx_counter == 216) begin tx <= 1; tx_counter <= 0; tx_state <= 10; end // STOP bit
        else tx_counter <= tx_counter + 1; // This is MSB delay
   10 : if(tx_counter == 216) begin  tx <= 1; tx_counter <= 0; tx_state <= 0; end // Finished TX byte transmission - loop back to idle state
        else tx_counter <= tx_counter + 1; // This is the STOP delay   
   endcase


// Reciever state machine  
always @(posedge Clk)
  case(rx_state)
  0 : if(rx == 0) begin rx_counter <= 0; rx_state <= 1; end // Wait here until we think we've got a Start bit
  1 : if(rx_counter == 108) // Sample the rx bit in the middle of the rx bit time frame
       begin
        rx_counter <= 0;           // restart counter
        if(rx == 1) rx_state <= 0; // It wasn't a Start bit return to rx idle state
        else rx_state <= 2;        // It was a Start bit - now we get can the rx data bits
       end
      else rx_counter <= rx_counter +1; // Start bit delay
  2 : if(rx_counter == 216) begin rx_counter <= 0; rx_byte_int[0] <= rx; rx_state <= 3; end // Get LSB - sample the middle of the rx bit time frame
      else rx_counter <= rx_counter +1; // LSB delay
  3 : if(rx_counter == 216) begin rx_counter <= 0; rx_byte_int[1] <= rx; rx_state <= 4; end // Get next bit - all sample are in the middle of the rx bit time frame
      else rx_counter <= rx_counter +1;
  4 : if(rx_counter == 216) begin rx_counter <= 0; rx_byte_int[2] <= rx; rx_state <= 5; end // ETC
      else rx_counter <= rx_counter +1;
  5 : if(rx_counter == 216) begin rx_counter <= 0; rx_byte_int[3] <= rx; rx_state <= 6; end
      else rx_counter <= rx_counter +1;
  6 : if(rx_counter == 216) begin rx_counter <= 0; rx_byte_int[4] <= rx; rx_state <= 7; end
      else rx_counter <= rx_counter +1;         
  7 : if(rx_counter == 216) begin rx_counter <= 0; rx_byte_int[5] <= rx; rx_state <= 8; end
      else rx_counter <= rx_counter +1;
  8 : if(rx_counter == 216) begin rx_counter <= 0; rx_byte_int[6] <= rx; rx_state <= 9; end
      else rx_counter <= rx_counter +1;
  9 : if(rx_counter == 216) begin rx_counter <= 0; rx_byte_int[7] <= rx; rx_state <= 10; end // Get MSB
      else rx_counter <= rx_counter +1; // MSB delay
  10: if(rx_counter == 216) begin rx_byte <= rx_byte_int; rx_req <= 1; rx_state <= 11; end// Middle of Stop bit - rx_byte is now ready
      else rx_counter <= rx_counter +1; // Stop bit delay
  11: if(rx_ack) begin rx_req <= 0; rx_state <= 0; end// Got the rx byte - remove the request - loop back to the idle state           
  endcase
  

endmodule



//Verilog HDL for "Board_lib", "ackie"

// Author J Pepper
// Date 09/05/2023

`include "../defines.v"



module BoardV3 (
    input  wire Reset,
    input  wire Clk,
    output wire Clk_1Hz,
    output wire Clk_1kHz,
    output wire Clk_25MHz,
    output wire Clk_100MHz,

    input  wire [ 5:0] keycol_pin,
    output wire [ 3:0] keyrow_pin,
    output wire [23:0] button,

    input  wire [3:0] Simple_buttons_pin,
    output wire [3:0] Simple_buttons,

    input  wire [1:0] S7_leds,
    output wire [1:0] S7_leds_pin,

    input  wire [14:0] Digit0,
    input  wire [14:0] Digit1,
    input  wire [14:0] Digit2,
    input  wire [14:0] Digit3,
    input  wire [14:0] Digit4,
    input  wire [14:0] Digit5,
    output wire [14:0] Segments_pin,
    output wire [ 5:0] Columns_pin,

    input  wire [ 4:0] Crossing_A,
    input  wire [ 5:0] Crossing_B,
    output wire [10:0] Traffic_lights_pin,

    input  wire Buzzer,
    output wire Buzzer_pin,

    input  wire        dac_we,
    input  wire [11:0] dac_data,
    output wire [11:0] dac_data_pin,
    output wire        dac_cs_pin,
    output wire        dac_load_pin,
    output wire        dac_pd_pin,
    output wire        dac_we_pin,

    inout wire [3:0] ftdi,

    output wire proc_reset,
    output wire proc_clk,
    input wire proc_fetch,
    input wire proc_halted,
    input wire [15:0] proc_din,
    input wire [3:0] proc_cc,

    output wire mem_wen,
    output wire [11:0] mem_addr,
    output wire [15:0] mem_dout,
    input wire [15:0] mem_din,

    output wire bp_mem_data_write,
    output wire bp_mem_write_en,
    output wire [15:0] breakpoint_adr,
    input wire bp_detected,
    input wire bp_mem_data_read
);


  wire [7:0] rx_byte;
  wire [7:0] tx_byte;
  wire       rx;
  wire       tx;
  wire       rx_req;
  wire       rx_ack;
  wire       tx_req;
  wire       tx_ack;

  wire       proc_wen;  // Not connected


  Board_reset Rst1 (
      .Clk  (Clk),
      .Reset(Reset)
  );
  Clocks ClocksI1 (
      .Clk_1Hz(Clk_1Hz),
      .Clk_1kHz(Clk_1kHz),
      .Clk_25MHz(Clk_25MHz),
      .Clk(Clk)
  );
  Keyboard KeyB1 (
      .Clk(Clk_1kHz),
      .button(button),
      .keyrow(keyrow_pin),
      .keycol(keycol_pin)
  );
  Segments_Scan SS1 (
      .Clk(Clk_1kHz),
      .Columns(Columns_pin),
      .Segments(Segments_pin),
      .Digit5(Digit5),
      .Digit4(Digit4),
      .Digit3(Digit3),
      .Digit2(Digit2),
      .Digit1(Digit1),
      .Digit0(Digit0)
  );
  Uart_S7 U1 (
      .Clk(Clk_25MHz),
      .rx_byte(rx_byte),
      .tx_byte(tx_byte),
      .rx_req(rx_req),
      .rx_ack(rx_ack),
      .tx_req(tx_req),
      .tx_ack(tx_ack),
      .tx(tx),
      .rx(rx)
  );
  AckieV2 Ackie1  (
      .Clk(Clk_25MHz),
      .byte_in(rx_byte),
      .byte_out(tx_byte),
      .tx_ack(tx_ack),
      .rx_req(rx_req),
      .rx_ack(rx_ack),
      .tx_req(tx_req),
      .mem_wen(mem_wen),
      .mem_addr(mem_addr),
      .mem_dout(mem_dout),
      .mem_din(mem_din),
      .proc_din(proc_din),
      .proc_wen(proc_wen),
      .proc_clk(proc_clk),
      .proc_fetch(proc_fetch),
      .proc_cc(proc_cc),
      .proc_reset(proc_reset),
      .proc_halted(proc_halted),
      .bp_mem_write_en(bp_mem_write_en),
      .breakpoint_adr(breakpoint_adr),
      .bp_mem_data_write(bp_mem_data_write),
      .bp_mem_data_read(bp_mem_data_read),
      .bp_detected(bp_detected)
  );

// Define paramaters for Ackie
defparam Ackie1.CPU_TYPE = `MU0_CPU_TYPE;    
defparam Ackie1.CPU_SUB = `MU0_CPU_SUB;   
defparam Ackie1.FEATURE_COUNT = `MU0_FEATURE_COUNT;    
defparam Ackie1.MEM_SEGS = `MU0_MEM_SEGS;   
defparam Ackie1.MEM_START = `MU0_MEM_START;
defparam Ackie1.MEM_SIZE = `MU0_MEM_SIZE;
defparam Ackie1.MEM_ADDR_WIDTH = `MU0_MEM_ADDR_WIDTH;   
defparam Ackie1.MEM_DATA_WIDTH = `MU0_MEM_DATA_WIDTH;  
defparam Ackie1.PROC_DAT_WIDTH = `MU0_PROC_DAT_WIDTH;
defparam Ackie1.PROC_FLAG_ADDR = `MU0_PROC_FLAG_ADDR;




  assign Clk_100MHz = Clk;

  assign Simple_buttons[3] = Simple_buttons_pin[0];
  assign Simple_buttons[2] = Simple_buttons_pin[1];
  assign Simple_buttons[1] = Simple_buttons_pin[3];
  assign Simple_buttons[0] = Simple_buttons_pin[2];

  assign S7_leds_pin = S7_leds;

  assign Traffic_lights_pin[2:0] = Crossing_A[2:0];
  assign Traffic_lights_pin[8:3] = Crossing_B[5:0];
  assign Traffic_lights_pin[10:9] = Crossing_A[4:3];

  assign Buzzer_pin = Buzzer;

  assign dac_data_pin[11:0] = dac_data[11:0];
  assign dac_pd_pin = 1'b1;
  assign dac_we_pin = dac_we;
  assign dac_cs_pin = 1'b0;
  assign dac_load_pin = 1'b0;

  //Aliases for the FTDI pins - all tristate apart from TX
  assign ftdi[0] = 1'bz;
  assign ftdi[1] = 1'bz;
  assign ftdi[2] = tx;
  assign ftdi[3] = 1'bz;
  assign rx = ftdi[1];



endmodule


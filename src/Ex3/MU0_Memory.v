// Verilog HDL for "MU0_lib", "memory_mu0" "functional"

// Author J Pepper
// MAY 2016

// Author Tong Li
// JUNE 2018
// Version 2.0


// Dual port memory/register module
// Address range 0 to 12'hFED is memory/ram
// Uses a Synchronous RAM on a negedge clock, to fool processor into think its just a RAM
// Address range 12'hFEE to 12'hFFF are address decoded registers to give access to the
// 1st year engineering lab board peripherals

// Do not touch the following line it is required for simulation 
`timescale 1ns/100ps

// for simulation purposes, do not delete
`default_nettype none

  `define MEM_SIZE   12'hEFF // Size of RAM
  `define IO_SIZE    8'hFF    // Size of IO


// Note definitions for use by the buzzer device driver
// Define the lowest octave of notes as number of master colock cycles, uses 8MHz clock
/*
`define   C4	30578
`define   C4_s	29304
`define   D4	28030
`define   D4_s	26756
`define   E4	25482
`define   F4	24208
`define   F4_s	22934
`define   G4	21659
`define   G4_s	20385
`define   A5	19111
`define   A5_s	17837
`define   B5	16563

// Define buzzer duration time step, 1/10 second at 8MHz clock
`define   buzzer_time_step 800_000
*/
// Define the lowest octave of notes as number of master colock cycles, uses 25MHz clock

`define   C4	95556
`define   C4_s	91575
`define   D4	87593
`define   D4_s	83612
`define   E4	79631
`define   F4	75650
`define   F4_s	71668
`define   G4	67684
`define   G4_s	63703
`define   A5	59721
`define   A5_s	55740
`define   B5	51759

// Define buzzer duration time step, 1/10 second at 8MHz clock
`define   buzzer_time_step 2500_000

module MU0_Memory(
                  input  wire        Clk,     		// 8MHz
		  input  wire [11:0] address0,		// CPU address bus
		  input  wire [15:0] write_data0,	// Data from cpu to memory 
		  output reg  [15:0] read_data0,	// Data from memory to cpu
		  input  wire        WEn0,		// cpu memory write enable, active high 
		  input  wire [11:0] address1,		// Ackie/perentie address bus
		  input  wire [15:0] write_data1,	// Data from ackie/perentie to memory
		  output reg  [15:0] read_data1,	// Data from memory to ackie/perentie
		  input  wire        WEn1,		// Ackie/perentie memory write enable, active high
                  output reg  [10:0] traffic_lights,	// Six taffic light leds 
                  output reg         buzzer_pulses,	// Piezo buzzer 
                  output reg  [14:0] digit5,		// Data for 14 segment display
                  output reg  [14:0] digit4,		// Data for 14 segment display
                  output reg  [14:0] digit3,		// Data for 14 segment display
                  output reg  [14:0] digit2,		// Data for 14 segment display 
                  output reg  [14:0] digit1,		// Data for 14 segment display
                  output reg  [14:0] digit0,		// Data for 14 segment display
                  output reg  [1:0]  s7_leds,		// 2 leds on S7mini board
                  input  wire [15:0] keypad,		// 16 button keypad
                  input  wire [7:0]  buttons_AtoH,	// A to H buttons		
                  input  wire [3:0]  Simple_buttons,	// 4 none scanned buttons (traffic crossings)
		  input  wire        WEnAckie_bp,              // breakpoint enable signal for ackie write
    		  input  wire [15:0] breakpoint_mem_adr,       // breakpoint memory address 
   		  input  wire        bp_mem_data_ackie_write,  // breakpoint data written to memory from ackie
    		  output reg         bp_mem_data_ackie_read,   // breakpoint data read from memory to ackie 
    	          output reg         bp_mem_detected           // detected breakpoint data from memory to ackie       
                 );

reg [15:0] mem [12'h000:`MEM_SIZE];	// memory array 16 x 4096
reg [15:0] mem_read_data0;		// cpu ram read port
reg [15:0] mem_read_data1;		// ackie ram read port

reg [15:0] buzzer;			// memory addresss decoded register for buzzer control
reg        buzzer_busy = 0;		// high when buzzer is running in program mode
reg        buzzer_run = 0;		// Pulse to indicate that buzzer register has been written to
reg [22:0] buzzer_clk_count = 0;	// Counter used to produce the buzzer time step delay
reg [3:0]  buzzer_time_step_count = 0;  // Hold the number of buzzer time steps
reg [17:0] buzzer_note;			// Buzzer note selected in terms of clock cycles
reg [17:0] buzzer_octave_and_note;	// Buzzer note scaled by the octave selected
reg [17:0] buzzer_note_count = 0;	// Counter used to count clock cycles of the determined note/octave

//breakpoint memory, added by Tong Li JUNE 2018
reg   bp_mem_ram [0:`MEM_SIZE]; // breakpoint ram for main memory
reg   bp_io_ram [0:`IO_SIZE];   // breakpoint ram for memory mapped IO
reg   WEnCPU_bp = 0;   					// breakpoint enable signal for CPU write
reg   WEnCPU_bp_data;        		// breakpoint data in WEnCPU_bp 

reg   WEnAckie_bp_mem;            // ackie write enable signal for breakpoint ram, used for main memory
reg   WEnAckie_bp_io;             // ackie write enable signal for breakpoint ram, used for memory mapped io
reg   WEnCPU_bp_mem;              // CPU write enable signal for breakpoint ram, used for main memory 
reg   WEnCPU_bp_io;               // CPU write enable signal for breakpoint ram, used for memory mapped io
reg   bp_mem_read_data_ackie;     // ackie read port for breakpoint ram, used for main memory
reg   bp_mem_read_data_io_ackie;  // ackie read port for breakpoint ram, used for memory mapped io
reg   bp_mem_read_data_cpu;       // cpu read port for breakpoint ram, used for main memory
reg   bp_mem_read_data_io_cpu;    // cpu read port for breakpoint ram, used for memory mapped io


// load default MU0 test program
// mem files should be placed in the same dir as the verilog source code 
initial
`ifdef SYNTHESIS
  $readmemh("MU0_test.mem", mem);    // For Xilinx synthesis
`else
  $readmemh("./src/Ex3/MU0_test.mem", mem); // For Questa simulation
`endif




// RAM
always @ (negedge Clk) // Done to make SRAM look like asynchronous RAM, makes simulation work
 begin
  if(WEn0) mem[address0] <= write_data0; // Write cpu data to ram
  mem_read_data0 <= mem[address0];	 // CPU reads from ram
 end
 
always @ (negedge Clk) 
 begin
  if(WEn1) mem[address1] <= write_data1; // Write ackie data to ram
  mem_read_data1 <= mem[address1];	 // Ackie reads from ram
 end

// Ackie read address decoder for peripherals
// By default read the RAM
always @(*)
 case(address1)
  12'hFFF : read_data1 = traffic_lights;
  12'hFFD : read_data1 = buzzer;
  12'hFFA : read_data1 = digit5;
  12'hFF9 : read_data1 = digit4;
  12'hFF8 : read_data1 = digit3;
  12'hFF7 : read_data1 = digit2; 
  12'hFF6 : read_data1 = digit1;
  12'hFF5 : read_data1 = digit0;
  12'hFF4 : read_data1 = s7_leds;
  12'hFF3 : read_data1 = buzzer_busy;
  12'hFF2 : read_data1 = keypad;
  12'hFF1 : read_data1 = buttons_AtoH;
  12'hFF0 : read_data1 = Simple_buttons; 
  default : read_data1 = mem_read_data1;
 endcase

// CPU read address decoder for peripherals
// By default read the RAM
always @(*)
 case(address0)
  12'hFFF : read_data0 = traffic_lights;
  12'hFFD : read_data0 = buzzer;
  12'hFFA : read_data0 = digit5;
  12'hFF9 : read_data0 = digit4;
  12'hFF8 : read_data0 = digit3;
  12'hFF7 : read_data0 = digit2; 
  12'hFF6 : read_data0 = digit1;
  12'hFF5 : read_data0 = digit0;
  12'hFF4 : read_data0 = s7_leds;
  12'hFF3 : read_data0 = buzzer_busy;
  12'hFF2 : read_data0 = keypad;
  12'hFF1 : read_data0 = buttons_AtoH; 
  12'hFF0 : read_data0 = Simple_buttons;
  default : read_data0 = mem_read_data0;
 endcase

// Write address decoder for peripherals that are just registers
// Ackie(WEn1) takes preference for writes to same address of CPU(WEn0)
// Write enables (WEn0 & WEn1) are active high
always @(posedge Clk)
 begin
  if(WEn1)
   case(address1)
    12'hFFF : traffic_lights <= write_data1[10:0];
    12'hFFA : digit5 <= write_data1[14:0];
    12'hFF9 : digit4 <= write_data1[14:0];
    12'hFF8 : digit3 <= write_data1[14:0];
    12'hFF7 : digit2 <= write_data1[14:0];
    12'hFF6 : digit1 <= write_data1[14:0];
    12'hFF5 : digit0 <= write_data1[14:0];
    12'hFF4 : s7_leds <= write_data1[1:0];
   endcase
  if(WEn0)
   if((WEn1 == 0) | (address0 != address1)) // Just make sure that Ackie(WEn1) is not trying to write to same peripheral
    case(address0)
     12'hFFF : traffic_lights <= write_data0[10:0];
     12'hFFA : digit5 <= write_data0[14:0];
     12'hFF9 : digit4 <= write_data0[14:0];
     12'hFF8 : digit3 <= write_data0[14:0];
     12'hFF7 : digit2 <= write_data0[14:0];
     12'hFF6 : digit1 <= write_data0[14:0];
     12'hFF5 : digit0 <= write_data0[14:0];
     12'hFF4 : s7_leds <= write_data0[1:0];
    endcase    
 end


//Synchronous dual port RAM for breakpoint data only, R/W control for main memory.
always @(negedge Clk)
  begin 
    if(WEnAckie_bp_mem) bp_mem_ram[breakpoint_mem_adr] <= bp_mem_data_ackie_write;     // Ackie writes breakpoint location into breakpint memory 
    bp_mem_read_data_ackie <= bp_mem_ram[breakpoint_mem_adr];                          // Ackie reads breakpoint location to display in perentie from breakpoint memory
  end
  
 always @(negedge Clk) 
  begin
    if(WEnCPU_bp_mem) bp_mem_ram[address0] <= WEnCPU_bp_data;                       // Write never set for this port, required to trick synthesis to produce dual port RAM
    bp_mem_read_data_cpu <= bp_mem_ram[address0];                                   // Indicates when the CPU's PC points at an address where a breakpoint is set  - Ackie should stop CPU clock
  end  


//Synchronous dual port RAM for breakpoint data only, R/W control for IO memory.
always @(negedge Clk)
  begin
    if(WEnAckie_bp_io) bp_io_ram[breakpoint_mem_adr[7:0]] <= bp_mem_data_ackie_write;   // Ackie writes breakpoint location into breakpint memory 
    bp_mem_read_data_io_ackie <= bp_io_ram[breakpoint_mem_adr[7:0]];                    // Ackie reads breakpoint location to display in perentie from breakpoint memory 
  end
always @(negedge Clk)
  begin
    if(WEnCPU_bp_io) bp_io_ram[address0[7:0]] <= WEnCPU_bp_data;                     // Write never set for this port, required to trick synthesis to produce dual port RAM
    bp_mem_read_data_io_cpu <= bp_io_ram[address0[7:0]];                             // Indicates when the CPU's PC points at an address where a breakpoint is set  - Ackie should stop CPU clock
  end


// Ackie write enable signal for breakpoint main memory and breakpoint memory mapped io.
always@(*)
 	begin
 		if (breakpoint_mem_adr[11:8] == 4'hF)
 			begin 
        WEnAckie_bp_mem = 0;
        WEnAckie_bp_io = WEnAckie_bp;
      end 
    else
    	begin             
        WEnAckie_bp_mem = WEnAckie_bp;
        WEnAckie_bp_io = 0;
      end    
	end

// CPU write enable signal for breakpoint main memory and breakpoint memory mapped io.
always@(*)
 	begin
 		if (address0[11:8] == 4'hF)
 			begin 
        WEnCPU_bp_mem = 0;
        WEnCPU_bp_io = WEnCPU_bp;
      end 
    else
    	begin             
        WEnCPU_bp_mem = WEnCPU_bp;
        WEnCPU_bp_io = 0;
      end    
	end



// Ackie read breakpoint memory port, used to display in perentie from breakpoint memory
always@(*)
 	begin
 		if (breakpoint_mem_adr[11:8] == 4'hF) bp_mem_data_ackie_read = bp_mem_read_data_io_ackie;  // Ackie reads from breakpoint ram for io memory.      
 		else bp_mem_data_ackie_read = bp_mem_read_data_ackie;                                      // Ackie reads from breakpoint ram for main memory.
 	end

// CPU read breakpoint memory port, used to read breakpoint signal to stop CPU clock.
always@(*)
 	begin
 		if (address0[11:8] == 4'hF) bp_mem_detected = bp_mem_read_data_io_cpu;                 //CPU reads from breakpoint ram for io memory .   
 		else bp_mem_detected = bp_mem_read_data_cpu;                                              //CPU reads from breakpoint ram for main memory . 
 	end 

// Address decoder for buzzer
always @(posedge Clk)
 if((WEn1) & (address1 == 12'hFFD)) //Ackie write to buzzer
  begin
   buzzer <= write_data1; 
   buzzer_run <= 1; // Let the rest of the buzzer system know that the buzzer register has been written to
  end
 else if((WEn0) & (address0 == 12'hFFD)) // CPU write to buzzer
  begin
   buzzer <= write_data0;
   buzzer_run <= 1; // Let the rest of the buzzer system know that the buzzer register has been written to
  end
 else
  buzzer_run <= 0;

// buzzer duration timer
always @(posedge Clk)
 // Check that buzzer should be run in program mode and a valid duration
 if((buzzer_run == 1) & (buzzer[11:8] != 0) & (buzzer[15] == 1))
  begin   
   buzzer_busy <= 1; // Indicate that the buzzer is running
  end
 else if(buzzer_busy)
  begin
   if(buzzer_time_step_count == buzzer[11:8]) // End of buzzer duration
    begin
     // Reset buzzer duration registers
     buzzer_clk_count <= 0;
     buzzer_time_step_count <= 0;
     buzzer_busy <= 0;
    end
   else if(buzzer_clk_count == `buzzer_time_step) // Increment buzzer time step
    begin
     buzzer_time_step_count <= buzzer_time_step_count + 1;
     buzzer_clk_count <= 0;
    end
   else
    buzzer_clk_count <= buzzer_clk_count + 1; // Keep count clock cycles to produce time delay
  end


// buzzer pulse generator
always @(posedge Clk)
 if(buzzer[15] == 0)          // Check for bypass mode
  buzzer_pulses <= buzzer[0]; // LSB drive buzzer directly in bypass mode
 else if(buzzer_busy == 0)    // Finished note, turn off buzzer 
  begin
   buzzer_pulses <= 0;
   buzzer_note_count <= 0;
  end
 else if(buzzer_busy == 1)   				// If buzzer is running in program mode
  if(buzzer_note_count == buzzer_octave_and_note)    	// Finined a cycle of note - start repeating
   begin
    buzzer_pulses <= 0;
    buzzer_note_count <= 0; 
   end
  else if(buzzer_note_count == buzzer_octave_and_note[17:1]) // Half cycle of buzzer note - toggle buzzer line
   begin
    buzzer_pulses <= 1;
    buzzer_note_count <= buzzer_note_count + 1;
   end
  else
   begin
    buzzer_note_count <= buzzer_note_count + 1; // Keep counting clock cycles for buzzer note calculation
   end
 else
  buzzer_pulses <= 0; // Buzzer not in bypass and finished in program mode - stop sending pulses to buzzer device

// buzzer note selector, uses [3:0] bits of buzzer register located at 'hFFD
always @(*)
 case(buzzer[3:0])
  0  : buzzer_note = `C4;
  1  : buzzer_note = `C4_s;
  2  : buzzer_note = `D4;
  3  : buzzer_note = `D4_s;
  4  : buzzer_note = `E4;
  5  : buzzer_note = `F4;
  6  : buzzer_note = `F4_s;
  7  : buzzer_note = `G4;
  8  : buzzer_note = `G4_s;
  9  : buzzer_note = `A5;
  10 : buzzer_note = `A5_s;
  11 : buzzer_note = `B5;
  default : buzzer_note = `C4;
 endcase

// buzzer octave selector, uses [7:4] bits of buzzer register located at 'hFFD
always @(*)
 case(buzzer[7:4])
  0,1,2,3,4 : buzzer_octave_and_note = buzzer_note; 			// Lowest octave select, no need to divide "note" delay down and change octave
  5         : buzzer_octave_and_note = {1'b0, buzzer_note[17:1]};	// divide by 2 to select octave 5
  6         : buzzer_octave_and_note = {2'b00,buzzer_note[17:2]};	// divide by 4 to select octave 6
  7         : buzzer_octave_and_note = {3'b000,buzzer_note[17:3]};	// divide by 8 to select octave 7
  8         : buzzer_octave_and_note = {4'b0000,buzzer_note[17:4]};	// divide by 16 to select octave 8
  9         : buzzer_octave_and_note = {5'b00000,buzzer_note[17:5]};	// divide by 32 to select octave 9 
  default   : buzzer_octave_and_note = 0;
 endcase

		     
   
endmodule

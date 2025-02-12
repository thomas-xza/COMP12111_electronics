// MU0 testbench
// P W Nutter (based on a design by Jeff Pepper)
// Date 20/8/2021
// 

// Do not touch the following line it is required for simulation 
`timescale 1ns/100ps 
`default_nettype none

module MU0_Testbench();

// Define any internal connections

reg Clk;
reg Reset;
wire [15:0] Din;
wire Wr;
wire [11:0] Address;
wire [15:0] Dout;
wire Halted;





// mu0 as dut (device under test) and mu0_memory have been instantiated
// for you


MU0 MU01 (
         .Clk(Clk),  .Reset(Reset), .Din(Din),  .Wr(Wr), .Addr(Address), 
         .Dout(Dout), .Halted(Halted)
         );

MU0_Memory MEM1 ( 
                .keypad(),
                .Simple_buttons(),
                .buttons_AtoH(),
		.s7_leds(),
                .traffic_lights(),
                .breakpoint_mem_adr(),
                .buzzer_pulses(),
		.digit0(),
                .digit1(),
	        .digit2(),
		.digit3(),
                .digit4(),
	        .digit5(),
                .WEnAckie_bp(1'b0),
		.bp_mem_detected(),
                .bp_mem_data_ackie_read(),
                .bp_mem_data_ackie_write(),
	        .Clk(Clk),
                .write_data1(),
	        .write_data0(Dout),
                .address1(),
	        .address0(Address),
                .WEn1(1'b0),
	        .WEn0(Wr),
		.read_data1(),
                .read_data0(Din)
		);


// set up the clock


initial Clk = 0;


/*
#VALUE      creates a delay of VALUE ns
a=VALUE;    sets the value of input 'a' to VALUE
$stop;      tells the simulator to stop
*/


//  Clock for testing sequential (stateful) logic.
always // always do the following
  begin
  // wait half a clock period
  Clk = ~Clk; // invert the clock
  #50;
 end

// Perform a reset action of MU0
initial
begin
#100;		//  Wait 100ns due to hardware quirk.
#50;
Reset=1;
#100;
Reset=0;

#16000;

#100 $stop();	// stop the simulation - could tie this to the Halted signal going high
end
 



// IMPORTANT: Do not alter the below line 
// required for simulation.
initial begin $init_testbench(); end

endmodule 

`default_nettype wire

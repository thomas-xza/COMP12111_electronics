// MU0 datapath design - structural style
// P W Nutter (based on a design by Jeff Pepper)
// Date 20/8/2021
// 

// Do not touch the following line it is required for simulation 
`timescale 1ns/100ps

// for simulation purposes, do not delete
`default_nettype none

module MU0_Datapath(
input  wire        Clk,			////  Done
input  wire        Reset,		////  Done
input  wire [15:0] Din,
input  wire        X_sel,
input  wire        Y_sel,
input  wire        Addr_sel,
input  wire        PC_En,
input  wire        IR_En,
input  wire        Acc_En,
input  wire [1:0]  M,
output wire [3:0]  F,			//  4 MSBs of the instruction (opcode)
output wire [11:0] Address,		//  12 LSBs of the instruction
output wire [15:0] Dout,
output wire        N,  			//  Flag
output wire        Z,  			//  Flag
output wire [15:0] PC,			//  Why is this external?
output wire [15:0] Acc);


// Define internal signals using names from the datapath schematic.
wire [15:0] X;
wire [15:0] IR;
//   X and IR given as example.


//  Need to define a few more datapath-internal wires.
wire [15:0] Y;
wire [15:0] Acc;
wire [15:0] ALU;



// The following connects X and Dout together, there's no need for you to do so
// use X when defining your datapath structure
assign Dout = X;
// Buffer added F is op 4 bits of the instruction
assign F = IR[15:12];
//  Dout and F given as example.




//  Sample instance (named `D1`) of module type `Traffic_Light`,
//    with local wires (e.g. `Crossing_A`) being connected to
//    module parameters such as `lightseq`.

//  Traffic_Light D1(
//  .lightseq(Crossing_A),
//  .clock(clock),
//  .reset(Simple_buttons[0:0]),
//  .start(Simple_buttons[1:1])
//  );


// Instantiate Datapath components

//MU0 registers

MU0_Reg16 ACCReg(
.Clk(Clk),
.Reset(Reset),
.En(Acc_En),
.D(ALU),    		//  Input calculated value from ALU.
.Q(Acc)     		//  Output Accumulator value.
);


MU0_Reg12 PCReg(
.Clk(Clk),
.Reset(Reset),
.En(PC_En),
.D(ALU[11:0]),    	//  Input from ALU (must only select 12 bits of instruction).
.Q()     			//  Output to...???
);

MU0_Reg16 IRReg(
.Clk(Clk),
.Reset(Reset),
.En(IR_En),
.D(Din),    		//  Input from memory bus.
.Q(IR)     			//  Output instruction.
);


// MU0 multiplexors

AddrMux MU0_Mux16(
.A(),
.B(),
.S(),
.Q()
);

XMux MU0_Mux12(
.A(),
.B(),
.S(),
.Q()
);

YMux MU0_Mux16(
.A(),
.B(),
.S(),
.Q()
);

// MU0 ALU



// MU0 Flag generation





endmodule 

// for simulation purposes, do not delete
`default_nettype wire

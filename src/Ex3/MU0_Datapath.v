// MU0 datapath design - structural style
// P W Nutter (based on a design by Jeff Pepper)
// Date 20/8/2021
// 

// Do not touch the following line it is required for simulation 
`timescale 1ns/100ps

// for simulation purposes, do not delete
`default_nettype none

module MU0_Datapath(
input  wire        Clk,			////  Connected.
input  wire        Reset,		////  Connected.
input  wire [15:0] Din,			////  Connected.
input  wire        X_sel,		////  Connected.
input  wire        Y_sel,		////  Connected.
input  wire        Addr_sel,	////  Connected.
input  wire        PC_En,		////  Connected.
input  wire        IR_En,		////  Connected.
input  wire        Acc_En,		////  Connected.
input  wire [1:0]  M,			////  Connected.
output wire [3:0]  F,			////  Connected.  4 MSBs of the instruction (opcode).
output wire [11:0] Address,		////  Connected.  12 LSBs of the instruction.
output wire [15:0] Dout,		////  Connected.  
output wire        N,  			////  Connected.  Flag
output wire        Z,  			////  Connected.  Flag
output wire [15:0] PC,			////  Connected x2.  Unexpectedly not internal only.
output wire [15:0] Acc);		////  Connected x2.  Unexpectedly not internal only.


// Define internal signals using names from the datapath schematic.
wire [15:0] X;		////  Connected x2.  
wire [15:0] IR;		////  Connected x3.
//   X and IR given as example.


//  Need to define a few more datapath-internal wires.
wire [15:0] Y;		////  Connected.  
wire [15:0] ALU;	////  Connected x2.  


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


//  Instantiate Datapath components

//  MU0 registers

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
.D(ALU[11:0]),    	//  Input from ALU (last 12 LSBs only).
.Q(PC)     			//  Output PC register value.
);

MU0_Reg16 IRReg(
.Clk(Clk),
.Reset(Reset),
.En(IR_En),
.D(Din),    		//  Input from memory bus.
.Q(IR)     			//  Output instruction.
);


//  MU0 multiplexors

//  Note: Module parameter `A` relates to `0` in diagram.

MU0_Mux16 XMux(
.A(Acc),					//  Input Accumulator value.
.B({4'b0000, PC[11:0]}),	//  Input PC value (padded to 16 bits).
.S(X_sel),					//  Input selection flag from control.
.Q(Dout)					//  Output data to memory-data bus.
);

MU0_Mux12 AddrMux(
.A(PC),				//  Input PC register value.
.B(IR[11:0]),		//  Input instruction address (last 12 LSBs only).
.S(Addr_sel),		//  Input address selection flag from control.
.Q(Address)			//  Output Address to memory-address bus.
);

MU0_Mux16 YMux(
.A(IR),				//  Input instruction from register.
.B(Din),			//  Input data from memory-data bus.
.S(Y_sel),			//  Input selection flag from control.
.Q(Y)				//  Output Y for ALU.
);


//  MU0 ALU

Main_ALU MU0_Alu(
.X(X),				//  Input X.
.Y(Y),				//  Input Y.
.M(M),				//  Input operation from control.
.Q(ALU)				//  Output result of arithmetic.
);


//  MU0 Flag generation

Main_flags MU0_Flags(
.Acc(Acc), 			//  Input accumulator to flag generator.
.N(N), 				//  Output negative flag.
.Z(Z)				//  Output zero flag.
);



endmodule 

// for simulation purposes, do not delete
`default_nettype wire

// MU0 datapath design - structural style
// P W Nutter (based on a design by Jeff Pepper)
// Date 20/8/2021
// 

// Do not touch the following line it is required for simulation 
`timescale 1ns/100ps

// for simulation purposes, do not delete
`default_nettype none

module MU0_Datapath(
input  wire        Clk,
input  wire        Reset,
input  wire [15:0] Din,
input  wire        X_sel,
input  wire        Y_sel,
input  wire        Addr_sel,
input  wire        PC_En,
input  wire        IR_En,
input  wire        Acc_En,
input  wire [1:0]  M,
output wire [3:0]  F,			// top 4 bits of the instruction
output wire [11:0] Address,
output wire [15:0] Dout,
output wire        N,
output wire        Z,
output wire [15:0] PC,
output wire [15:0] Acc);


// Define internal signals using names from the datapath schematic
wire [15:0] X;
wire [15:0] IR;


// Instantiate Datapath components

//MU0 registers




// MU0 multiplexors




// MU0 ALU




// MU0 Flag generation




// The following connects X and Dout together, there's no need for you to do so
// use X when defining your datapath structure
assign Dout = X;
// Buffer added F is op 4 bits of the instruction
assign F = IR[15:12];

endmodule 

// for simulation purposes, do not delete
`default_nettype wire

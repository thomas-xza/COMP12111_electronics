`define MU0_CPU_TYPE  8'd4    // MU0
`define MU0_CPU_SUB  16'd0    // MU0
`define MU0_FEATURE_COUNT  8'd0    // No features?
`define MU0_MEM_SEGS  8'd1    // One continuous memory area
`define MU0_MEM_START  32'd0
`define MU0_MEM_SIZE  32'd12

// Define width of data and address buses(32 bits max)
// Subtracted one from values, because verilog counts from zero
`define MU0_MEM_ADDR_WIDTH  8'd11   // Memory address bus width
`define MU0_MEM_DATA_WIDTH  8'd15   // Memory data bus width
`define MU0_PROC_DAT_WIDTH  8'd15   // CPU data bus width


`define MU0_FLAG_ADDR 2'd2
`define MU0_PROC_FLAG_ADDR  2'd2
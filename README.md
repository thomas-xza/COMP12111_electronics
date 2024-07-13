This module was about programming an FPGA, via a provided workflow, using Verilog.

**Exercise 1**: hardcoding buttons to output specific lights on the board.

**Exercise 2**: implementing a traffic light pedestrian crossing with a given finite state machine diagram, using a button and lights on the FPGA

**Exercise 3**: implementing a datapath for an MU0 processor, which executes instructions in 1 clock cycle, given a premade control unit

**Exercise 4**: writing an MU0 Assembly program that can be executed by the MU0 processor on the FPGA, which generates a light sequence, via Python scripts which generate the MU0 instructions

The Verilog I wrote can be found in `src/Ex*`

Note that exercise 4 Assembly is inside `src/Ex3/asm/` due to the dependency on exercise 3.
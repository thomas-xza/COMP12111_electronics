// Processor independent macros
`define MESSAGE_LEN     16'h0D00  // Number of bytes broadcast after this to produce message
          //(LSByte 1st, 13 bytes transmitted)

// Komodo communications protocol Definitions
  // Komodo commands send by the front-end(Perentie)
  `define   NOP             8'h00
  `define   PING            8'h01 // ping command, must reply "OK00" back to perentie
  `define   GET_SYSTEM      8'h02 // get cpu system
  `define   RESET_CPU       8'h04 // send a reset command to the CPU
  `define   GET_STATE       8'h20 // get CPU execution state, must reply back to perentie
  `define   STOP_CPU        8'h21 // stop CPU execution
  `define   PAUSE_CPU       8'h22 // pause CPU execution
  `define   CONTINUE_CPU    8'h23 // continue CPU execution
  `define   TOGGLE_BREAKPOINT 8'h30 // toggle breakpoint status set/not set, JSP AUG2017
  `define   READ_BREAKPOINT 8'h31 // read breakpoint status set/not set, JSP AUG2017
  `define   MEM_ACCESS      8'h4? // read/write to/from memory
  `define   CPU_REG_ACCESS  8'h5? // read/write to/from CPU Registers
  `define   RUN             8'hB0 // Run/execute the next instruction on the CPU
          // next 4 bytes give number of steps to execute
  `define   RUN_BREAK_EN    8'hB1 // Run/execute as above, enable breakpoints
                                  // on the first instruction executed
  
  // Execution status
  `define   RESET           8'h00
  //`define   BUSY            8'h01     // not used
  `define   STOPPED         8'h40     // Stopped
  //`define   STP_BREAKPOINT  8'h41     // Stopped due to breakpoint (TODO)
  //`define   STP_WATCHPOINT  8'h42     // Stopped due to watchpoint (TODO)
  //`define   STP_MEM_FAULT   8'h43     // Stopeed due to memory fault (not used)
  //`define   STP_PROGRAM     8'h44     // Stopped by programme request
  `define   RUNNING         8'h80     // Running normally
  //`define   SVC             8'h81     // Servicing a Supervisor Call
  //`define   SWI             8'h81     // Alias for SVC
  // Values 8'hC0 - 8'hFF can be used for Error Codes
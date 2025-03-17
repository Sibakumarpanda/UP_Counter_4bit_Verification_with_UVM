//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : counter_interface.sv
// Project :  4bit Up Counter design & verification Infra Development
// Purpose : 
// Author  : Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_COUNTER_INTERFACE_SV
`define GUARD_COUNTER_INTERFACE_SV

interface counter_interface (input logic clock);
      
      logic [3:0] data_in; // 4-bit data input for the counter      
      logic [3:0] data_out;// 4-bit data output from the counter     
      logic load;          // Control signal to load a specific value into the counter      
      logic rst;          // Reset signal to initialize the counter
  
      // Driver Clocking Block- Specifies how signals are sampled and driven during the positive edge of the clock  
      //Used for driving signals like rst, data_in, and load.
     clocking driver_cb @(posedge clock);
       default input #1 output #1; // Default delays for input and output
       output rst; // Output reset signal
       output data_in; // Output data input
       output load; // Output load signal
     endclocking
  
    // Output Monitor Clocking Block-Specifies how the data_out signal is monitored during the positive edge of the clock
    //Output_mon_cb: Used for monitoring the data_out signal.

     clocking output_mon_cb @(posedge clock);
       default input #1 output #1; // Default delays for input and output
       input data_out; // Input data output
     endclocking
  
      // Input Monitor Clocking Block-Specifies how the load, rst, and data_in signals are monitored during the positive edge of the clock
     //input_mon_cb: Used for monitoring the load, rst, and data_in signals.
     clocking input_mon_cb @(posedge clock);
       default input #1 output #1; // Default delays for input and output
       input load;     // Input load signal
       input rst;     // Input reset signal
       input data_in; // Input data input
     endclocking
  
     // Driver Modport-Specifies the modport for driving signals using the driver_cb clocking block  
     modport DRIVER (clocking driver_cb);
       
     // Input Monitor Modport-Specifies the modport for monitoring input signals using the input_mon_cb clocking block
     modport INPUT_MON (clocking input_mon_cb);
       
     // Output Monitor Modport -Specifies the modport for monitoring output signals using the output_mon_cb clocking block
     modport OUTPUT_MON ( clocking output_mon_cb);
       
endinterface
       
`endif //GUARD_COUNTER_INTERFACE_SV 
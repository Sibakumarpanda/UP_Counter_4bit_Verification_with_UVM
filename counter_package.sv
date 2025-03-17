//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : counter_package.sv
// Project :  4bit Up Counter design & verification Infra Development
// Purpose : 
// Author  : Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_COUNTER_PACKAGE_SV
`define GUARD_COUNTER_PACKAGE_SV

package counter_package;

//`include "counter_interface.sv" - Inside Package "interface" is not allowed to write
//`include "tb_define.sv" - We can include when this file is in use , at current its not used
import uvm_pkg::*;

`include "counter_transaction.sv"
`include "counter_env_config.sv"
`include "counter_input_sequencer.sv"
`include "counter_input_driver.sv"
`include "counter_input_monitor.sv"
`include "counter_input_agent.sv"
`include "counter_output_monitor.sv"
`include "counter_output_agent.sv"
`include "counter_scoreboard.sv"
`include "counter_env.sv"
`include "counter_sequence.sv"
`include "counter_base_test.sv"

endpackage : counter_package

`endif //GUARD_COUNTER_PACKAGE_SV


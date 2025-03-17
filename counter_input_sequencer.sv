//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : counter_input_sequencer.sv
// Project : 4bit Up Counter design & verification Infra Development
// Purpose : sequencer in active agent/input agent
// Author  : Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_COUNTER_INPUT_SEQUENCER_SV
`define GUARD_COUNTER_INPUT_SEQUENCER_SV

class counter_input_sequencer extends uvm_sequencer #(counter_transaction);
  `uvm_component_utils(counter_input_sequencer) // Register the component with the UVM factory
  
  //  Constructor: new   
  extern function new(string name = "counter_input_sequencer",uvm_component parent); 
    
  //  Function: build_phase
  extern function void build_phase(uvm_phase phase);
    
endclass :counter_input_sequencer
      
//===================================================================================
// New Constructor
//===================================================================================
function counter_input_sequencer::new(string name = "counter_input_sequencer", uvm_component parent);
    super.new(name, parent); // Call the base class constructor with the provided name and parent
endfunction : new  
    
//===================================================================================
// Build Phase
//===================================================================================
function void counter_input_sequencer::build_phase(uvm_phase phase);
    super.build_phase(phase); // Call the base class build_phase
endfunction : build_phase
    
`endif //GUARD_COUNTER_INPUT_SEQUENCER_SV 
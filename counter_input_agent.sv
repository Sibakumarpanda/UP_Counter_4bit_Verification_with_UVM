//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : counter_input_agent.sv
// Project : 4bit Up Counter design & verification Infra Development
// Purpose : Active agent/input agent
// Author  : Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_COUNTER_INPUT_AGENT_SV
`define GUARD_COUNTER_INPUT_AGENT_SV

class counter_input_agent extends uvm_agent;
  `uvm_component_utils(counter_input_agent) // Register the component with the UVM factory
  
   // Environment configuration object
   counter_env_config m_cfg;
   // UVM components for monitoring, sequencing, and driving
   counter_input_monitor monh;
   counter_input_sequencer seqrh;
   counter_input_driver drvh;
  
  //Constructor: new   
   extern function new(string name = "counter_input_agent",uvm_component parent); 
    
   //Function: build_phase
   extern function void build_phase(uvm_phase phase);
    
   //Function: connect_phase
   extern function void connect_phase(uvm_phase phase);
     
endclass: counter_input_agent

//===================================================================================
// New Constructor
//===================================================================================     
 
function counter_input_agent::new(string name = "counter_input_agent", uvm_component parent);
    super.new(name, parent); // Call the base class constructor
endfunction : new

//===================================================================================
// Build Phase
//===================================================================================
     
function void counter_input_agent::build_phase(uvm_phase phase);
     super.build_phase(phase); // Call the base class build_phase
     // Retrieve the environment configuration from the UVM config database
    if (!uvm_config_db#(counter_env_config)::get(this, "", "counter_env_config", m_cfg)) begin
      `uvm_fatal("CONFIG", "Cannot get() m_cfg from uvm_config_db. Have you set() it?");
    end
    // Create monitor instance
    monh = counter_input_monitor::type_id::create("monh", this);
    
    // Create driver and sequencer instances if the agent is active
    if (m_cfg.input_agent_is_active == UVM_ACTIVE) begin
      drvh = counter_input_driver::type_id::create("drvh", this);
      seqrh = counter_input_sequencer::type_id::create("seqrh", this);
    end
endfunction : build_phase
//===================================================================================
// connect Phase -Connect phase to link driver and sequencer
//===================================================================================
     
function void counter_input_agent::connect_phase(uvm_phase phase);
    if (m_cfg.input_agent_is_active == UVM_ACTIVE) begin
    // Connect the sequencer to the driver
    drvh.seq_item_port.connect(seqrh.seq_item_export);
    end
endfunction : connect_phase
  
`endif //GUARD_COUNTER_INPUT_AGENT_SV 
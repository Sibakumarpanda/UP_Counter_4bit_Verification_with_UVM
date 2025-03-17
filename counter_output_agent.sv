//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : counter_output_agent.sv
// Project : 4bit Up Counter design & verification Infra Development
// Purpose : Passive agent/output agent
// Author  : Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_COUNTER_OUTPUT_AGENT_SV
`define GUARD_COUNTER_OUTPUT_AGENT_SV

class counter_output_agent extends uvm_agent;
  `uvm_component_utils(counter_output_agent) // Register the component with the UVM factory
  
   counter_env_config m_cfg; // Environment configuration object
   counter_output_monitor mon_h; // Output monitor instance
  
   //Constructor: new   
   extern function new(string name = "counter_output_agent",uvm_component parent); 
    
   //Function: build_phase
   extern function void build_phase(uvm_phase phase);
    
   //Function: connect_phase
   extern function void connect_phase(uvm_phase phase);
     
endclass: counter_output_agent
//===================================================================================
// New Constructor
//===================================================================================      
  
function counter_output_agent::new(string name = "counter_output_agent", uvm_component parent);
     super.new(name, parent); // Call the base class constructor with name and parent
endfunction : new

//===================================================================================
// Build Phase
//===================================================================================      
function void counter_output_agent::build_phase(uvm_phase phase);
   super.build_phase(phase); // Call the base class build_phase
   // Retrieve the environment configuration from the UVM config database
   if (!uvm_config_db#(counter_env_config)::get(this, "", "counter_env_config", m_cfg)) begin
     `uvm_fatal("CONFIG", "Cannot get() m_cfg from uvm_config_db. Have you set() it?");
   end
   // Create an instance of the output monitor if the agent is passive
  if (m_cfg.output_agent_is_active == UVM_PASSIVE) begin
    mon_h = counter_output_monitor::type_id::create("mon_h", this);
  end
endfunction : build_phase
     
//===================================================================================
// connect Phase -Connect phase to link driver and sequencer, but in output agent its 
//actually not needed since seqr & drvr is not present here
//===================================================================================
     
function void counter_output_agent::connect_phase(uvm_phase phase);
   
endfunction : connect_phase
     
`endif //GUARD_COUNTER_OUTPUT_AGENT_SV 
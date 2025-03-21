//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : counter_env_config.sv
// Project : 4bit Up Counter design & verification Infra Development
// Purpose : environment config file
// Author  : Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_COUNTER_ENV_CONFIG_SV
`define GUARD_COUNTER_ENV_CONFIG_SV

class counter_env_config extends uvm_object;
  `uvm_object_utils(counter_env_config) // Macro for registering this class with UVM's factory and utilities
  
   // Configuration flags to determine which agents and components are included in the environment
   bit has_input_agent = 1; // Flag to include/exclude the input agent
   bit has_output_agent = 1; // Flag to include/exclude the output agent
   bit has_scoreboard = 1; // Flag to include/exclude the scoreboard
   // Configuration for setting the active/passive states of agents
  
   uvm_active_passive_enum input_agent_is_active; // Indicates whether the input agent is active or passive
   uvm_active_passive_enum output_agent_is_active; // Indicates whether the output agent is active or passive
   // Virtual interface handle used to connect agents to the DUT's interface
   virtual counter_interface vif;
  
  //Constructor: new   
   extern function new(string name = "counter_env_config"); 
     
endclass: counter_env_config
     
//===================================================================================
// New Constructor
//===================================================================================
 
function counter_env_config::new(string name = "counter_env_config");
    super.new(name); // Call the parent class constructor
endfunction
  
`endif //GUARD_COUNTER_ENV_CONFIG_SV 
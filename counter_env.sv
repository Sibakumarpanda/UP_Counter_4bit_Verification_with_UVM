//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : counter_env.sv
// Project : 4bit Up Counter design & verification Infra Development
// Purpose : environment file
// Author  : Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_COUNTER_ENV_SV
`define GUARD_COUNTER_ENV_SV

class counter_env extends uvm_env;
  `uvm_component_utils(counter_env) // Register the component with the UVM factory
  
   // Agents and scoreboard instances
   counter_input_agent input_agent_h;
   counter_output_agent output_agent_h;
   counter_scoreboard scoreboard_h;
   // Environment configuration object
   counter_env_config m_cfg;
   
   //Constructor: new   
   extern function new(string name = "counter_env",uvm_component parent); 
    
   //Function: build_phase
   extern function void build_phase(uvm_phase phase);
    
   //Function: connect_phase
   extern function void connect_phase(uvm_phase phase);
     
endclass : counter_env  

//===================================================================================
// New Constructor
//===================================================================================
     
function counter_env::new(string name = "counter_env", uvm_component parent);
     super.new(name, parent); // Call the base class constructor with name and parent
endfunction : new

//===================================================================================
// Build Phase
//===================================================================================
function void counter_env::build_phase(uvm_phase phase);
    super.build_phase(phase); // Call the base class build_phase
    // Retrieve the environment configuration from the UVM config database
    if (!uvm_config_db#(counter_env_config)::get(this, "", "counter_env_config", m_cfg)) begin
      `uvm_fatal(get_type_name(), "Cannot get 'counter_env_config' from config DB. Have you set it?");
    end
    // Create instances of agents and scoreboard based on the configuration
   if (m_cfg.has_input_agent) begin
    input_agent_h = counter_input_agent::type_id::create("input_agent_h", this);
   end
   if (m_cfg.has_output_agent) begin
    output_agent_h = counter_output_agent::type_id::create("output_agent_h", this);
   end
   if (m_cfg.has_scoreboard) begin
    scoreboard_h = counter_scoreboard::type_id::create("scoreboard_h", this);
   end
endfunction : build_phase
//===================================================================================
// Connect Phase - Connect phase to establish connections between components
//===================================================================================
     
function void counter_env::connect_phase(uvm_phase phase);
    uvm_top.print_topology(); // Print the topology of the UVM environment
    // Connect input monitor port to the scoreboard input FIFO
    if (m_cfg.has_input_agent && m_cfg.has_scoreboard) begin
      input_agent_h.monh.monitor_port.connect(scoreboard_h.input_mon_fifo.analysis_export);
    end
  // Connect output monitor port to the scoreboard output FIFO
   if (m_cfg.has_output_agent && m_cfg.has_scoreboard) begin
     output_agent_h.mon_h.monitor_port_o.connect(scoreboard_h.output_mon_fifo.analysis_export);
   end
endfunction : connect_phase
  
`endif //GUARD_COUNTER_ENV_SV 
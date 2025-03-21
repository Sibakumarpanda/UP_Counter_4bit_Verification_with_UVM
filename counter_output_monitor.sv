//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : counter_output_monitor.sv
// Project : 4bit Up Counter design & verification Infra Development
// Purpose : Monitor in Passive agent/output agent
// Author  : Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_COUNTER_OUTPUT_MONITOR_SV
`define GUARD_COUNTER_OUTPUT_MONITOR_SV

class counter_output_monitor extends uvm_monitor;
   `uvm_component_utils(counter_output_monitor) // Register the component with the UVM factory
  
   // Virtual Interface for the DUT connection
   virtual counter_interface.OUTPUT_MON rdmon_inf;
   // Transaction object to capture output data
   counter_transaction output_mon_pkt;
   // Environment configuration object
   counter_env_config m_cfg;
   // Analysis port for sending transactions to the scoreboard or other components
   uvm_analysis_port#(counter_transaction) monitor_port_o;
  
   //Constructor: new   
   extern function new(string name = "counter_output_monitor",uvm_component parent); 
    
   //Function: build_phase
   extern function void build_phase(uvm_phase phase);
    
   //Function: connect_phase
   extern function void connect_phase(uvm_phase phase);
    
   //Task: run_phase
   extern virtual task run_phase(uvm_phase phase);
     
   extern task monitor();
     
endclass:counter_output_monitor  
     
//===================================================================================
// New Constructor
//===================================================================================
     
function counter_output_monitor::new(string name = "counter_output_monitor", uvm_component parent);
     super.new(name, parent); // Call the base class constructor
endfunction : new

//===================================================================================
// Build Phase
//===================================================================================
function void counter_output_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase); // Call the base class build_phase
    // Retrieve the environment configuration from the UVM config database
    if (!uvm_config_db#(counter_env_config)::get(this, "", "counter_env_config", m_cfg)) begin
     `uvm_fatal(get_type_name(), "cannot get() m_cfg from uvm_config_db");
    end
    // Initialize the analysis port
    monitor_port_o = new("monitor_port_o", this);
endfunction : build_phase

//===================================================================================
// Connect Phase
//===================================================================================
function void counter_output_monitor::connect_phase(uvm_phase phase);
     rdmon_inf = m_cfg.vif; // Connect the virtual interface
endfunction : connect_phase
     
//===================================================================================
// Run Phase -Run phase where the monitoring happens
//===================================================================================     
task counter_output_monitor::run_phase(uvm_phase phase);
    // Optionally wait for some time before starting the monitor
    repeat(2) @(rdmon_inf.output_mon_cb);
   forever begin
   // Continuously monitor the output
   monitor();
 end
  
endtask : run_phase
  
// Monitor task to capture transactions from the DUT
task counter_output_monitor::monitor();
  // Create a new transaction object
  output_mon_pkt = counter_transaction::type_id::create("output_mon_pkt");
  // Wait for the output monitoring clocking block to trigger
  @(rdmon_inf.output_mon_cb);
  `uvm_info(get_type_name(), "output_mon_cb event triggered", UVM_LOW);
   // Capture the data from the virtual interface
   output_mon_pkt.data_out = rdmon_inf.output_mon_cb.data_out;
   // Debug print to verify data capture
  `uvm_info(get_type_name(), $sformatf("DATA_OUT = %0d", output_mon_pkt.data_out), UVM_MEDIUM);
   // Print the captured transaction details
  `uvm_info(get_type_name(), $sformatf("Output monitor has captured below transaction \n%s", output_mon_pkt.sprint()), UVM_MEDIUM);
  // Write the captured transaction to the analysis port
  monitor_port_o.write(output_mon_pkt);
endtask : monitor
  
`endif //GUARD_COUNTER_OUTPUT_MONITOR_SV 
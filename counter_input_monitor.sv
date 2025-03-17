//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : counter_input_monitor.sv
// Project : 4bit Up Counter design & verification Infra Development
// Purpose : Monitor in active agent/input agent
// Author  : Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_COUNTER_INPUT_MONITOR_SV
`define GUARD_COUNTER_INPUT_MONITOR_SV

class counter_input_monitor extends uvm_monitor;
  `uvm_component_utils(counter_input_monitor) // Register the component with the UVM factory
  
   virtual counter_interface.INPUT_MON mon_if; // Virtual interface for input monitoring
   counter_transaction drv2mon_pkt; // Transaction object to capture monitored data
   counter_env_config m_cfg; // Environment configuration object
   uvm_analysis_port#(counter_transaction) monitor_port; // Analysis port for exporting captured transactions
  
    //Constructor: new   
   extern function new(string name = "counter_input_monitor",uvm_component parent); 
    
   //Function: build_phase
   extern function void build_phase(uvm_phase phase);
    
   //Function: connect_phase
   extern function void connect_phase(uvm_phase phase);
    
   //Task: run_phase
   extern virtual task run_phase(uvm_phase phase);
     
   extern task monitor();
    
endclass:counter_input_monitor

//===================================================================================
// New Constructor
//===================================================================================
function counter_input_monitor::new(string name = "counter_input_monitor", uvm_component parent);
     super.new(name, parent); // Call the base class constructor
endfunction : new

//===================================================================================
// Build Phase
//===================================================================================
function void counter_input_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase); // Call the base class build_phase 
  // Retrieve the environment configuration from the UVM config database
    if (!uvm_config_db#(counter_env_config)::get(this, "", "counter_env_config", m_cfg)) begin
    `uvm_fatal(get_type_name(), "cannot get() m_cfg from uvm_config_db");
  end
    
    // Initialize the analysis port
    monitor_port = new("monitor_port", this);
endfunction : build_phase

//===================================================================================
// connect Phase
//===================================================================================
function void counter_input_monitor::connect_phase(uvm_phase phase);
    // Connect the virtual interface for input monitoring
    mon_if = m_cfg.vif;
endfunction : connect_phase

//===================================================================================
// Run Phase
//===================================================================================
task counter_input_monitor::run_phase(uvm_phase phase);
    // Synchronize with the monitor's clocking block
    @(mon_if.input_mon_cb);
    forever begin
    // Continuously monitor the input
    monitor();
  end
endtask : run_phase
  
// Task to monitor and capture transactions
task counter_input_monitor::monitor();
    begin
    // Synchronize with the monitor's clocking block
    @(mon_if.input_mon_cb);
    // Create a new transaction object
    drv2mon_pkt = counter_transaction::type_id::create("drv2mon_pkt");
      
    // Capture the monitored data into the transaction object
    drv2mon_pkt.load = mon_if.input_mon_cb.load;
    drv2mon_pkt.rst = mon_if.input_mon_cb.rst;
    drv2mon_pkt.data_in = mon_if.input_mon_cb.data_in;
    // Log the captured data
      `uvm_info(get_type_name(), $sformatf("From Input Monitor: DATA_IN = %0d", drv2mon_pkt.data_in), UVM_MEDIUM);
    `uvm_info(get_type_name(), $sformatf("Input monitor has captured the following transaction:\n%s",drv2mon_pkt.sprint()), UVM_MEDIUM);
    // Write the transaction data to the analysis port
    monitor_port.write(drv2mon_pkt);
    end
endtask : monitor
  
`endif //GUARD_COUNTER_INPUT_MONITOR_SV                                      
                                     
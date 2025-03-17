//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : counter_input_driver.sv
// Project : 4bit Up Counter design & verification Infra Development
// Purpose : Driver in active agent/input agent
// Author  : Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_COUNTER_INPUT_DRIVER_SV
`define GUARD_COUNTER_INPUT_DRIVER_SV

class counter_input_driver extends uvm_driver#(counter_transaction);
  `uvm_component_utils(counter_input_driver) // Register the component with the UVM factory
  
   virtual counter_interface.DRIVER drv_inf; // Virtual interface for driver operations
  
   counter_transaction data2duv_pkt; // Transaction object
   //counter_transaction req;
   counter_env_config m_cfg; // Environment configuration object
  
  //Constructor: new   
  extern function new(string name = "counter_input_driver",uvm_component parent); 
    
  //Function: build_phase
  extern function void build_phase(uvm_phase phase);
    
  //Function: connect_phase
  extern function void connect_phase(uvm_phase phase);
    
  //Task: run_phase
  extern virtual task run_phase(uvm_phase phase);
    
  extern virtual task send_to_dut(counter_transaction data2duv_pkt);
  
endclass:counter_input_driver

//===================================================================================
// New Constructor
//===================================================================================    
function counter_input_driver::new(string name = "counter_input_driver", uvm_component parent);
     super.new(name, parent); // Call the base class constructor
endfunction : new
    
//===================================================================================
// Build Phase
//===================================================================================  
function void counter_input_driver::build_phase(uvm_phase phase);
    super.build_phase(phase); // Call the base class build_phase
    // Retrieve the environment configuration from the UVM config database
    if (!uvm_config_db#(counter_env_config)::get(this, "", "counter_env_config", m_cfg)) begin
      `uvm_fatal("CONFIG", "Cannot get() m_cfg from uvm_config_db. Have you set() it?");
    end
endfunction : build_phase
    
//===================================================================================
// connect Phase
//===================================================================================  
function void counter_input_driver::connect_phase(uvm_phase phase);
    // Connect the virtual interface to the driver
    drv_inf = m_cfg.vif;
endfunction : connect_phase

//===================================================================================
// Run Phase
//===================================================================================
    
task counter_input_driver::run_phase(uvm_phase phase);
    forever begin
    // Get the next item from the sequence
    seq_item_port.get_next_item(req);
    // Send the item to the DUT (Device Under Test)
    send_to_dut(req);
    // Indicate that the item has been processed
    seq_item_port.item_done();
    end
endtask : run_phase
  
 // Task to send transaction data to DUT

task counter_input_driver::send_to_dut(counter_transaction data2duv_pkt);
   
    @(drv_inf.driver_cb); // Synchronize with the driver's clocking block
    // Assign transaction data to the DUT
    drv_inf.driver_cb.data_in <= data2duv_pkt.data_in;
    `uvm_info(get_type_name(), $sformatf("From Input Driver: DATA_IN = %0d", data2duv_pkt.data_in), UVM_MEDIUM);
     drv_inf.driver_cb.rst <= data2duv_pkt.rst;
     drv_inf.driver_cb.load <= data2duv_pkt.load;
endtask : send_to_dut
  
`endif //GUARD_COUNTER_INPUT_DRIVER_SV 
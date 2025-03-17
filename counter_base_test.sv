//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : counter_base_test.sv
// Project : 4bit Up Counter design & verification Infra Development
// Purpose : base test file
// Author  : Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_COUNTER_BASE_TEST_SV
`define GUARD_COUNTER_BASE_TEST_SV

class counter_base_test extends uvm_test;
  `uvm_component_utils(counter_base_test) // Register the test class with the UVM factory
  
   // Configuration and environment handles
   counter_env_config m_cfg;         // Environment configuration object
   counter_env counter_env_h;       // Handle to the environment
   counter_sequence counter_seq_h; // Handle to the sequence
  
   //Constructor: new   
   extern function new(string name = "counter_base_test",uvm_component parent);
   
   //Function: build_phase
   extern function void build_phase(uvm_phase phase);
      
   //Function: connect_phase
   extern function void connect_phase(uvm_phase phase);  
    
   //Function: end_of_elaboration_phase
   extern function void end_of_elaboration_phase(uvm_phase phase);
     
   //Function: start_of_simulation_phase  
   extern function void start_of_simulation_phase(uvm_phase phase);  
    
   //Function: run_phase
   extern task run_phase(uvm_phase phase);
      
   //Function: report_phase
   extern function void report_phase(uvm_phase phase);
      
   //Function: final_phase  
   extern function void final_phase(uvm_phase phase);
  
endclass :counter_base_test //counter_base_test extends uvm_test
     
//===================================================================================
// New
//===================================================================================
function counter_base_test::new(string name = "counter_base_test", uvm_component parent);
     super.new(name, parent);
        
endfunction //new()
     
//===================================================================================
// Build Phase
//=================================================================================== 
function void counter_base_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
   // Create the environment configuration object
   m_cfg = counter_env_config::type_id::create("m_cfg");
   // Retrieve the virtual interface from the UVM config database
    if (!uvm_config_db#(virtual counter_interface)::get(this, "", "vif", m_cfg.vif)) begin
      `uvm_fatal(get_type_name(), "Cannot get interface vif from uvm_config_db");
    end
   // Set the environment configuration in the UVM config database
    uvm_config_db#(counter_env_config)::set(this, "*", "counter_env_config", m_cfg);
   // Configure the environment settings
   m_cfg.has_input_agent = 1;
   m_cfg.has_output_agent = 1;
   m_cfg.has_scoreboard = 1;
   m_cfg.output_agent_is_active = UVM_PASSIVE;
   m_cfg.input_agent_is_active  = UVM_ACTIVE;
   // Create the environment
   counter_env_h = counter_env::type_id::create("counter_env_h", this);
  
endfunction: build_phase     
  
//===================================================================================
// Connect Phase
//===================================================================================
function void counter_base_test::connect_phase(uvm_phase phase); 
    string _name = "connect_phase";
   `uvm_info({get_type_name(),"_",_name}, $sformatf("Started."), UVM_FULL);
    super.connect_phase(phase);
  
    uvm_top.print_topology();
   `uvm_info({get_type_name(),"_",_name}, $sformatf("Ended."), UVM_FULL);
  
endfunction: connect_phase   
  
//===================================================================================
// End of elaboration Phase
//===================================================================================
function void counter_base_test::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
endfunction: end_of_elaboration_phase

//===================================================================================
// start_of_simulation_phase
//===================================================================================
function void counter_base_test::start_of_simulation_phase(uvm_phase phase);
  
    string _name = "start_of_simulation_phase";
   `uvm_info({get_type_name(),"_",_name}, $sformatf("Started."), UVM_FULL);

    super.start_of_simulation_phase(phase);

   `uvm_info({get_type_name(),"_",_name}, $sformatf("Ended."), UVM_FULL);
  
endfunction : start_of_simulation_phase      
     
//===================================================================================
// Run Phase
//===================================================================================
task counter_base_test::run_phase(uvm_phase phase);
   string _name = "run_phase";
  `uvm_info({get_type_name(),"_",_name}, $sformatf("Started Running the Test"), UVM_NONE);
 
    phase.raise_objection(this);
  
    // Check and validate the sequencer handle
    if (counter_env_h.input_agent_h.seqrh == null) begin 
      `uvm_fatal(get_type_name(), "Sequencer handle is null");  
    end
    // Create the sequence object
    counter_seq_h = counter_sequence::type_id::create("counter_seq_h");
    // Ensure the sequence is started with a valid sequencer handle
    counter_seq_h.start(counter_env_h.input_agent_h.seqrh);
    // Wait for 30 time units
    #30;
    phase.drop_objection(this); // Drop the objection to allow the phase to end
  
endtask: run_phase   
     
//===================================================================================
// report_phase
//===================================================================================
      
function void counter_base_test::report_phase(uvm_phase phase);
    string _name = "report_phase";
    int err_cnt;
    //uvm_default_report_server foo ;
    uvm_report_server foo ;
    //int err_cnt ;
    
   `uvm_info({get_type_name(),"_",_name}, $sformatf("Started."), UVM_NONE);
    $cast(foo,uvm_top.get_report_server());

    // sum num of errors from sequences (use global report server)
    err_cnt = foo.get_severity_count(UVM_ERROR) + foo.get_severity_count(UVM_FATAL);

    // sum num of errors from this test.
    $cast(foo,get_report_server());
    err_cnt += (foo.get_severity_count(UVM_ERROR) + foo.get_severity_count(UVM_FATAL)); 
    //This is an accumulation operation. The += operator adds the result of the expression on the right to the current value of err_cnt.
    //In this context, err_cnt is a variable that is being used to keep a running total of the number of errors and fatal errors encountered.

    if (err_cnt == 0)
        begin
            uvm_report_info(get_full_name(), "                                                    ", UVM_LOG);
            uvm_report_info(get_full_name(), "         _______  _______  _______  _______         ", UVM_LOG);
            uvm_report_info(get_full_name(), "        |       ||   _   ||       ||       |        ", UVM_LOG);
            uvm_report_info(get_full_name(), "        |    _  ||  |_|  ||  _____||  _____|        ", UVM_LOG);
            uvm_report_info(get_full_name(), "        |   |_| ||       || |_____ | |_____         ", UVM_LOG);
            uvm_report_info(get_full_name(), "        |    ___||       ||_____  ||_____  |        ", UVM_LOG);
            uvm_report_info(get_full_name(), "        |   |    |   _   | _____| | _____| |        ", UVM_LOG);
            uvm_report_info(get_full_name(), "        |___|    |__| |__||_______||_______|        ", UVM_LOG);
            uvm_report_info(get_full_name(), "                                                    ", UVM_LOG);
        end
    else
        begin
            uvm_report_info(get_full_name(), "                                                    ", UVM_LOG);
            uvm_report_info(get_full_name(), "         _______  _______  ___   ___                ", UVM_LOG);
            uvm_report_info(get_full_name(), "        |       ||   _   ||   | |   |               ", UVM_LOG);
            uvm_report_info(get_full_name(), "        |    ___||  |_|  ||   | |   |               ", UVM_LOG);
            uvm_report_info(get_full_name(), "        |   |___ |       ||   | |   |               ", UVM_LOG);
            uvm_report_info(get_full_name(), "        |    ___||       ||   | |   |___            ", UVM_LOG);
            uvm_report_info(get_full_name(), "        |   |    |   _   ||   | |       |           ", UVM_LOG);
            uvm_report_info(get_full_name(), "        |___|    |__| |__||___| |_______|           ", UVM_LOG);
            uvm_report_info(get_full_name(), "                                                    ", UVM_LOG);
            uvm_report_info(get_full_name(), "                                                    ", UVM_LOG);
        end
    super.report_phase(phase);
  `uvm_info({get_type_name(),"_",_name}, $sformatf("Ended."), UVM_NONE);
  
endfunction : report_phase 
      
//===================================================================================
// final_phase
//===================================================================================
function void counter_base_test::final_phase(uvm_phase phase);
  
  string _name = "final_phase";

  `uvm_info({get_type_name(),"_",_name}, $sformatf("Started."), UVM_NONE);
  super.final_phase(phase);

  `uvm_info({get_type_name(),"_",_name}, $sformatf("Ended."), UVM_NONE);
endfunction : final_phase      
        

`endif //GUARD_COUNTER_BASE_TEST_SV 
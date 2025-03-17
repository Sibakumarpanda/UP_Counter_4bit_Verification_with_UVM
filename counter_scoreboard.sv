//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : counter_scoreboard.sv
// Project : 4bit Up Counter design & verification Infra Development
// Purpose : scoreboard file
// Author  : Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_COUNTER_SCOREBOARD_SV
`define GUARD_COUNTER_SCOREBOARD_SV

class counter_scoreboard extends uvm_scoreboard;
   `uvm_component_utils(counter_scoreboard)
  
    // Analysis FIFOs to receive transactions from monitors
    uvm_tlm_analysis_fifo#(counter_transaction) input_mon_fifo;
    uvm_tlm_analysis_fifo#(counter_transaction) output_mon_fifo;
  
    // Transaction objects for input, output, expected output, and coverage
    counter_transaction input_mon_pkt;
    counter_transaction output_mon_pkt;
    counter_transaction expected_output_pkt;
  
    counter_transaction cov_data_pkt;
  
    // Counters for tracking verified data and received packets
    int data_verified = 0;
    int input_mon_pkt_count = 0;
    int output_mon_pkt_count = 0;
    
    //Constructor: new   
    extern function new(string name = "counter_scoreboard",uvm_component parent); 
    
    //Function: build_phase
    //extern function void build_phase(uvm_phase phase);
    
    //Function: connect_phase
    extern virtual task run_phase(uvm_phase phase);
      
    // Function: report_phase
    extern function void report_phase(uvm_phase phase);
      
    extern task ref_model_logic();
        
    extern virtual task validate_output();
  
    // Covergroup for coverage analysis
    covergroup counter_coverage;
      option.per_instance = 1;                       // Enable per-instance coverage
      LOAD_DATA : coverpoint cov_data_pkt.data_in { // Coverage bins for data_in
      bins ZERO = {0};
      bins LOW1 = {[1:2]};
      bins LOW2 = {[3:4]};
      bins MID_LOW = {[5:6]};
      bins MID = {[7:8]};
      bins MID_HIGH = {[9:10]};
      bins HIGH1 = {[11:12]};
      bins HIGH2 = {[13:14]};
      bins MAX = {15};
        
      }
      
      RESET_CMD : coverpoint cov_data_pkt.rst { // Coverage bins for reset signal 
        bins cmd_rst = {0, 1};
        }
      
      LOAD_CMD : coverpoint cov_data_pkt.load { // Coverage bins for load signal 
        bins load_dut = {0, 1};
        }
      
     // Cross coverage of LOAD_CMD and LOAD_DATA
     READxWRITE : cross LOAD_CMD, LOAD_DATA;
      
   endgroup
  
endclass : counter_scoreboard

//===================================================================================
// New Constructor -Constructor to initialize the scoreboard
//===================================================================================       
  
function counter_scoreboard::new(string name = "counter_scoreboard", uvm_component parent);
    super.new(name, parent); // Call the base class constructor
    input_mon_fifo = new("input_mon_fifo", this); // Initialize the input FIFO
    output_mon_fifo = new("output_mon_fifo", this); // Initialize the output FIFO
    expected_output_pkt = counter_transaction::type_id::create("expected_output_pkt"); // Create the expected output transaction
    counter_coverage = new; // Initialize the covergroup
endfunction : new

//===================================================================================
// Run Phase -Run phase to continuously check for input and output transactions
//===================================================================================
task counter_scoreboard::run_phase(uvm_phase phase);
    forever begin
      
    // Get transactions from the input monitor FIFO
    input_mon_fifo.get(input_mon_pkt);
    input_mon_pkt_count++;
      `uvm_info(get_type_name(), $sformatf("From Input Monitor to Scoreboard---> Scoreboard has received the following packet from input monitor:\n%s", input_mon_pkt.sprint()), UVM_MEDIUM);
      
    // Get transactions from the output monitor FIFO
    output_mon_fifo.get(output_mon_pkt);
    output_mon_pkt_count++;
      `uvm_info(get_type_name(), $sformatf("From Output Monitor to Scoreboard---> Scoreboard has received the following packet from output monitor:\n%s", output_mon_pkt.sprint()), UVM_MEDIUM);
      
    // Perform reference model logic and validation
    ref_model_logic();
    validate_output();
    end
endtask : run_phase
  
// Reference model logic to generate expected output based on input
task counter_scoreboard::ref_model_logic();
   begin
   // Implement reference model behavior based on input conditions
     if (input_mon_pkt.rst || (input_mon_pkt.load && input_mon_pkt.data_in >= 13)) begin
        expected_output_pkt.data_out = 4'b0;                        // Reset or special load case
     end else if (input_mon_pkt.load) begin
        expected_output_pkt.data_out = input_mon_pkt.data_in;      // Load new data
     end else if (expected_output_pkt.data_out >= 13) begin
        expected_output_pkt.data_out = 4'b0;                       // Overflow case
     end else begin
        expected_output_pkt.data_out = expected_output_pkt.data_out + 1; // Increment counter
     end
  end
endtask : ref_model_logic
  
// Validate the output of the DUT against the expected output
      
//expected_output_pkt: This is an object that represents the expected output packet. It is usually generated by a reference model or a scoreboard to represent the correct behavior of the design under test (DUT).
//output_mon_pkt: This is an object that represents the actual output packet observed from the DUT. It is typically captured by a monitor component in the testbench. Here it is from output monitor
      
task counter_scoreboard::validate_output();
  if (!expected_output_pkt.compare(output_mon_pkt)) // if the packets do not match, an error message is logged using the UVM reporting mechanism.
      begin : failed_compare
      `uvm_info(get_type_name(), $sformatf("Expected packet is:\n%s", expected_output_pkt.sprint()), UVM_MEDIUM);
      `uvm_info(get_type_name(), $sformatf("DUT's output packet is:\n%s", output_mon_pkt.sprint()), UVM_MEDIUM);
       `uvm_error("PACKET_MISMATCH", "The output packet does not match the expected packet.")
       // Optionally end simulation or raise an error if needed
       // $finish;
     end else begin
      `uvm_info(get_type_name(), "Data match successful", UVM_MEDIUM);
      data_verified++;
    end
    
    // Update coverage with the current input transaction
    cov_data_pkt = input_mon_pkt;
    counter_coverage.sample(); // Sample the coverage data
    `uvm_info(get_type_name(), $sformatf("STDOUT: %3.2f%% coverage achieved.", counter_coverage.get_inst_coverage()), UVM_MEDIUM);
    // Display detailed coverage information
    $display("Coverage = %.2f%%", counter_coverage.get_coverage());
    $display("Overall coverage = %0f", $get_coverage());
    $display("Coverage of covergroup 'counter_coverage' = %0f", counter_coverage.get_coverage());
    $display("Coverage of coverpoint 'LOAD_DATA' = %0f", counter_coverage.LOAD_DATA.get_coverage());
    $display("Coverage of coverpoint 'RESET_CMD' = %0f", counter_coverage.RESET_CMD.get_coverage());
    $display("Coverage of coverpoint 'LOAD_CMD' = %0f", counter_coverage.LOAD_CMD.get_coverage());
    
endtask : validate_output
  
// Report phase to summarize results at the end of simulation
function void counter_scoreboard::report_phase(uvm_phase phase);
  $display("\n----------- Scoreboard Comparision Summary ----------\n");
    $display("Input monitor packet count = %0d, Output monitor packet count = %0d, Number of successful comparisons = %0d\n", input_mon_pkt_count, output_mon_pkt_count, data_verified);
     $display("--------------------------------\n");
endfunction : report_phase
  
`endif //GUARD_COUNTER_SCOREBOARD_SV                                      
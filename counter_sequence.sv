//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : counter_sequence.sv
// Project : 4bit Up Counter design & verification Infra Development
// Purpose : 
// Author  : Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_COUNTER_SEQUENCE_SV
`define GUARD_COUNTER_SEQUENCE_SV

class counter_sequence extends uvm_sequence#(counter_transaction);
   `uvm_object_utils(counter_sequence) // Register the class with UVM factory

    int num_tranx = 1;// Variable to keep track of the transaction number  
   //  Constructor: new   
    extern function new(string name = "counter_sequence");  
    //  Task: body-This is the user-defined task where the main sequence code resides.
    extern virtual task body();
      
endclass :counter_sequence

//===================================================================================
// New
//===================================================================================   
 
function counter_sequence::new(string name = "counter_sequence");
    super.new(name); // Call base class constructor
endfunction : new
      
//===================================================================================
// BODY TASK- Main task that executes the sequence
//===================================================================================
      
task counter_sequence::body();
  repeat (50) begin  
     req = counter_transaction::type_id::create("req"); // Create a new instance of counter_trans  
     start_item(req);                                   // Start the sequence item  
   if (num_tranx == 1) begin                         // If it is the first transaction, force 'rst' to 1
       assert(req.randomize() with {rst == 1;});      // Randomize transaction with 'rst' set to 1
       num_tranx++;                                    // Increment transaction number
   end 
   else begin
     assert(req.randomize());                 // Randomize rest of the transaction without constraints
   end   
     finish_item(req);                        // Finish the sequence item
   end
endtask : body
  
`endif //GUARD_COUNTER_SEQUENCE_SV    
`include "uvm_macros.svh"
package subscriber_pkg;
import uvm_pkg::*;
import transaction_pkg::*;
class my_subscriber extends uvm_subscriber #(my_sequence_item);

    `uvm_component_utils (my_subscriber);
    my_sequence_item seq_item;
    
    covergroup cv1;
      
      addr_cp : coverpoint seq_item.addr;
      rst_cp : coverpoint seq_item.rst;
      data_in_cp : coverpoint seq_item.data_in;
      en_cp : coverpoint seq_item.en;
      re_cp : coverpoint seq_item.re;

    endgroup




    virtual function void write(my_sequence_item t);
        seq_item = t;
        cv1.sample();
    endfunction


    function new(string name = "my_subscriber" , uvm_component parent = null);
        super.new(name , parent);
        cv1 = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seq_item  = my_sequence_item::type_id::create("seq_item");
        $display("subscriber build phase");
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("subscriber connect phase");
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        $display("subscriber run phase");
    endtask
endclass
endpackage
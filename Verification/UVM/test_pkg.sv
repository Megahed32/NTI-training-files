`include "uvm_macros.svh"
`include "interface.sv"

package test_pkg;
import sequence_pkg::*;
import env_pkg::*;
import uvm_pkg::*;
       
class my_test extends uvm_test;
    `uvm_component_utils (my_test);
    
    my_env env;
    my_sequence seq;

    virtual intf vif_test;
    
    function new(string name = "my_test" , uvm_component parent = null);
        super.new(name , parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = my_env::type_id::create("env", this);
        seq = my_sequence::type_id::create("sequence");

        if(!(uvm_config_db #(virtual intf)::get(this , "" , "my_vif" , vif_test)))
        `uvm_info("Getting VIF in test", $sformatf("Failed"), UVM_LOW);
        uvm_config_db #(virtual intf)::set(this , "env" , "my_vif" , vif_test);

        $display("test build phase");

    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
            $display("test connect phase");
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        $display("test run phase");

        phase.raise_objection(this);
        seq.start(env.agt1.sequencer);
        phase.drop_objection(this);

    endtask

endclass

endpackage
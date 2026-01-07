`include "uvm_macros.svh"
package agent_pkg;
import uvm_pkg::*;
import driver_pkg::*;
import sequencer_pkg::*;
import monitor_pkg::*;
import transaction_pkg::*;

class my_agent extends uvm_agent;
    `uvm_component_utils(my_agent);
    my_driver driver;
    my_sequencer sequencer;
    my_monitor monitor;

    virtual intf vif_agent;

    uvm_analysis_port #(my_sequence_item) agent_ap;

    function new(string name = "my_agent" , uvm_component parent = null);
        super.new(name , parent);
        agent_ap  = new("agent_ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver = my_driver::type_id::create("driver", this);
        sequencer = my_sequencer::type_id::create("sequencer", this);
        monitor = my_monitor::type_id::create("monitor", this);

        

        if (!(uvm_config_db #(virtual intf)::get(this , "" , "my_vif" , vif_agent)))
        `uvm_info("Getting VIF in agent", $sformatf("Failed"), UVM_LOW);
        uvm_config_db #(virtual intf)::set(this , "driver" , "my_vif" , vif_agent);
        uvm_config_db #(virtual intf)::set(this , "monitor" , "my_vif" , vif_agent);

        $display("agent build phase");
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        monitor.monitor_ap.connect(agent_ap);
        driver.seq_item_port.connect(sequencer.seq_item_export);
        $display("agent connect phase");
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        $display("agent run phase");
    endtask
endclass

endpackage
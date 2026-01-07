`include "uvm_macros.svh"
package env_pkg;
import uvm_pkg::*;
import subscriber_pkg::*;
import scoreboard_pkg::*;
import agent_pkg::*;


class my_env extends uvm_env;
    `uvm_component_utils (my_env);
    my_subscriber subscriber ;
    my_agent agt1;
    my_sb scoreboard;
    virtual intf vif_env;

    function new(string name = "my_env" , uvm_component parent = null);
        super.new(name , parent);
    endfunction

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    subscriber = my_subscriber::type_id::create("subscriber", this);
    agt1 = my_agent::type_id::create("agt1", this);
    scoreboard = my_sb::type_id::create("scoreboard", this);

    if(!uvm_config_db #(virtual intf)::get(this , "" , "my_vif" , vif_env))
    `uvm_info("Getting VIF in env", $sformatf("Failed"), UVM_LOW);
    uvm_config_db #(virtual intf)::set(this , "agt1" , "my_vif" , vif_env);
    $display("env build phase");
    endfunction

    function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);


    agt1.agent_ap.connect(scoreboard.sb_fifo.analysis_export);
    agt1.agent_ap.connect(subscriber.analysis_export);
        $display("env connect phase");
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        $display("env run phase");
    endtask
endclass

endpackage
`include "uvm_macros.svh"
`include "interface.sv"

package monitor_pkg;

import uvm_pkg::*;
import transaction_pkg::*;
import shared_pkg::*;

class my_monitor extends uvm_monitor;
    
    `uvm_component_utils(my_monitor);
    virtual intf vif_monitor;
    uvm_analysis_port #(my_sequence_item) monitor_ap;
    logic [3:0] addr_q [$];

    function new(string name = "my_monitor" , uvm_component parent = null);
    super.new(name , parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!(uvm_config_db #(virtual intf)::get(this , "" , "my_vif" , vif_monitor)))
        `uvm_info("Getting VIF in monitor", $sformatf("Failed"), UVM_LOW);
        monitor_ap  = new("monitor_ap", this);

        $display("monitor build phase");
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("monitor connect phase");
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        $display("monitor run phase");

        forever begin
            
            my_sequence_item tr = my_sequence_item::type_id::create("tr"); 
            @(posedge vif_monitor.clk);
            // 1. Reset Logic
            if(!vif_monitor.rst) begin
                addr_q.delete();
                continue; // Skip the rest of the loop during reset
            end

            // 2. Command Phase (Write or Start of Read)
            // Note: Mutually exclusive 'en' and 're' means only one block here executes
            if (vif_monitor.en || (vif_monitor.re && !vif_monitor.valid_out)) begin
            
                tr.addr    = vif_monitor.addr;
                tr.data_in = vif_monitor.data_in;
                tr.en      = vif_monitor.en;
                tr.re      = vif_monitor.re;
                tr.rst     = vif_monitor.rst;
                tr.valid_out = vif_monitor.valid_out;
                tr.data_out  = vif_monitor.data_out;
                if (vif_monitor.re) addr_q.push_back(vif_monitor.addr);
            end

            // 3. Data Phase (Response) - INDEPENDENT IF
            if (vif_monitor.valid_out) begin
                if (addr_q.size() > 0) begin 
                    if (vif_monitor.re) addr_q.push_back(vif_monitor.addr); // Re-add for multiple reads
                    tr.addr_read     = addr_q.pop_front();
                    tr.addr          = vif_monitor.addr;
                    tr.data_in       = vif_monitor.data_in;
                    tr.data_out  = vif_monitor.data_out;
                    tr.valid_out = vif_monitor.valid_out;
                    tr.re        = vif_monitor.re;
                    tr.en        = vif_monitor.en;
                    tr.rst       = vif_monitor.rst;
                end else begin
                    `uvm_error("MON", "Unexpected valid_out detected")
                end
            end
            monitor_ap.write(tr);
        end

    endtask
endclass



endpackage
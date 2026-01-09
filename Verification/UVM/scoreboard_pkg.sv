`include "uvm_macros.svh"
package scoreboard_pkg;
import transaction_pkg::*;
import uvm_pkg::*;

int error_count , correct_count;
logic [31:0] memory_simulation [16];

class my_sb extends uvm_scoreboard;
    `uvm_component_utils (my_sb);
    
    uvm_tlm_analysis_fifo #(my_sequence_item) sb_fifo;
    uvm_analysis_export #(my_sequence_item) sb_aexport;
    my_sequence_item seq_item;

    function new(string name = "my_sb" , uvm_component parent = null);
        super.new(name , parent);
    endfunction

    virtual function void write(my_sequence_item t);

    endfunction
    
    

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_fifo = new("sb_fifo", this);
        sb_aexport = new("sb_aexport", this);
        seq_item  = my_sequence_item::type_id::create("seq_item");
        $display("scoreboard build phase");
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_aexport.connect(sb_fifo.analysis_export);
        $display("scoreboard connect phase");
    endfunction

    task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        // Blocking get: wait for an item from the monitor
        sb_fifo.get_peek_export.get(seq_item); 
        check_result(seq_item);
        // Fix: Call convert2string ON THE ITEM, not the scoreboard
        `uvm_info("Scoreboard", seq_item.convert2string(), UVM_MEDIUM);

    end
endtask

    virtual function string convert2string();
        return $sformatf("Scoreboard received item %p at time %t", seq_item, $time);
        endfunction


    task check_result(my_sequence_item seq_item);
        // Implement reference model logic here
        if(seq_item.valid_out) begin
            // Read operation
        if(seq_item.data_out !=memory_simulation[seq_item.addr_read]) begin
            error_count++;
            `uvm_error("DATA_MISMATCH", $sformatf("At time %t: Read data %0d does not match expected data %0d at address %0d", $time, seq_item.data_out, memory_simulation[seq_item.addr_read], seq_item.addr_read));
        end else begin
            correct_count++;
            `uvm_info("DATA_MATCH", $sformatf("At time %t: Read data %0d matches expected data at address %0d", $time, seq_item.data_out, seq_item.addr_read), UVM_MEDIUM);
        end
     end

        if(seq_item.en) begin
            // Write operation
            memory_simulation[seq_item.addr] = seq_item.data_in;
        end

    endtask
endclass
endpackage
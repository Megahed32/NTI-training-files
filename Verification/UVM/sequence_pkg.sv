`include "uvm_macros.svh"
package sequence_pkg;

    import transaction_pkg::*;
    import uvm_pkg::*;

    
class my_sequence extends uvm_sequence;
        `uvm_object_utils (my_sequence);
        my_sequence_item seq_item;

        function new(string name = "my_sequence");
            super.new(name);
        endfunction

        task pre_body();
            `uvm_info("Sequence", $sformatf("In pre_body"), UVM_LOW);
            seq_item = my_sequence_item::type_id::create("seq_item");
        endtask

        task body();
            `uvm_info("Sequence", $sformatf("In body"), UVM_LOW);

            //reset task
            repeat(4) begin
                start_item(seq_item);
                seq_item.rst = 0;
                seq_item.en  = 0;
                seq_item.re  = 0;
            finish_item(seq_item);
            end

            // Generate 16 transactions for all address locations
            repeat(16) begin
                start_item(seq_item);
                seq_item.randomize() with {
                    seq_item.rst == 1;
                    seq_item.en  == 1;
                };
                finish_item(seq_item);
            end

            repeat(16) begin
                start_item(seq_item);
                seq_item.randomize() with {
                    seq_item.rst == 1;
                    seq_item.en  == 0;
                    seq_item.re  == 1;
                };
                finish_item(seq_item);
            end

            repeat(1000) begin
                start_item(seq_item);
                seq_item.randomize() with {
                    seq_item.rst == 1;
                };
                finish_item(seq_item);
            end


               
        endtask
endclass

endpackage
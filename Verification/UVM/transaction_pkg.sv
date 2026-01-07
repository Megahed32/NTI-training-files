 // This package defines a UVM sequence item for transactions
 // with constraints on its fields.

 `include "uvm_macros.svh"

 package transaction_pkg;
   import uvm_pkg::*;

class my_sequence_item extends uvm_sequence_item ;
    `uvm_object_utils(my_sequence_item);
    function new(string name = "my_sequence_item");
            super.new(name);
    endfunction


    randc logic [3:0] addr , addr_read;
    rand logic [31:0] data_in;
    rand logic re;
    rand logic en;
    rand logic rst;
    logic [31:0] data_out;
    logic valid_out;


    constraint rst_c     { rst dist {1 := 10 , 0 := 90}; }
    constraint en_c      { en dist {1 := 50 , 0 := 50}; }
    constraint re_c      { ((!(re & en)) == 1) ; }

    constraint data_in_c {data_in dist {32'hFFFFFFFF := 10 , 32'h00000000 := 10 , [32'h00000001 : 32'hFFFFFFFE] :/ 80}; }

    virtual function string convert2string();
    return $sformatf("rst=%b en=%b re=%b | addr=0x%0d data_in=0x%0d | data_out=0x%0d valid=%b", 
    rst, en, re, addr, data_in, data_out, valid_out);
    endfunction
endclass



 endpackage
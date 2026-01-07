`include "interface.sv"

module top();
 import uvm_pkg::*;
 import test_pkg::*;
  my_test test;

  logic clk;
  intf intf1(clk);
  
  //DUT inst

    memory_16x32 dut (
        .clk (clk),
        .re (intf1.re),
        .en (intf1.en),
        .rst (intf1.rst),
        .addr (intf1.addr),
        .data_in (intf1.data_in),
        .data_out (intf1.data_out),
        .valid_out (intf1.valid_out)
    );

    // Clock generation 
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end



    initial begin
        uvm_config_db #(virtual intf)::set(null , "uvm_test_top" , "my_vif" , intf1);
        run_test("my_test");
    end


endmodule


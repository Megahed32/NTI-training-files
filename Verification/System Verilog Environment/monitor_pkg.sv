`include "interface.sv"
package monitor_pkg;
 import stimulus::*;
 class monitor;
  mailbox log_out_mon , log_cover_output;
  mailbox log_in_mon , log_cover_input;
  packet pkt_out;
  packet pkt_in;
  virtual alu_interface vif;
 function new(virtual alu_interface vif,  mailbox log_in_mon,  mailbox log_out_mon ,  mailbox log_cover_input,  mailbox log_cover_output);
    this.log_in_mon = log_in_mon;
    this.log_out_mon = log_out_mon;
    this.log_cover_input = log_cover_input;
    this.log_cover_output = log_cover_output;
    this.vif = vif;
endfunction

  task monitor_output(int no_of_trans);
    
    repeat(no_of_trans)
    begin
      pkt_out = new();
     wait(log_out_mon.num() == 0);
     repeat(2)@(posedge vif.clk);
     #1;
     pkt_out.alu       = vif.alu;
     pkt_out.valid_out = vif.valid_out;
     pkt_out.carry     = vif.carry;
     pkt_out.zero      = vif.zero;
     pkt_out.pkt_num   = vif.pkt_num;
    //  $display("pkt_out from monitor to scoreboard = %p  at time %t" , pkt_out , $time);
     log_out_mon.put(pkt_out);
     log_cover_output.put(pkt_out);
    end
    

  endtask

  task monitor_input(int no_of_trans);
    int i =0;
    repeat(no_of_trans) begin
    pkt_in = new();
    wait(log_in_mon.num() == 0);
    @(posedge vif.clk);
    #1;
    i++;
    pkt_in.a        = vif.a;
    pkt_in.b        = vif.b;
    pkt_in.cin      = vif.cin;
    pkt_in.ctl      = vif.ctl;
    pkt_in.valid_in = vif.valid_in;
    pkt_in.pkt_num   =i;
    // $display("pkt_in from monitor to scoreboard = %p at time %t" , pkt_in , $time);
    fork
    log_in_mon.put(pkt_in);
    log_cover_input.put(pkt_in);
    join
    end


  endtask
 
 endclass
 

endpackage
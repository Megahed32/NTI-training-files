`include "interface.sv"
package driver_pkg;
import stimulus::*;
class driver;
packet pkt;
virtual alu_interface vif;
mailbox s2d_mb;
function new(virtual alu_interface alu_if , mailbox s2d_mb);
    this.vif = alu_if;
    this.s2d_mb = s2d_mb;
endfunction

task drive(int no_of_trans);
repeat(no_of_trans)
begin
    pkt = new();
    wait(s2d_mb.num() != 0);
    s2d_mb.get(pkt);
    // $display("pkt from stimulus to driver 1 = %p at time %t" , pkt , $time);
    @(posedge vif.clk);
    // $display("pkt from stimulus to driver 2 = %p at time %t" , pkt , $time);
    vif.a = pkt.a;
    vif.b = pkt.b;
    vif.ctl = pkt.ctl;
    vif.valid_in = pkt.valid_in;
    vif.cin = pkt.cin;
    vif.pkt_num =pkt.pkt_num;
    
end
endtask
endclass
    
endpackage
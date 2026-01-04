package testenv ;
import scoreboard_pkg::*;
import stimulus::*;
import driver_pkg::*;
import monitor_pkg::*;
import coverage_pkg::*;
class test_env;
mailbox s2d_mb , log_in_mon , log_out_mon , log_cover_input , log_cover_output;

driver alu_drv ;
monitor alu_mon ;

score_board alu_sb;
stim_gen alu_stim;
coverage alu_cvr;


function new(virtual alu_interface vif);
s2d_mb  = new();
log_in_mon = new();
log_out_mon = new();
log_cover_input = new();
log_cover_output = new();
alu_drv = new(vif , s2d_mb);  // interfaces vif with mbx
alu_mon = new(vif ,log_in_mon,log_out_mon , log_cover_input , log_cover_output);  // interfaces vif with mbx
alu_sb = new(log_in_mon,log_out_mon);
alu_stim = new(s2d_mb);
alu_cvr = new(log_cover_input , log_cover_output);
endfunction




task run(int no_of_trans);
fork
    alu_stim.stim_task(no_of_trans);
    alu_drv.drive(no_of_trans);
    alu_mon.monitor_input(no_of_trans);
    alu_mon.monitor_output(no_of_trans);
    alu_sb.score(no_of_trans);
    alu_cvr.cover_task(no_of_trans);
join
endtask

endclass


endpackage
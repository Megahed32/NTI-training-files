package coverage_pkg;
import stimulus::*;


class coverage;
mailbox log_cover_input , log_cover_output;

packet pkt_in , pkt_out ;
packet pkt_in_cvr = new();
packet pkt_out_cvr = new();



covergroup cvr;

//input Coverage
a_cp: coverpoint pkt_in_cvr.a
{ ignore_bins ALL_ZEROS = {4'b0000};}
b_cp: coverpoint pkt_in_cvr.b 
{
    bins ALL_ZEROS = {4'b0000};
    bins ALL_ONES  = {4'hF};
    bins ZIGZAG    = {4'b1010};
}
ctl_transitions_cp : coverpoint pkt_in_cvr.ctl 
{
    bins TRANSITIONS[] = ([0:13] => [0:13]);
}

ctl_cp : coverpoint pkt_in_cvr.ctl {
    illegal_bins ILLEGAL = {4'd14 , 4'd15};
}

valid_in_cp: coverpoint pkt_in_cvr.valid_in {
    ignore_bins ZERO = {1'b0};
}

//cross coverage
cross_ctl_a_b_cp: cross a_cp  , ctl_cp ;
endgroup

function new(mailbox log_cover_input , log_cover_output);
    cvr = new();
    this.log_cover_input = log_cover_input;
    this.log_cover_output = log_cover_output;
 endfunction

task cover_task(int no_of_trans) ;
repeat(no_of_trans)
begin
 pkt_in  = new();
 pkt_out = new();
 wait ((log_cover_input.num()!= 0)&&(log_cover_output.num()!= 0));
 fork
           log_cover_input.get(pkt_in);
           log_cover_output.get(pkt_out);
 join
 pkt_in_cvr = pkt_in ;
 pkt_out_cvr = pkt_out;
//  $display(" packet input in coverage %p" , pkt_in_cvr );
 cvr.sample();
 
end


endtask
endclass

endpackage
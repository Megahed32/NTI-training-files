package stimulus;
class packet;
 
 rand logic [3:0] a , b ;
 rand logic valid_in, cin;
 rand logic [3:0] ctl;



logic [3:0] alu;
logic valid_out , carry , zero;


constraint valid_c { valid_in == 1;}

constraint input_a_c {
        a dist {4'b1111 := 20 , 4'b0000 := 20 , [4'b0001 : 4'b1110] :/ 60};
     }

constraint input_b_c {
    b dist {4'b1111 := 20 , 4'b0000 := 20 , [4'b0001 : 4'b1110] :/ 60};
}
constraint ctl_c {
   ctl inside{[0:13]};
}
logic [4:0] pkt_num;

endclass

class stim_gen ;
mailbox s2d_mb ;
int i = 0;
packet pkt;
function new(mailbox s2d_mb);
this.s2d_mb = s2d_mb;
endfunction

task stim_task(int no_of_trans);
 repeat(no_of_trans)
  begin
    pkt = new();
    i++;
    pkt.pkt_num = i;
    wait(s2d_mb.num() == 0);
    pkt.randomize();
    // $display("packet from stim = %p at time %t" ,pkt , $time);
    s2d_mb.put(pkt); 
   
  end
endtask

endclass
endpackage

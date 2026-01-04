
package scoreboard_pkg;
import stimulus::*;
class score_board;
 mailbox log_in_mon , log_out_mon;
 packet pkt_in , pkt_out;


 
 function new(mailbox log_in_mon , log_out_mon);
    this.log_in_mon = log_in_mon;
    this.log_out_mon = log_out_mon;
 endfunction


 task score(int no_of_trans);
    int i = 0;
   repeat(no_of_trans)
   begin
       pkt_in = new();
       pkt_out = new();
       wait ((log_out_mon.num()!= 0)&&(log_in_mon.num()!= 0));
       fork
           log_in_mon.get(pkt_in);
           log_out_mon.get(pkt_out);
       join
                //  $display("reference model for packet in %p , packet out %p" ,pkt_in , pkt_out);

       reference_model(pkt_in , pkt_out);     
   end


 endtask
int error_count;
  task reference_model(packet pkt_in , pkt_out);
  
         logic valid_out_exp ;
         logic [3:0] alu_exp       ;
         logic carry_exp     ;
         logic zero_exp     ;
        //  $display("ctl = %d" , pkt_in.ctl );
        if (pkt_in.valid_in) begin  
             if (pkt_in.ctl==4'b0000) begin
                  {carry_exp ,alu_exp} = pkt_in.b ;
             end
             else if (pkt_in.ctl==4'b0001) begin
                   {carry_exp ,alu_exp} = ++pkt_in.b ;
                  end
                   else if (pkt_in.ctl==4'b0010) begin
                        {carry_exp ,alu_exp} = --pkt_in.b ;
                    end
                    else if (pkt_in.ctl==4'b0011) begin
                        {carry_exp ,alu_exp}=pkt_in.a+pkt_in.b;
                    end
                    else if (pkt_in.ctl==4'b0100) begin
                        {carry_exp ,alu_exp}=pkt_in.a+pkt_in.b+pkt_in.cin;
                    end
                    else if (pkt_in.ctl==4'b0101) begin
                        {carry_exp ,alu_exp}=pkt_in.a-pkt_in.b;
                    end
                    else if (pkt_in.ctl==4'b0110) begin
                        {carry_exp ,alu_exp}=pkt_in.a-pkt_in.b-pkt_in.cin;
                    end
                    else if (pkt_in.ctl==4'b0111) begin
                        {carry_exp ,alu_exp}=pkt_in.a&pkt_in.b;
                    end
                    else if (pkt_in.ctl==4'b1000) begin
                        {carry_exp ,alu_exp}=pkt_in.a|pkt_in.b;
                    end
                    else if (pkt_in.ctl==4'b1001) begin
                        {carry_exp ,alu_exp}=pkt_in.a^pkt_in.b;
                    end
                    else if (pkt_in.ctl==4'b1010) begin
                        {carry_exp ,alu_exp}={pkt_in.b,1'b0};
                    end
                    else if (pkt_in.ctl==4'b1011) begin
                        {carry_exp ,alu_exp}={1'b0,pkt_in.b[3:1]};
                    end
                    else if (pkt_in.ctl==4'b1100) begin
                        {carry_exp ,alu_exp}={pkt_in.b,pkt_in.cin};  
                    end
                    else if (pkt_in.ctl==4'b1101) begin
                        {carry_exp ,alu_exp}={pkt_in.cin,pkt_in.b[3:1]};            
                    end
                    zero_exp = ~(alu_exp[0]|alu_exp[1]|alu_exp[2]|alu_exp[3]);
                    valid_out_exp =1'b1;
                end
          if ((alu_exp!=pkt_out.alu) || (carry_exp !=pkt_out.carry) || (zero_exp != pkt_out.zero) || (valid_out_exp != pkt_out.valid_out)) begin
                    $display("ERROR NOT MATCHED for CTL %d", pkt_in.ctl);
                    $display("carry_exp =%0d , carry =%0d",carry_exp,pkt_out.carry);
                    $display("zero_exp =%0d , zero =%d",zero_exp,pkt_out.zero);
                    $display("alu_exp =%0d , alu =%0d",alu_exp,pkt_out.alu);
                    $display("valid_out_exp =%0d , valid_out =%0d",valid_out_exp,pkt_out.valid_out);
                    error_count++;
                end
        endtask
endclass
    
endpackage
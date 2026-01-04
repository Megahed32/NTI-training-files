import testenv::*;
module tb_top ();
    logic clk , reset;
    test_env test;
    alu_interface alu_if(clk , reset);
    int no_of_trans = 10;
    initial begin
        clk = 0 ;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        test = new(alu_if);
        reset = 0 ;
        #50;
        reset = 1 ;
        #20;
        test.run(no_of_trans);
        #50; 
        $display("no of errors : %0d" , test.alu_sb.error_count);
        $stop;
        
    end

alu u_alu (
    .clk       (clk),
    .reset     (reset),
    .valid_in  (alu_if.valid_in),
    .a         (alu_if.a),
    .b         (alu_if.b),
    .cin       (alu_if.cin),
    .ctl       (alu_if.ctl),
    .valid_out (alu_if.valid_out),
    .alu       (alu_if.alu),
    .carry     (alu_if.carry),
    .zero      (alu_if.zero)
);

    
endmodule
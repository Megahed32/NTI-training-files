`timescale 1ns/1ps
module tb_fsm ();

reg clk , rst_n;
reg a , b;
wire y0,y1;

fsm uut (.*);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 0 ;
    a= 0 ; b = 0;
    @(negedge clk);
    rst_n = 1;
    @(negedge clk);
    @(negedge clk);
    a=1; b= 0;   //go to state S1
    @(negedge clk);
    a=0;         // stay in S1
    @(negedge clk);
    a=1;         // return to S0
    @(negedge clk);
    @(negedge clk);
    a=1;b=1;     // go to S2
    #14.9;
    #4;
    #20;
    $stop;



end
    
endmodule
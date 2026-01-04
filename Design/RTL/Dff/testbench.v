module tb ();
    parameter WIDTH = 4;
    wire [WIDTH-1 : 0] Qa,Qs;
    reg [WIDTH-1 : 0] D;
    reg clk , rst_n;
    Dff_asyn #(.WIDTH(WIDTH)) Dff_a 
    (.clk(clk),
     .rst_n(rst_n),
     .D(D),
     .Q(Q_a)
     );

     Dff_syn #(.WIDTH(WIDTH)) Dff_s
    (.clk(clk),
     .rst_n(rst_n),
     .D(D),
     .Q(Qs)
     );
     

     initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
     end

     initial begin
        rst_n = 1;
        #20;
        D = 1;
        @(posedge clk);
        rst_n = 0;
        @(posedge clk);

        $stop;

     end
endmodule
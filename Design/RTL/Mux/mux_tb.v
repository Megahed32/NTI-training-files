module tb_mux;

    parameter WIDTH = 4;

    reg  [WIDTH-1:0] A, B;
    reg  Sel;
    wire [WIDTH-1:0] Out;

    // Instantiate DUT
    mux #(WIDTH) dut (
        .A(A),
        .B(B),
        .Sel(Sel),
        .Out(Out)
    );

    initial begin
        // Apply test vectors
        A = 4'b1010; B = 4'b0101;

        Sel = 0; #10;
        Sel = 1; #10;

        A = 4'b1111; B = 4'b0000;

        Sel = 0; #10;
        Sel = 1; #10;

        $stop;
    end

    initial begin
        $monitor("Time=%0t  Sel=%b  A=%b  B=%b  Out=%b",
                 $time, Sel, A, B, Out);
    end

endmodule

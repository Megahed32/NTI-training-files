module mux #(parameter WIDTH = 4)(
    input  wire [WIDTH-1:0] A,
    input  wire [WIDTH-1:0] B,
    input  wire Sel,
    output reg  [WIDTH-1:0] Out
);

    always @(*) begin
        case (Sel)
            1'b0 : Out = A;
            1'b1 : Out = B;
            default: Out = A;
        endcase
    end

endmodule

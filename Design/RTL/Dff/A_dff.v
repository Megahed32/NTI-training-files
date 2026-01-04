module Dff_asyn #(parameter WIDTH = 8)  (
    input [WIDTH-1 :0] D,
    input clk , rst_n,
    output reg [WIDTH-1 :0] Q
);
    

    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n)
        Q <= {WIDTH{1'b0}};
        else
        Q <= D;
    end
endmodule

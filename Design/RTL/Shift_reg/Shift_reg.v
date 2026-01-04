module Shift_reg #(
    parameter WIDTH = 4
) (
    input  wire serial_in,
    input  wire clk, rst_n, en,
    output reg  serial_out
);

reg [WIDTH-1:0] shift_reg;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        shift_reg  <= {WIDTH{1'b0}};
        serial_out <= 1'b0;
    end
    else if(en)
    begin
        shift_reg  <= {shift_reg[WIDTH-2:0], serial_in};
        serial_out <= shift_reg[WIDTH-1];
    end
end
endmodule

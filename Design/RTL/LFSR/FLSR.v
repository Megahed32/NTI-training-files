module LFSR #(
    parameter WIDTH = 4
) (
    input  wire serial_in,
    input  wire clk, rst_n, en,
    output reg [WIDTH-1:0] shift_reg
);

wire serial_in_mux , feedback;

assign feedback = shift_reg[3]^shift_reg[0];

assign serial_in_mux = (en)? feedback:serial_in; 

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        shift_reg  <= {WIDTH{1'b0}};
    end
    else
    begin
        shift_reg  <= {shift_reg[WIDTH-2:0], serial_in_mux};
    end
end
endmodule

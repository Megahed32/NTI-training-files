module ALU #(
    parameter DATA_WIDTH = 4
) (
    input wire [DATA_WIDTH-1 : 0 ] A, B,
 
    input wire [1:0] opcode ,
    output wire status,
    output wire a,b,c,d,e,f,g
);
reg [DATA_WIDTH : 0 ] Out;
localparam ADD = 2'd0;
localparam SUB = 2'd1;
localparam AND = 2'd2;
localparam XOR = 2'd3;

assign status = ((Out ==0)&&(opcode == SUB))? 1:0;
always @(*) begin

    case (opcode)
        ADD:
        begin
           Out = A + B; 
        end
        SUB:
        begin
            Out = A - B; 
        end
        AND:
        begin
            Out = A & B; 
        end
        XOR: 
        begin
            Out = A ^ B; 
        end
        default:
        begin
            Out = A + B;
        end 
    endcase
end

seven_seg_decoder #(.DATA_WIDTH(DATA_WIDTH)) U0_seven_seg (
    .Value_in(Out),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .e(e),
    .f(f),
    .g(g)
);

    
endmodule
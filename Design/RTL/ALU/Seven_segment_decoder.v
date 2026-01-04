module seven_seg_decoder #(parameter DATA_WIDTH = 4)
( input wire [DATA_WIDTH : 0] Value_in,
  output reg a,b,c,d,e,f,g
)
;
always @(*) begin
    case (Value_in)
       5'b00000 : {a,b,c,d,e,f,g} = 7'b0000001; // 0 
       5'b00001 : {a,b,c,d,e,f,g} = 7'b1001111; // 1
       5'b00010 : {a,b,c,d,e,f,g} = 7'b0010010; // 2
       5'b00011 : {a,b,c,d,e,f,g} = 7'b0000110; // 3
       5'b00100 : {a,b,c,d,e,f,g} = 7'b1001100; // 4
       5'b00101 : {a,b,c,d,e,f,g} = 7'b0100100; // 5
       5'b00110 : {a,b,c,d,e,f,g} = 7'b0100000; // 6
       5'b00111 : {a,b,c,d,e,f,g} = 7'b0001111; // 7
       5'b01000 : {a,b,c,d,e,f,g} = 7'b0000000; // 8
       5'b01001 : {a,b,c,d,e,f,g} = 7'b0000100; // 9
       5'b01010 : {a,b,c,d,e,f,g} = 7'b0001000; // A
       5'b01011 : {a,b,c,d,e,f,g} = 7'b1100000; // B
       5'b01100 : {a,b,c,d,e,f,g} = 7'b0110001; // C
       5'b01101 : {a,b,c,d,e,f,g} = 7'b1000010; // D
       5'b01110 : {a,b,c,d,e,f,g} = 7'b0110000; // E
       5'b01111 : {a,b,c,d,e,f,g} = 7'b0111000; // F
         

        default: {a,b,c,d,e,f,g} = 7'b1111111;
    endcase
end
    
endmodule
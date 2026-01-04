module four_bit_full_adder(

input [3:0]a,b,
input cin,
output [3:0]sum,
output cout

	);
wire w1,w2,w3;
full_adder f1 (.a(a[0]),.b(b[0]),.cin(cin),.sum(sum[0]), .cout(w1));
full_adder f2 (.a(a[1]),.b(b[1]),.cin(w1),.sum(sum[1]), .cout(w2));
full_adder f3 (.a(a[2]),.b(b[2]),.cin(w2),.sum(sum[2]), .cout(w3));
full_adder f4 (.a(a[3]),.b(b[3]),.cin(w3),.sum(sum[3]), .cout(cout));

endmodule
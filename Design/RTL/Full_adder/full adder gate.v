module full_adder (

input a,b,cin,
output sum,cout
	);

wire w1,w2,w3;

assign sum=a^b^cin;
assign w1=a&b;
assign w2=a&cin;
assign w3=b&cin;
assign cout=w1|w2|w3;


endmodule



module lab1_2(a, b, cin, sum, cout);
	input a, b ,cin;
	output sum, cout;

	assign sum = a ^ b ^ cin;
	assign cout = ( a & b ) | ( b & cin ) | ( a & cin );
endmodule

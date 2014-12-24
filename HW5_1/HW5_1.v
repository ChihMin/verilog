module full_adder(S, C, x, y, z);
	output S, C;
	input x, y, z;
	
	assign S = x ^ y ^ z;
	assign C = ( x & y ) || ( y & z ) || ( x & z );  

endmodule


module HW5_1(S ,V, A, B);
	output	[2:0]	S;
	output	V;

	input	[2:0]	A, B;
	wire C0, C1, C2, C3;

	assign	C0 = 0; 

	full_adder	F1(S[0], C1, A[0], B[0], C0),
				F2(S[1], C2, A[1], B[1], C1), 
				F3(S[2], C3, A[2], B[2], C2);
	assign	V = C2 ^ C3;

	
endmodule	

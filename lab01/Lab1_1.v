module lab1_1(a, b, cin, sum, cout);
	input a, b, cin;
	output sum, cout;
	wire sum_tmp, carry_tmp1, carry_tmp2, carry_tmp3;
	wire carry_tmp4;

	xor( sum_tmp, a, b );
	xor( sum, sum_tmp, cin);


	//cout = ( a & b )| ( b & cin ) | ( a & cin ) 
	and( carry_tmp1, a, b);
	and( carry_tmp2, a, cin);
	and( carry_tmp3, b, cin);

	or( carry_tmp4, carry_tmp1, carry_tmp2);
	or( cout, carry_tmp4, carry_tmp3); 
	
endmodule

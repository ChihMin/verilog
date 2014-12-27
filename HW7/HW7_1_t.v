module HW7_1_t;

	wire		[1:0]	out;
	reg	clk, rst_n, in;

	HW7_1 cmp(
		.out(out),
		.clk(clk),
		.rst_n(rst_n),
		.x_in(in)
	);
	
	initial	begin
		clk = 0; rst_n = 0; in = 1;
	end	

	always #10
		clk = ~clk;

	always #10
		if( !rst_n )	rst_n = 1; 

	always #20
		in = ~in;
	
	initial	begin
		$monitor($time, " --> in = %d, out = %d",in, out);
	end

	initial	
		#300	$finish;
endmodule

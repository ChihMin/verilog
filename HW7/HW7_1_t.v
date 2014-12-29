module HW7_1_t;

	wire	out;
	reg	clk, rst_n, in;

	HW7_1 cmp(
		.out(out),
		.clk(clk),
		.rst_n(rst_n),
		.x_in(in)
	);
	
	initial	begin
		clk = 0; rst_n = 0; in = 0;
	end	

	always #10
		clk = ~clk;
	
	initial fork
		#10		rst_n = 1;
		#100	rst_n = 0;
		#101	rst_n = 1;
		#10		in = 1;
		#30		in = 0;
		#50		in = 0;
		#70		in = 1;
		#90		in = 0;
		#110	in = 1;
		#130	in = 1;
		#150	in = 0;
		#170	in = 1;
		#190	in = 0;
	join
	
	initial	begin
		$monitor($time, " --> in = %d, out = %d",in, out);
	end

	initial	
		#300	$finish;
endmodule

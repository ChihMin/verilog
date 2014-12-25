module Prac;	
	reg clk, rst, start;
	reg		[31:0]	in;
	wire	[31:0]	out;

	flipflop f1(clk, rst, in, out);   

	initial begin
		rst = 1;
		in = 0;
		clk = 0;
		#10 rst = 0 ;
	end
	always #10	begin 
		clk = ~clk; 
		if( out == 5 )	rst = 1;
		else	rst = 0;
	end
	
	initial begin
		#300	$finish;
	end

	initial begin
		$monitor($time, " --> clk = %d, rst = %d, in = %d, out = %d",clk, rst, in, out) ; 
	end

	
endmodule

	

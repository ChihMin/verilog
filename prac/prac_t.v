module Prac;	
	reg clk, rst;
	reg		[31:0]	in;
	wire	[31:0]	out;

	flipflop f1(clk, rst, in, out);   

	initial begin
		rst = 0;
		in = 0;
		clk = 0;
	end
	
	always #10 begin 
		clk = ~clk; 
	end

	always #10 begin
		if( out == 12 )	rst = 0;
		else	rst = 1 ;
	end

	initial begin
		$monitor($time, " --> clk = %d, rst = %d, in = %d, out = %d",clk, rst, in, out) ; 
	end
	
	initial
		#300 $finish; 
	
endmodule

	

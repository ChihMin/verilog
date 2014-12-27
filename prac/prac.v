module	flipflop(clk, rst, in, out);
	input	clk, rst;
	input	[31:0]	in;
	output	[31:0]	out;
	
	reg		[31:0]	out;
	 
	always@(posedge clk, negedge rst) begin
		if(!rst)	out <= 0;
		else	out <= out + 1;
	end
endmodule

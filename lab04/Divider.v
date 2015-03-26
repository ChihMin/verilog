module clock_divider1(clk_div, clk);
	input clk;
	output clk_div;
	
	reg	[22:0]		num;
	wire	[22:0]		next_num;
	
	always@(posedge clk) begin
		num <= next_num;
	end
	
	assign next_num = num + 1;
	assign clk_div = num[22];
endmodule

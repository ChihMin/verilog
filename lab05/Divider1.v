module clock_divider22(clk_div, clk);
	
	input clk;
	output clk_div;
	
	reg	[21:0]		num;
	wire	[21:0]		next_num;
	
	
	always@(posedge clk) begin
		num <= next_num;
	end
	
	assign next_num = num + 22'b1;
	assign clk_div = num[21];
endmodule

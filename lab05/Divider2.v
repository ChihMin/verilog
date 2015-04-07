module clock_divider15(clk_div, clk);
	
	input clk;
	output clk_div;
	
	reg	[14:0]		num;
	wire	[14:0]		next_num;
	
	
	always@(posedge clk) begin
		num <= next_num;
	end
	
	assign next_num = num + 15'b1;
	assign clk_div = num[14];
endmodule

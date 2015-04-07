module clock_divider24(clk_div, clk);
	input clk;
	output clk_div;
	
	reg	[23:0]		num;
	wire	[23:0]		next_num;
	
	always@(posedge clk) begin
		num <= next_num;
	end
	
	assign next_num = num + 24'b1;
	assign clk_div = num[23];
endmodule

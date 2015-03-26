module lab4_2(DISPLAY, DIGIT, clk, reset, en, dir);
	input clk, reset, en, dir;
	output	[7:0]		DISPLAY;
	output	[3:0]		DIGIT;
	wire div1, div2, cout;
	wire [3:0] BCD0, BCD1;
	
	clock_divider1 DIV1(.clk(clk), .clk_div(div1));
	clock_divider2 DIV2(.clk(clk), .clk_div(div2));
	lab4_1 BCD_COUNTER(.dir(dir), .en(en), .reset(reset), .clk(div1), .BCD0(BCD0), .BCD1(BCD1), .cout(cout));
	Show disp(.DIGIT(DIGIT), .DISPLAY(DISPLAY), .BCD0(BCD0), .BCD1(BCD1), .clk(div2));
	
endmodule

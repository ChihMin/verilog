module lab4_1(BCD0, BCD1, cout, dir, en, reset, clk);
	input clk;
	input reset;
	input en;
	input dir;
	output cout;
	output	[3:0]	BCD0;
	output	[3:0]	BCD1;
	
	wire	cout0;
	reg		outputs0, outputs1;

	Lab3_2 BCD_COUNTER_0(.cout(cout0), .BCD(BCD0), .dir(dir), .en(en), .reset(reset), .clk(clk));
	Lab3_2 BCD_COUNTER_1(.cout(cout), .BCD(BCD1), .dir(dir), .en(cout0), .reset(reset), .clk(clk));	
	
endmodule

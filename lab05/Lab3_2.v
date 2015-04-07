module Lab3_2(cout, BCD, dir, en, reset, clk);

input en, dir, reset, clk;
output	[3:0]	BCD;
output cout;

reg	[3:0]	inputs;
reg	[3:0]	BCD;
wire [3:0]	outputs;



Lab3_1 BCD_COUNTER(.cout(cout), .outputs(outputs), .inputs(inputs), .en(en), .dir(dir) );

always@(posedge clk, negedge reset) begin
	if(!reset)	begin
		BCD = 0;
		inputs = 0;
	end
	else begin
		inputs = outputs;
		BCD = outputs;
	end	
end

endmodule

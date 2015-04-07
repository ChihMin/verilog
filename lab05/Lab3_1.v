module Lab3_1(cout, outputs, inputs, en, dir);

input	en, dir;
input	[3:0]	inputs;
output	[3:0]	outputs;
output	cout;

reg [3:0]	outputs;
reg cout;

always@* begin
	if( !en )	begin 
		outputs = inputs;
		cout = 0;
	end
	
	else if( dir ) begin	
		if( inputs == 9 ) begin 
			outputs = 0;
			cout = 1;
		end
		else if( inputs > 9 ) begin
			outputs = 0;
			cout = 0;
		end
		else begin 
			outputs = inputs + 1;
			cout = 0;
		end
	end
	
	else begin
		if( inputs == 0 ) begin 
			outputs = 9;
			cout = 1;
		end
		else if( inputs > 9 ) begin
			outputs = 0;
			cout = 0;
		end
		else  begin 
			outputs = inputs - 1;
			cout = 0;
		end
	end
end


endmodule

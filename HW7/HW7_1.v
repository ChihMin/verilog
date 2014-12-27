module HW7_1(
	output reg	[1:0]	out, 
	input  clk, rst_n, x_in
);

	reg		[1:0]	state, next_state;
	parameter		S0 = 2'd0, S1 = 2'd1, S2 = 2'd2, S3 = 2'd3; 
	
	always@(posedge clk, negedge rst_n)
		if( !rst_n )	state <= 0;
		else	state <= next_state;
	
	always@(state, x_in)
		case(state)
			S0:	if(x_in)	next_state = S1; else	next_state = S0;
			S1:	if(x_in)	next_state = S2; else	next_state = S1;
			S2: if(x_in)	next_state = S3; else	next_state = S2;
			S3: if(x_in)	next_state = S0; else	next_state = S3;
		endcase
	
	always@(state, x_in)
		case(state)
			S0:	out = 1;
			S1: out = 2;
			S2:	out = 3;
			S3:	out = 0;
		endcase	

endmodule 

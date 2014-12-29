module HW7_1(
	output reg	out, 
	input  clk, rst_n, in
);

	reg	state, next_state;
	parameter	S0 = 1'b0, S1 = 1'b1; 
	
	always@(posedge clk, negedge rst_n)
		if( !rst_n )	state <= 0;
		else	state <= next_state;
	
	always@(state, in)
		case(state)
			S0:	if(in) next_state <= S1; else	next_state <= S0;
			S1:	if(in) next_state <= S1; else	next_state <= S0;
		endcase
	
	always@(state, in)
		case(state)
			S0:	out = 0;
			S1: if(!in) out = 1; else	out = 0;
		endcase	

endmodule 

module HW7_2(
	input		clk, 
				rst_n, 
				coin5, 
				coin10, 
				sel_water, 
				sel_coke, 
				sel_coffee, 
				cancel,

	output	reg	available_water, 
				available_coke, 
				available_coffee,
				drop_water, 
				drop_coke, 
				drop_coffee,
				change5, 
				change10
);
	
	reg			water, coke, coffee;
	reg			sell_state;
	reg	[4:0]	state, next_state, last_state;
	parameter	S0 = 4'd0, S1 = 4'd1, S2 = 4'd2,
				S3 = 4'd3, S4 = 4'd4, S5 = 4'd5,
				S6 = 4'd6, S7 = 4'd7, S8 = 4'd8,
				S9 = 4'd9, S10= 4'd10,S11= 4'd11; 
	always@(posedge clk, negedge rst_n)
		if( !rst_n )	begin
			water = 0;
			coke = 0;
			coffee = 0;
			sell_state <= 0;
			last_state <= 0;
			state <= S0;
			available_water <= 0;  
			available_coke <= 0; 
			available_coffee <= 0;
			change5 <= 0;
			change10 <= 0;
		end
		else begin
			if( next_state == S6 )	
				last_state = state;
			state = next_state;
		end
	
	always@(state, sell_state, coin5, coin10, sel_water, sel_coke, sel_coffee, cancel)
		case(state)
			S0:	// 0 dollars
				begin
					water = 0;
					coffee = 0;
					coke = 0;
					if( coin5 )	next_state <= S1;
					else if( coin10 ) next_state <= S2;
					else	next_state <= S0;
				end
			S1:	// 5 dollars 
				if( coin5 ) next_state <= S2;	
				else if( coin10 ) next_state <= S3;
				else if( cancel ) next_state <= S7; 
				else next_state <= S1;
			
			S2:	// 10 dollars 
				if( coin5 )	next_state <= S3;
				else if( coin10 ) next_state <= S4;
				else if( cancel ) next_state <= S8;
				else if( water ) next_state <= S6;
				else if( sel_water ) begin 
					next_state <= S6;
					water <= 1;
				end
				else next_state <= S2; 	
			S3: //	15 dollars
				if( coin5 )	next_state <= S4;
				else if( coin10 )	next_state <= S5;
				else if( cancel )	next_state <= S9;
				else if( water || coke ) next_state <= S6;
				else if( sel_water || sel_coke ) begin 
					next_state <= S6; 
					water <= sel_water;
					coke <= sel_coke;
				end
				else	next_state <= S3; 
			
			S4: //	20 dollars
				if( coin5 || coin10 )	next_state <= S5;
				else if( cancel )	next_state <= S10;
				else if( water || coke || coffee ) next_state <= S6;
				else if( sel_water || sel_coke || sel_coffee ) begin
					next_state <= S6;
					water <= sel_water;
					coke <= sel_coke;
					coffee <= sel_coffee;
				end
				else	next_state <= S4;
			
			S5:	//	25 dollars
				if( coin5 || coin10 )   next_state <= S5;
				else if( cancel ) next_state <= S11;
				else if( water || coke || coffee ) next_state <= S6;
				else if( sel_water || sel_coffee || sel_coke ) begin 
					next_state <= S6; 
					water <= sel_water;
					coke <= sel_coke;
					coffee <= sel_coffee;
				end
				else    next_state <= S5;
			S6:
				begin
					if( last_state == S2 )	next_state <= S0;
					else if( last_state == S3 ) begin	
						if( water )	next_state <= S7;
						else if( coke )	next_state <= S0;
						else next_state <= S6;
					end
					else if( last_state == S4 )	begin
						if( water ) next_state <= S8;
						else if( coke )	next_state <= S7;
						else if( coffee )  next_state <= S0;
						else	next_state <= S6;
					end	
					else if( last_state == S5 )	begin
						if( water ) next_state <= S9;
						else if( coke ) next_state <= S8;
						else if( coffee ) next_state <= S7;
						else next_state <= S6;
					end
				end
			S7:		next_state <= S0;
			S8:		next_state <= S0;
			S9:		next_state <= S7;
			S10:	next_state <= S8;
			S11:	next_state <= S9;
			default: next_state <= 0; 			
		endcase
	

	always@(state, sell_state, coin5, coin10, sel_water, sel_coke, sel_coffee, cancel)
		case(state)
			S0:
				begin
					available_water = 0;	
					available_coke = 0;
					available_coffee = 0;	
					drop_water = 0;
					drop_coke = 0; 
					drop_coffee = 0;	
					change5 = 0;
					change10 = 0; 
				end
			S1:
				begin
					available_water = 0;	
					available_coke = 0;
					available_coffee = 0;	
					drop_water = 0;
					drop_coke = 0; 
					drop_coffee = 0;	
					change5 = 0;
					change10 = 0; 
				end
			S2:
				begin
					available_water = 1;	
					available_coke = 0;
					available_coffee = 0;	
					drop_water = 0;
					drop_coke = 0; 
					drop_coffee = 0;	
					change5 = 0;
					change10 = 0; 
				end
			S3:
				begin
					available_water = 1;	
					available_coke = 1;
					available_coffee = 0;	
					drop_water = 0;
					drop_coke = 0; 
					drop_coffee = 0;	
					change5 = 0;
					change10 = 0; 
				end
			S4:
				begin
					available_water = 1;	
					available_coke = 1;
					available_coffee = 1;	
					drop_water = 0;
					drop_coke = 0; 
					drop_coffee = 0;	
					change5 = 0;
					change10 = 0; 
				end
			S5:
				begin
					available_water = 1;	
					available_coke = 1;
					available_coffee = 1;	
					drop_water = 0;
					drop_coke = 0; 
					drop_coffee = 0;	
					change5 = 0;
					change10 = 0; 
				end
			S6:
				begin
					available_water = 0;	
					available_coke = 0;
					available_coffee = 0;	
					drop_water = 0;
					drop_coke = 0; 
					drop_coffee = 0;	
					change5 = 0;
					change10 = 0; 
					if( last_state == S2 )	drop_water = 1;
					else if( last_state == S3 ) begin	
						if( water )	drop_water = 1;
						else if( coke )	drop_coke = 1;
						else	drop_coffee = 0;
					end
					else if( last_state == S4 )	begin
						if( water ) drop_water = 1;
						else if( coke )	drop_coke = 1;
						else if( coffee )  drop_coffee = 1;
						else	change5 = 0;
					end	
					else if( last_state == S5 )	begin
						if( water )	drop_water = 1;
						else if( coke ) drop_coke = 1;
						else if( coffee ) drop_coffee = 1;
						else change5 = 0;
					end
				end
			S7:
				begin	
					available_water = 0;	
					available_coke = 0;
					available_coffee = 0;	
					drop_water = 0;
					drop_coke = 0; 
					drop_coffee = 0;	
					change5 = 1;
					change10 = 0; 
				end

			S8, S9, S10, S11:
				begin	
					available_water = 0;	
					available_coke = 0;
					available_coffee = 0;	
					drop_water = 0;
					drop_coke = 0; 
					drop_coffee = 0;	
					change5 = 0;
					change10 = 1; 
				end
			default:
				begin
					available_water = 0;	
					available_coke = 0;
					available_coffee = 0;	
					drop_water = 0;
					drop_coke = 0; 
					drop_coffee = 0;	
					change5 = 0;
					change10 = 0; 
				end
		endcase
endmodule

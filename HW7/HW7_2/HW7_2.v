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

	reg			sell_state;
	reg	[2:0]	state, next_state;
	parameter	S0 = 3'd0, S1 = 3'd1, S2 = 3'd2,
				S3 = 3'd3, S4 = 3'd4, S5 = 3'd5;
		
/*	
	initial
		begin 
			available_water = 0;
			available_coke = 0;
			available_coffee = 0;
			change5 = 0;
			change10 = 0;
		end
*/
	always@(posedge clk, negedge rst_n)
		if( !rst_n )	begin
			sell_state <= 0;
			state <= S0;
			available_water <= 0;  
			available_coke <= 0; 
			available_coffee <= 0;
			change5 <= 0;
			change10 <= 0;
		end
		else	state = next_state;
	
	always@(state, sell_state, coin5, coin10, sel_water, sel_coke, sel_coffee, cancel)
		case(state)
			S0:	// 0 dollars
				begin
					if( sell_state ) sell_state <= 0; 
					if( coin5 )	next_state <= S1;
					else if( coin10 ) next_state <= S2;
					else	next_state <= S0;
				end
			S1:	// 5 dollars 
				if( coin5 ) next_state <= S2;	
				else if( coin10 ) next_state <= S3;
				else if( cancel | sell_state ) next_state <= S0; 
				else next_state <= S1;
			
			S2:	// 10 dollars 
				if( coin5 )	next_state <= S3;
				else if( coin10 ) next_state <= S4;
				else if( cancel || sel_water || sell_state ) next_state <= S0;
				else next_state <= S2;
			
			S3: //	15 dollars
				if( coin5 )	next_state <= S4;
				else if( coin10 )	next_state <= S5;
				else if( cancel || sell_state )	next_state <= S1;
				else if( sel_water )	begin
					sell_state <= 1;
					next_state <= S1;
				end
				else if( sel_coke )	next_state <= S0;
				else	next_state <= S3; 
			
			S4: //	20 dollars
				if( coin5 || coin10 )	next_state <= S5;
				else if( cancel || sell_state)	next_state <= S2;
				else if( sel_water ) begin
					sell_state <= 1;
					next_state <= S2;
				end
				else if( sel_coke ) begin
					sell_state <= 1;
					next_state <= S1;
				end
				else if( sel_coffee ) next_state <= S0;
				else	next_state <= S4;
			
			S5:	//	25 dollars
				if( coin5 || coin10 )   next_state <= S5;
				else if( cancel || sell_state ) next_state <= S3;
				else if( sel_water ) begin 
					next_state <= S3; 
					sell_state <= 1;
				end
				else if( sel_coke ) begin
					next_state <= S2;
					sell_state <= 1;
				end
				else if( sel_coffee ) begin
					next_state <= S1;
					sell_state <= 1;
				end
				else    next_state <= S5;
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
					if( cancel || sell_state  )	change5 = 1;
					else if( coin5 )	available_water = 1;
					else if( coin10 )	begin
						available_water = 1;	
						available_coke = 1;
					end
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
					if( cancel || sell_state )	change10 = 1;
					else if( coin5 )	available_coke = 1;
					else if( coin10 )	begin	
						available_coke = 1;
						available_coffee = 1;
					end
					else if( sel_water ) begin	
						available_water = 0;
						drop_water = 1;
					end
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
					if( cancel || sell_state ) change10 = 1;
					else if( coin5 || coin10 )	available_coffee = 1;		
					else if( sel_water ) begin
						available_water = 0;
						available_coke = 0;
						drop_water = 1;
						change5 = 1;
					end
					else if( sel_coke ) begin
						available_water = 0;
						available_coke = 0;
						drop_coke = 1;
					end
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
					if( cancel ) change10 = 1;		
					else if( sel_water ) begin
						available_water = 0;
						available_coke = 0;
						available_coffee = 0;
						drop_water = 1;
					end
					else if( sel_coke ) begin
						available_water = 0;
						available_coke = 0;
						available_coffee = 0;
						drop_coke = 1;
					end
					else if( sel_coffee ) begin
						available_water = 0;
						available_coke = 0;
						available_coffee = 0;
						drop_coffee = 1;
					end	
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
					if( cancel ) change10 = 1;		
					else if( sel_water ) begin
						available_water = 0;
						available_coke = 0;
						available_coffee = 0;
						drop_water = 1;
					end
					else if( sel_coke ) begin
						available_water = 0;
						available_coke = 0;
						available_coffee = 0;
						drop_coke = 1;
					end
					else if( sel_coffee ) begin
						available_water = 0;
						available_coke = 0;
						available_coffee = 0;
						drop_coffee = 1;
					end	
				end
		endcase
endmodule

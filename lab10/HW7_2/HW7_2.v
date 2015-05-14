module HW7_2(
	input clk, rst_n, cancel, 
			tea, coke, sprite, 
			money_5, money_10, money_50,
	output drop_tea, drop_coke, drop_sprite,
			 DIGIT, DISPLAY, money
);

reg drop_tea, drop_coke, drop_sprite;
			 
reg [3:0] DIGIT; 
reg [7:0] DISPLAY;
reg [7:0] money;

reg buy_tea = 1'b0, buy_coke = 1'b0, buy_sprite = 1'b0;
reg [3:0] state = 4'd0, next_state;  


parameter	S0 = 4'd0, S1 = 4'd1, S2 = 4'd2,
				S3 = 4'd3, S4 = 4'd4, S5 = 4'd5,
				S6 = 4'd6, S7 = 4'd7, S8 = 4'd8,
				S9 = 4'd9, S10= 4'd10,S11= 4'd11;  


always@(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		state <= s0;
		drop_tea <= 1'b1;
		drop_coke <= 1'b1;
		drop_sprite <= 1'b1;
	end
	else
		state <= next_state;
end

always@(state, money_5, money_10, money_50, tea, coke, sprite, cancel) begin
	case(state)
		S0:
			begin
				if(cancel)
					state¡@<= S1;
				else begin
					if(money_5) begin
						money = money + 8'd5;
						if(money > 8'd50)
							money = money - 8'd5;
						else
							money = money + 8'd0;
						next_state = S0;
					end
					else if(money_10) begin
						money = money + 8'd10;
						if(money > 8'd50) begin
							money = money - 8'd10;
						end
						else
							money = money + 8'd0;
						next_state = S0;
					end
					else if(money_50) begin
						if(money != 8'd0)
							money = money + 8'd0;
						else
							money = 8'd50;
						next_state <= S0;
					end
					else if(tea) begin		
						if(money >= 8'd15) begin
							next_state = S1;
							money = money - 8'd15; 
						end
						else
							next_state = S0;
					end
					else if(coke) begin
						if(money >= 8'd20) begin
							next_state = S1;
							money = money - 8'd20;
						end
						else
							next_state = S0;
					end
					else if(sprite) begin
						if(money >= 8'd25) begin
							next_state = S1;
							money = money - 8'd25;
						end
						else
							next_state = S0;
					end
					else 
						next_state = S0;			
				end
			end
		
		S1:
			begin
				if(money == 8'd0)
					state <= S0;
				else	begin
					state <= S1;
					money = money - 8'd5;
				end
			end
	endcase
end

always@(money) begin
	if(money >= 25) begin
		drop_tea = 1'b0;
		drop_cole = 1'b0;
		drop_sprite = 1'b0;
	end
	else if(money >= 20) begin
		drop_tea = 1'b0;
		drop_cole = 1'b0;
	end
	else if(money >= 15) begin
		drop_tea = 1'b0;
	end
	else begin
		drop_tea = 1'b1;
		drop_cole = 1'b1;
		drop_sprite = 1'b1;
	end
end

endmodule
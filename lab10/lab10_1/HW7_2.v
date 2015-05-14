module HW7_2(
	clk, rst_n, cancel, 
	tea, coke, sprite, 
	money_5, money_10, money_50,
	drop_tea, drop_coke, drop_sprite,
	DIGIT, DISPLAY, money, state
);

input clk, rst_n, cancel;
input tea, coke, sprite;
input money_5, money_10, money_50;			 
output reg drop_tea = 1'b1;
output reg drop_coke = 1'b1;
output reg drop_sprite = 1'b1;
output reg [3:0] DIGIT = 8'd0; 
output reg [7:0] DISPLAY = 8'd0;
output reg [7:0] money = 8'd0;


reg buy_tea = 1'b0, buy_coke = 1'b0, buy_sprite = 1'b0;
output reg state = 4'd0; 
reg next_state;  
reg exist = 1'b0;

parameter		S0 = 1'b0, S1 = 1'b1;


always@(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		money = 8'd0;
		state = S0;
		drop_tea = 1'b1;
		drop_coke = 1'b1;
		drop_sprite = 1'b1;
	end
	else begin
		state = next_state;
		if(state == S1)
			exist = ~exist;
		else
			exist = exist;
	end
end

always@(state, money_5, money_10, money_50, tea, coke, sprite, cancel, exist) begin
	case(state)
		S0:
			begin
				if(cancel)
					next_state= S1;
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
						money = 8'd50;
						next_state <= S0;
					end
					else if(tea) begin		
						if(money >= 8'd15) begin
							next_state = S1;
							money = money - 8'd10; 
						end
						else
							next_state = S0;
					end
					else if(coke) begin
						if(money >= 8'd20) begin
							next_state = S1;
							money = money - 8'd15;
						end
						else
							next_state = S0;
					end
					else if(sprite) begin
						if(money >= 8'd25) begin
							next_state = S1;
							money = money - 8'd20;
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
		drop_coke = 1'b0;
		drop_sprite = 1'b0;
	end
	else if(money >= 20) begin
		drop_tea = 1'b0;
		drop_coke = 1'b0;
		drop_sprite = 1'b1;
	end
	else if(money >= 15) begin
		drop_tea = 1'b0;
		drop_coke = 1'b1;
		drop_sprite = 1'b1;
	end
	else begin
		drop_tea = 1'b1;
		drop_coke = 1'b1;
		drop_sprite = 1'b1;
	end
end

endmodule

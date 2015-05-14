module HW7_2(
	clk, rst_n, cancel, 
	tea, coke, sprite, 
	money_5, money_10, money_50,
	drop_tea, drop_coke, drop_sprite,
	ENABLE, SEGMENT
);

input clk, rst_n, cancel;
input tea, coke, sprite;
input money_5, money_10, money_50;			 
output reg drop_tea = 1'b0;
output reg drop_coke = 1'b0;
output reg drop_sprite = 1'b0;
output reg [3:0] ENABLE = 4'b1011; 
output reg [7:0] SEGMENT = 8'd0;

reg [7:0] money = 8'd0;
reg [3:0] DECODE_BCD;
reg [15:0] KEY_BUFFER;
reg [25:1] LCD_DIVIDER;
reg [14:1] DIVIDER;

reg buy_tea = 1'b0, buy_coke = 1'b0, buy_sprite = 1'b0;
reg state = 1'd0; 
reg next_state;  
reg exist = 1'b0;

wire CLK;

parameter		S0 = 1'b0, S1 = 1'b1;


always @(posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			LCD_DIVIDER <= 25'h00;
		else
			LCD_DIVIDER <= LCD_DIVIDER + 1;
	end
assign CLK = LCD_DIVIDER[25];  


always@(posedge CLK, negedge rst_n) begin
	if(!rst_n) begin
		state = S0;
	end
	else begin
		state = next_state;
		if(state == S1)
			exist = ~exist;
		else
			exist = exist;
	end
end

always@(state, money_5, money_10, money_50, tea, coke, sprite, cancel, rst_n) begin
	case(state)
		S0:
			begin
				if(!cancel)
					next_state= S1;
				else begin
					if(!money_5) begin
						next_state = S0;
					end
					else if(!money_10) begin
						next_state = S0;
					end
					else if(!money_50) begin
						next_state = S0;
					end
					else if(!tea) begin		
						if(money >= 8'd15) begin
							next_state = S1;
						end
						else
							next_state = S0;
					end
					else if(!coke) begin
						if(money >= 8'd20) begin
							next_state = S1;
						end
						else
							next_state = S0;
					end
					else if(!sprite) begin
						if(money >= 8'd25) begin
							next_state = S1;
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
					next_state = S0;
				else	begin
					next_state = S1;
				end
			end
	endcase
end



always@(state, money_5, money_10, money_50, tea, coke, sprite, cancel, exist, rst_n) begin
	case(state)
		S0:
			begin		
				if (!rst_n) begin
					money = 0;
				end	
				else begin
					if(!money_5) begin
						if(money + 8'd5 > 8'd50)
							money = money - 8'd5;
						else
							money = money + 8'd0;
					end
					else if(!money_10) begin
						
						if(money + 8'd10 > 8'd50) begin
							money = money - 8'd10;
						end
						else
							money = money + 8'd0;
					end
					else if(!money_50) begin
						money = 8'd50;
					end
					else if(!tea) begin		
						if(money >= 8'd15) begin
							money = money - 8'd10; 
						end
						else
							money = money + 8'd0;
					end
					else if(!coke) begin
						if(money >= 8'd20) begin
							money = money - 8'd15;
						end
						else
							money = money + 8'd0;
					end
					else if(!sprite) begin
						if(money >= 8'd25) begin
							money = money - 8'd20;
						end
						else
							money = money + 8'd0;
					end
					else 
						money = money + 8'd0;		
				end
			end
		
		S1:
			begin
				if(money == 8'd0)
					money = money + 8'd0;
				else	begin
					money = money - 8'd5;
				end
			end
	endcase
end





always@(money, rst_n) begin

	if(!rst_n) begin
		drop_tea = 1'b0;
		drop_coke = 1'b0;
		drop_sprite = 1'b0;
	end
	else begin
		if(money >= 25) begin
			drop_tea = 1'b1;
			drop_coke = 1'b1;
			drop_sprite = 1'b1;
		end
		else if(money >= 20) begin
			drop_tea = 1'b1;
			drop_coke = 1'b1;
			drop_sprite = 1'b0;
		end
		else if(money >= 15) begin
			drop_tea = 1'b1;
			drop_coke = 1'b0;
			drop_sprite = 1'b0;
		end
		else begin
			drop_tea = 1'b0;
			drop_coke = 1'b0;
			drop_sprite = 1'b0;
		end
	end
end

always@(money) begin
	if(money[0] == 1'b1)
		KEY_BUFFER[11:8] = 4'd5;
	else
		KEY_BUFFER[11:8] = 4'd0;
	
	if(money >= 50)
		KEY_BUFFER[15:12] = 4'd5;
	else if(money >= 40)
		KEY_BUFFER[15:12] = 4'd4;
	else if(money >= 30)
		KEY_BUFFER[15:12] = 4'd3;
	else if(money >= 20)
		KEY_BUFFER[15:12] = 4'd2;
	else if(money >= 10)
		KEY_BUFFER[15:12] = 4'd1;
	else
		KEY_BUFFER[15:12] = 4'd0;
end

always @(posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			DIVIDER <= {12'h000,2'b00};
			else
		DIVIDER <= DIVIDER + 1;
	end
assign SCAN_CLK = DIVIDER[14];

always @(negedge SCAN_CLK or negedge rst_n)
	begin
		if (!rst_n) begin
			ENABLE <= 4'b1011;	
		end
		else
			ENABLE <= {ENABLE[2], ENABLE[3],ENABLE[1],ENABLE[0]};
	end

/****************************
* Data Display Multiplexer *
****************************/
always @(ENABLE or KEY_BUFFER)
	begin
		case (ENABLE)
			4'b1011:DECODE_BCD = KEY_BUFFER[11:8];
			4'b0111:DECODE_BCD = KEY_BUFFER[15:12];
		endcase
	end

/********************************
* Hex To Seven Segment Decoder *
********************************/
always @(DECODE_BCD)
	begin
		case (DECODE_BCD)
			4'h0 : SEGMENT = 8'b00000011;// 0
			4'h1 : SEGMENT = 8'b10011111;//1
			4'h2 : SEGMENT = 8'b00100100;//2
			4'h3 : SEGMENT = 8'b00001100;//3
			4'h4 : SEGMENT = 8'b10011000;//4
			4'h5 : SEGMENT = 8'b01001000;//5
			4'h6 : SEGMENT = 8'b01000000;//6
			4'h7 : SEGMENT = 8'b00011111;//7
			4'h8 : SEGMENT = 8'b00000000;//8
			4'h9 : SEGMENT = 8'b00011000;//9
			4'hA : SEGMENT = 8'b00010000;//A
			4'hB : SEGMENT = 8'b11000000;//B
			4'hC : SEGMENT = 8'b01100011;//C
			4'hD : SEGMENT = 8'b10000100;//D
			4'hE : SEGMENT = 8'b01100000;//E
			4'hF : SEGMENT = 8'b01110000;//F
		endcase
	end



endmodule

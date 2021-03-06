module HW7_2(clk, rst_n, cancel_d, 
				 tea_d, coke_d, sprite_d, 
				 money5_d, money_10_d, money_50_d,
				 drop_tea, drop_coke, drop_sprite,
				 ENABLE, SEGMENT
);
/*
	input clk, rst_n, cancel;
	input tea, coke, sprite;
	input money5;
	input money_10;
	input money_50;
*/


input clk, rst_n;
input cancel_d;
input tea_d, coke_d, sprite_d;
input money5_d;
input money_10_d;
input money_50_d;

wire cancel_i;
wire tea_i, coke_i, sprite_i;
wire money5_i;
wire money_10_i;
wire money_50_i;

wire clk, rst_n, cancel;
wire tea, coke, sprite;
wire money5;
wire money_10;
wire money_50;

output reg drop_tea = 1'b0;
output reg drop_coke = 1'b0;
output reg drop_sprite = 1'b0;
output reg [3:0] ENABLE = 4'b0111; 
output reg [7:0] SEGMENT = 8'd0;


reg [7:0] money = 8'b00000000;
reg [7:0] next_money = 8'b00000000;
reg [3:0] DECODE_BCD;
reg [15:0] KEY_BUFFER;
reg [25:1] LCD_DIVIDER;
reg [14:1] DIVIDER;

reg buy_tea = 1'b0, buy_coke = 1'b0, buy_sprite = 1'b0;
reg state = 1'b0; 
reg next_state;  
reg exist = 1'b0;

wire CLK;
parameter		S0 = 1'b0, S1 = 1'b1;

/*
	wire cancel_i;
	wire tea_i, coke_i, sprite_i;
	wire money5_i;
	wire money_10_i;
	wire money_50_i;
*/

debounce DEBOUNCE1(cancel_i ,cancel_d, clk);
debounce DEBOUNCE2(tea_i, tea_d, clk);
debounce DEBOUNCE3(coke_i, coke_d, clk);
debounce DEBOUNCE4(sprite_i, sprite_d, clk);
debounce DEBOUNCE5(money5_i, money5_d, clk);
debounce DEBOUNCE6(money_10_i, money_10_d, clk);
debounce DEBOUNCE7(money_50_i, money_50_d, clk);

onepulse PULSE1(cancel_i, CLK, cancel);
onepulse PULSE2(tea_i, CLK, tea);
onepulse PULSE3(coke_i, CLK, coke);
onepulse PULSE4(sprite_i, CLK, sprite);
onepulse PULSE5(money5_i, CLK, money5);
onepulse PULSE6(money_10_i, CLK, money_10);
onepulse PULSE7(money_50_i, CLK, money_50);

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
	end
end

always@(posedge CLK, negedge rst_n) begin
	if(!rst_n) begin
		money = 8'd0;
	end
	else begin
		money = next_money;
	end
end


always@(state, money5, money_10, money_50, tea, coke, sprite, cancel, rst_n, money) begin
	case(state)
		S0:
			begin
				if(!cancel)
					next_state= S1;
				else begin
					if(!money5) begin
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



always@(state, money5, money_10, money_50, tea, coke, sprite, cancel, rst_n, money) begin
	case(state)
		S0:
			begin		
				if (!rst_n) begin
					next_money = 0;
				end	
				else begin
					if(!money5) begin
						if(money + 8'd5 > 8'd50)
							next_money = 8'd50;
						else
							next_money = money + 8'd5;
					end
					else if(!money_10) begin
						
						if(money + 8'd10 > 8'd50) begin
							next_money = 8'd50;
						end
						else
							next_money = money + 8'd10;
					end
					else if(!money_50) begin
						next_money = 8'd50;
					end
					else if(!tea) begin		
						if(money >= 8'd15) begin
							next_money = money - 8'd15; 
						end
						else
							next_money = money;
					end
					else if(!coke) begin
						if(money >= 8'd20) begin
							next_money = money - 8'd20;
						end
						else
							next_money = money;
					end
					else if(!sprite) begin
						if(money >= 8'd25) begin
							next_money = money - 8'd25;
						end
						else
							next_money = money;
					end
					else 
						next_money = money + 8'd0 ;	
				end
			end
		
		S1:
			begin
				if(money == 8'd0)
					next_money = money + 8'd0;
				else	begin
					next_money = money - 8'd5;
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


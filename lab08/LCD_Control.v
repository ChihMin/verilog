module LCD_Control(CLK, RESET, LCD_ENABLE, LCD_RW, LCD_DI, LCD_CS1, LCD_CS2, LCD_RST,LCD_DATA);
input CLK;
input RESET;
output LCD_ENABLE; 
output LCD_RW;
output LCD_DI;
output LCD_CS1; 
output LCD_CS2; 
output LCD_RST; 
output [7:0] LCD_DATA;
reg [5:0] START_LINE = 6'd0;
reg [7:0] NEXT_LINE = 8'd0;
reg [16:0] LCD_DATA;
reg [16:0] UPPER_PATTERN; 
reg [16:0] LOWER_PATTERN; 
reg [1:0] LCD_SEL;
reg [2:0] STATE; 
reg [2:0] X_PAGE; 
reg [7:1] DIVIDER; 
reg [22:1] LCD_DIVIDER; 
reg [1:0] DELAY; 
reg [16:0] INDEX; 
reg [1:0] ENABLE; 
reg CLEAR;
reg LCD_RW;
reg LCD_DI;
reg LCD_RST;
reg FLAG = 1'b0;
wire LCD_CLK; 
wire LCD_RESET;
wire LCD_CS1;
wire LCD_CS2;
wire LCD_ENABLE;


/*********************** * Clock Divider * ***********************/
always @(posedge CLK or negedge RESET)
	begin
		if (!RESET)
			DIVIDER <= 8'h00;
		else
			DIVIDER <= DIVIDER + 1;
	end
assign LCD_CLK = DIVIDER[7];

always @(posedge CLK or negedge RESET)
	begin
		if (!RESET)
			LCD_DIVIDER <= 22'h00;
		else
			LCD_DIVIDER <= LCD_DIVIDER + 1;
	end
assign LCD_RESET = LCD_DIVIDER[22];  

/*********************** * Display Patterns * ***********************/
always @(INDEX) begin
	case (INDEX)
		8'h88 : UPPER_PATTERN = 8'hF8; // H 
		8'h89 : UPPER_PATTERN = 8'hF8; 
		8'h8A : UPPER_PATTERN = 8'h88; 
		8'h8B : UPPER_PATTERN = 8'h80; 
		8'h8C : UPPER_PATTERN = 8'h80; 
		8'h8D : UPPER_PATTERN = 8'h88; 
		8'h8E : UPPER_PATTERN = 8'hF8; 
		8'h8F : UPPER_PATTERN = 8'hF8;

		8'h90 : UPPER_PATTERN = 8'h08; // E 
		8'h91 : UPPER_PATTERN = 8'h08; 
		8'h92 : UPPER_PATTERN = 8'hF8; 
		8'h93 : UPPER_PATTERN = 8'hF8; 
		8'h94 : UPPER_PATTERN = 8'h88; 
		8'h95 : UPPER_PATTERN = 8'hC8; 
		8'h96 : UPPER_PATTERN = 8'h18; 
		8'h97 : UPPER_PATTERN = 8'h38; 
		8'h98 : UPPER_PATTERN = 8'h08; // L 
		8'h99 : UPPER_PATTERN = 8'hF8; 
		8'h9A : UPPER_PATTERN = 8'hF8; 
		8'h9B : UPPER_PATTERN = 8'h08; 
		8'h9C : UPPER_PATTERN = 8'h00; 
		8'h9D : UPPER_PATTERN = 8'h00; 
		8'h9E : UPPER_PATTERN = 8'h00; 
		8'h9F : UPPER_PATTERN = 8'h00;

		8'hA0 : UPPER_PATTERN = 8'h08; // L 
		8'hA1 : UPPER_PATTERN = 8'hF8; 
		8'hA2 : UPPER_PATTERN = 8'hF8; 
		8'hA3 : UPPER_PATTERN = 8'h08; 
		8'hA4 : UPPER_PATTERN = 8'h00; 
		8'hA5 : UPPER_PATTERN = 8'h00; 
		8'hA6 : UPPER_PATTERN = 8'h00; 
		8'hA7 : UPPER_PATTERN = 8'h00; 
		8'hA8 : UPPER_PATTERN = 8'hE0; // O 
		8'hA9 : UPPER_PATTERN = 8'hF0; 
		8'hAA : UPPER_PATTERN = 8'h18; 
		8'hAB : UPPER_PATTERN = 8'h08; 
		8'hAC : UPPER_PATTERN = 8'h08; 
		8'hAD : UPPER_PATTERN = 8'h18; 
		8'hAE : UPPER_PATTERN = 8'hF0; 
		8'hAF : UPPER_PATTERN = 8'hE0;

		8'hB0 : UPPER_PATTERN = 8'h00; //SPACE 
		8'hB1 : UPPER_PATTERN = 8'h00;
		8'hB2 : UPPER_PATTERN = 8'h00;
		8'hB3 : UPPER_PATTERN = 8'h00;
		8'hB4 : UPPER_PATTERN = 8'h00; 
		8'hB5 : UPPER_PATTERN = 8'h00; 
		8'hB6 : UPPER_PATTERN = 8'h00; 
		8'hB7 : UPPER_PATTERN = 8'h00; 
		8'hB8 : UPPER_PATTERN = 8'h08; // L 
		8'hB9 : UPPER_PATTERN = 8'hF8; 
		8'hBA : UPPER_PATTERN = 8'hF8; 
		8'hBB : UPPER_PATTERN = 8'h08; 
		8'hBC : UPPER_PATTERN = 8'h00; 
		8'hBD : UPPER_PATTERN = 8'h00; 
		8'hBE : UPPER_PATTERN = 8'h00; 
		8'hBF : UPPER_PATTERN = 8'h00;
	
		8'hC0 : UPPER_PATTERN = 8'h00; // C 
		8'hC1 : UPPER_PATTERN = 8'hE0; 
		8'hC2 : UPPER_PATTERN = 8'hF0; 
		8'hC3 : UPPER_PATTERN = 8'h18; 
		8'hC4 : UPPER_PATTERN = 8'h08; 
		8'hC5 : UPPER_PATTERN = 8'h08; 
		8'hC6 : UPPER_PATTERN = 8'h18; 
		8'hC7 : UPPER_PATTERN = 8'h30; 
		8'hC8 : UPPER_PATTERN = 8'h08; // D 
		8'hC9 : UPPER_PATTERN = 8'hF8; 
		8'hCA : UPPER_PATTERN = 8'hF8; 
		8'hCB : UPPER_PATTERN = 8'h08; 
		8'hCC : UPPER_PATTERN = 8'h18; 
		8'hCD : UPPER_PATTERN = 8'hF0; 
		8'hCE : UPPER_PATTERN = 8'hE0; 
		8'hCF : UPPER_PATTERN = 8'h00;

		8'hD0 : UPPER_PATTERN = 8'h00; // !
		8'hD1 : UPPER_PATTERN = 8'h00;
		8'hD2 : UPPER_PATTERN = 8'h00;
		8'hD3 : UPPER_PATTERN = 8'hF8;
		8'hD4 : UPPER_PATTERN = 8'hF8;
		8'hD5 : UPPER_PATTERN = 8'h00;
		8'hD6 : UPPER_PATTERN = 8'h00;
		8'hD7 : UPPER_PATTERN = 8'h00;
		default :
			UPPER_PATTERN = 8'h00;
	endcase
end

always @(INDEX) begin
	case (INDEX)
		8'h88 : LOWER_PATTERN = 8'h0F; // H
		8'h89 : LOWER_PATTERN = 8'h0F; 
		8'h8A : LOWER_PATTERN = 8'h08; 
		8'h8B : LOWER_PATTERN = 8'h00; 
		8'h8C : LOWER_PATTERN = 8'h00; 
		8'h8D : LOWER_PATTERN = 8'h08; 
		8'h8E : LOWER_PATTERN = 8'h0F; 
		8'h8F : LOWER_PATTERN = 8'h0F;

		8'h90 : LOWER_PATTERN = 8'h08; // E 
		8'h91 : LOWER_PATTERN = 8'h08; 
		8'h92 : LOWER_PATTERN = 8'h0F; 
		8'h93 : LOWER_PATTERN = 8'h0F; 
		8'h94 : LOWER_PATTERN = 8'h08; 
		8'h95 : LOWER_PATTERN = 8'h09; 
		8'h96 : LOWER_PATTERN = 8'h0C; 
		8'h97 : LOWER_PATTERN = 8'h0E; 
		8'h98 : LOWER_PATTERN = 8'h08; // L 
		8'h99 : LOWER_PATTERN = 8'h0F; 
		8'h9A : LOWER_PATTERN = 8'h0F; 
		8'h9B : LOWER_PATTERN = 8'h08; 
		8'h9C : LOWER_PATTERN = 8'h08; 
		8'h9D : LOWER_PATTERN = 8'h08; 
		8'h9E : LOWER_PATTERN = 8'h08; 
		8'h9F : LOWER_PATTERN = 8'h0C;

		8'hA0 : LOWER_PATTERN = 8'h08; // L 
		8'hA1 : LOWER_PATTERN = 8'h0F; 
		8'hA2 : LOWER_PATTERN = 8'h0F; 
		8'hA3 : LOWER_PATTERN = 8'h08; 
		8'hA4 : LOWER_PATTERN = 8'h08; 
		8'hA5 : LOWER_PATTERN = 8'h08; 
		8'hA6 : LOWER_PATTERN = 8'h08; 
		8'hA7 : LOWER_PATTERN = 8'h0C; 
		8'hA8 : LOWER_PATTERN = 8'h03; // O 
		8'hA9 : LOWER_PATTERN = 8'h07; 
		8'hAA : LOWER_PATTERN = 8'h0C; 
		8'hAB : LOWER_PATTERN = 8'h08; 
		8'hAC : LOWER_PATTERN = 8'h08;
		8'hAD : LOWER_PATTERN = 8'h0C; 
		8'hAE : LOWER_PATTERN = 8'h07; 
		8'hAF : LOWER_PATTERN = 8'h03;

		8'hB0 : LOWER_PATTERN = 8'h00; // SPACE 
		8'hB1 : LOWER_PATTERN = 8'h00;
		8'hB2 : LOWER_PATTERN = 8'h00;
		8'hB3 : LOWER_PATTERN = 8'h00;
		8'hB4 : LOWER_PATTERN = 8'h00; 
		8'hB5 : LOWER_PATTERN = 8'h00; 
		8'hB6 : LOWER_PATTERN = 8'h00; 
		8'hB7 : LOWER_PATTERN = 8'h00; 
		8'hB8 : LOWER_PATTERN = 8'h08; // L 
		8'hB9 : LOWER_PATTERN = 8'h0F; 
		8'hBA : LOWER_PATTERN = 8'h0F; 
		8'hBB : LOWER_PATTERN = 8'h08; 
		8'hBC : LOWER_PATTERN = 8'h08; 
		8'hBD : LOWER_PATTERN = 8'h08; 
		8'hBE : LOWER_PATTERN = 8'h08; 
		8'hBF : LOWER_PATTERN = 8'h0C;

		8'hC0 : LOWER_PATTERN = 8'h00; // C 
		8'hC1 : LOWER_PATTERN = 8'h03; 
		8'hC2 : LOWER_PATTERN = 8'h07; 
		8'hC3 : LOWER_PATTERN = 8'h0C; 
		8'hC4 : LOWER_PATTERN = 8'h08; 
		8'hC5 : LOWER_PATTERN = 8'h08; 
		8'hC6 : LOWER_PATTERN = 8'h0C; 
		8'hC7 : LOWER_PATTERN = 8'h06; 
		8'hC8 : LOWER_PATTERN = 8'h08; // D 
		8'hC9 : LOWER_PATTERN = 8'h0F; 
		8'hCA : LOWER_PATTERN = 8'h0F; 
		8'hCB : LOWER_PATTERN = 8'h08; 
		8'hCC : LOWER_PATTERN = 8'h0C; 
		8'hCD : LOWER_PATTERN = 8'h07; 
		8'hCE : LOWER_PATTERN = 8'h03; 
		8'hCF : LOWER_PATTERN = 8'h00;

		8'hD0 : LOWER_PATTERN = 8'h00; // !
		8'hD1 : LOWER_PATTERN = 8'h00;
		8'hD2 : LOWER_PATTERN = 8'h00;
		8'hD3 : LOWER_PATTERN = 8'h00;
		8'hD4 : LOWER_PATTERN = 8'h0C;
		8'hD5 : LOWER_PATTERN = 8'h0C;
		8'hD6 : LOWER_PATTERN = 8'h00;
		8'hD7 : LOWER_PATTERN = 8'h00;
		default :
			LOWER_PATTERN = 8'h00;
	endcase	
end
/*
always @(negedge LCD_CLK or negedge RESET) begin
	if (!RESET) begin
		if( !FLAG ) begin
			NEXT_LINE = NEXT_LINE + 6'd1;
			FLAG = 1'b1;
		end
		else
			NEXT_LINE = NEXT_LINE;
	end
	else begin
			NEXT_LINE = NEXT_LINE;
			FLAG = 1'b0;
	end
end
	*/

always @(negedge LCD_RESET or negedge RESET) begin
	if(!RESET)
		NEXT_LINE = 8'd0;
	else
		NEXT_LINE = NEXT_LINE + 8'd1;
end

/****************************** * Initialize and Write LCD Data * ******************************/
always @(posedge LCD_CLK or negedge LCD_RESET) begin
	if (!LCD_RESET) begin
		CLEAR <= 1'b1; 
		STATE <= 3'b0; 
		DELAY <= 2'b00;
		X_PAGE <= 3'o0; 
		INDEX = NEXT_LINE;
		LCD_RST<= 1'b0; 
		ENABLE <= 2'b00;
		LCD_SEL<= 2'b11;
		LCD_DI <= 1'b0; 
		LCD_RW <= 1'b0;
	end
	else begin
		FLAG = 1'b0;
		if (ENABLE < 2'b10) begin
			ENABLE <= ENABLE + 1;
			DELAY[1]<= 1'b1;
		end
		else if (DELAY != 2'b00)
			DELAY <= DELAY - 1; 
		else if (STATE == 3'o0) begin
			STATE <= 3'o1;
			LCD_RST <= 1'b1; 
			LCD_DATA<= 8'h3F; 
			ENABLE <= 2'b00;
		end
		else if (STATE == 3'o1) begin
			STATE <= 3'o2;
			LCD_DATA<= {2'b11,6'd0}; 
			ENABLE <= 2'b00;
		end
		else if (STATE == 3'o2) begin
			STATE <= 3'o3; 
			LCD_DATA<= 8'h40; 
			ENABLE <= 2'b00;
		end
		else if (STATE == 3'o3) begin
			STATE <= 3'o4;
			LCD_DI <= 1'b0;
			INDEX = NEXT_LINE;
			LCD_DATA<= {5'b10111,X_PAGE}; ENABLE <= 2'b00;
		end
		else if (STATE == 3'o4) begin
			if (CLEAR) begin
				if (INDEX < NEXT_LINE + 64) begin
					INDEX = INDEX + 1; 
					LCD_DI <= 1'b1; 
					LCD_DATA<= 8'h00; 
					ENABLE <= 2'b00; 
				end
				else if (X_PAGE < 3'o7) begin
					STATE <= 3'o3;
					X_PAGE <= X_PAGE + 1; 
				end
				else begin
					STATE <= 3'o3; 
					X_PAGE <= 3'o3; 
					CLEAR <= 1'b0; 
				end
			end
			else if((X_PAGE == 3'o3) || (X_PAGE == 3'o4)) begin
				if(INDEX < 128 + NEXT_LINE) begin
					LCD_DI <= 1'b1;
					if(X_PAGE == 3'o3)
						LCD_DATA <= (UPPER_PATTERN);
					else
						LCD_DATA <= (LOWER_PATTERN);
					if(INDEX < 64 + NEXT_LINE)
						LCD_SEL <= 2'b01;
					else
						LCD_SEL <= 2'b10;
					INDEX = INDEX + 1;
					ENABLE <= 2'b00;
				end
				else begin
						LCD_SEL <= 2'b11;
						STATE <= 3'o3;
						X_PAGE <= X_PAGE + 1;
				end
			end
		end
	end
end

assign LCD_ENABLE = ENABLE[0];
assign LCD_CS1 = LCD_SEL[0];
assign LCD_CS2 = LCD_SEL[1];

endmodule

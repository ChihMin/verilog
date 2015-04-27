module KEYBOARD_EXAMPLE (CLK, RESET,COLUMN, ROW, ENABLE, SEGMENT, ADD, SUB);
input ADD, SUB;
input CLK;
input RESET;
input [3:0] COLUMN;
output [3:0] ROW;
output [3:0] ENABLE;
output [8:0] SEGMENT;

reg [3:0] ROW;
reg RESULT = 1'b0;
reg [3:0] DEBOUNCE_COUNT;
reg [3:0] DEBOUNCE_COUNT1;
reg [3:0] DEBOUNCE_COUNT2;
reg [3:0] SCAN_CODE;
reg [4:0] DECODE_BCD;
reg IS_BCD;
reg [3:0] KEY_CODE;
reg [3:0] ENABLE;
reg [8:0] SEGMENT;
reg [15:0] KEY_BUFFER;
reg [15:0] OUTPUT_TEMP = 16'h0000;
reg [14:1] DIVIDER;
reg [4:0] A, B;
reg [4:0] ANS_A = 0;
reg [4:0] ANS_B = 0;
reg [4:0] ANS;
reg FIRST = 1'b0;
reg PRESS;
wire PRESS_VALID;
wire ADD_VALID;
wire SUB_VALID;
wire DEBOUNCE_CLK;
wire SCAN_CLK;

/***********************
* Clock Divider*
***********************/
always @(posedge CLK or negedge RESET)
	begin
		if (!RESET)
			DIVIDER <= {12'h000,2'b00};
			else
		DIVIDER <= DIVIDER + 1;
	end
assign DEBOUNCE_CLK = DIVIDER[14];
assign SCAN_CLK = DIVIDER[14];

/***************************
* Scanning Code Generator *
***************************/

always @(posedge CLK or negedge RESET)
	begin
		if (!RESET)
			SCAN_CODE <= 4'h0;
		else if (PRESS)
			SCAN_CODE <= SCAN_CODE + 1;
	end

/*********************
* Scanning Keyboard *
*********************/
always @(SCAN_CODE,COLUMN)
	begin
		case (SCAN_CODE[3:2])
			2'b00 : ROW = 4'b1110;
			2'b01 : ROW = 4'b1101;
			2'b10 : ROW = 4'b1011;
			2'b11 : ROW = 4'b0111;
		endcase

		case (SCAN_CODE[1:0])
			2'b00 : PRESS = COLUMN[0];
			2'b01 : PRESS = COLUMN[1];
			2'b10 : PRESS = COLUMN[2];
			2'b11 : PRESS = COLUMN[3];
		endcase
	end

/********************
* Debounce Circuit *****************************************************************
********************/
always @(posedge DEBOUNCE_CLK or negedge RESET)
	begin
		if (!RESET)
			DEBOUNCE_COUNT <= 4'h0;
		else if (PRESS)
			DEBOUNCE_COUNT <= 4'h0;
		else if (DEBOUNCE_COUNT <= 4'hE)
			DEBOUNCE_COUNT <= DEBOUNCE_COUNT + 1;
	end
	
always @(posedge DEBOUNCE_CLK or negedge RESET)
	begin
		if (!RESET)
			DEBOUNCE_COUNT1 <= 4'h0;
		else if (ADD)
			DEBOUNCE_COUNT1 <= 4'h0;
		else if (DEBOUNCE_COUNT1 <= 4'hE)
			DEBOUNCE_COUNT1 <= DEBOUNCE_COUNT1 + 1;
	end
	
always @(posedge DEBOUNCE_CLK or negedge RESET)
	begin
		if (!RESET)
			DEBOUNCE_COUNT2 <= 4'h0;
		else if (SUB)
			DEBOUNCE_COUNT2 <= 4'h0;
		else if (DEBOUNCE_COUNT2 <= 4'hE)
			DEBOUNCE_COUNT2 <= DEBOUNCE_COUNT2 + 1;
	end

assign PRESS_VALID = (DEBOUNCE_COUNT == 4'hD) ?1'b1 : 1'b0;
assign ADD_VALID = (DEBOUNCE_COUNT1 == 4'hD) ? 1'b1 : 1'b0;
assign SUB_VALID = (DEBOUNCE_COUNT2 == 4'hD) ? 1'b1 : 1'b0;
/******************
* Fetch Key Code *********************************************************************
******************/
always @(negedge DEBOUNCE_CLK or negedge RESET)
	begin
		if (!RESET)
			KEY_CODE <= 4'hC;
		else if (PRESS_VALID)	
			KEY_CODE <= SCAN_CODE;
	end

/*******************************
* Convert Key Code Into ASCII *
*******************************/
always@(negedge PRESS_VALID, negedge RESET)
	begin
		if(!RESET) begin
			FIRST = 1'b0;
		end
		else begin
			FIRST = 1'b1 - FIRST;
		end
	end


always@( negedge RESET, negedge PRESS_VALID, negedge ADD, negedge SUB)
	begin
		if(!RESET) begin
			OUTPUT_TEMP = 16'd0;
			KEY_BUFFER = 16'd0;
			ANS_A = 5'd0;
			ANS_B = 5'd0;
		end
	
		else if(ADD == 0 || SUB == 0) begin
			A = (OUTPUT_TEMP & 16'hF000) >> 12;
			B = (OUTPUT_TEMP & 16'h0F00) >> 8;
			A = (A & 5'b01000) == 5'b01000 ? (A | 5'b10000) : A;
			B = (B & 5'b01000) == 5'b01000 ? (B | 5'b10000) : B;
			
			if(!ADD) ANS = A + B;
			else if(!SUB) ANS = A - B;
			else	ANS = ANS;
			
			case (ANS) 
				5'd0, 5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7, 5'd8, 5'd9 : begin
					ANS_A = 5'd0;
					ANS_B = ANS;
				end
				5'd10, 5'd11, 5'd12, 5'd13, 5'd14, 5'd15: begin
					ANS_A = 5'd1;
					ANS_B = ANS - 5'd10;
				end
				5'd16, 5'd17, 5'd18, 5'd19, 5'd20, 5'd21, 5'd22: begin
					ANS = ~ANS + 5'd1;
					ANS_A = 5'd1;
					ANS_B = ~(ANS - 5'd10)+5'd1;
				end
				5'd23, 5'd24, 5'd25, 5'd26, 5'd27, 5'd28, 5'd29, 5'd30, 5'd31: begin
					ANS = ~ANS + 5'd1;
					ANS_A = 5'd0;
					ANS_B = ~(ANS)+5'd1;
				end
				default: begin
					ANS_A = ANS_A;
					ANS_B = ANS_B;
				end
			endcase
		end
	
		else	begin
			case (KEY_CODE)
				4'hC : OUTPUT_TEMP = FIRST ? OUTPUT_TEMP | 16'h0000 : 16'h0000;
				4'hD : OUTPUT_TEMP = FIRST ? OUTPUT_TEMP | 16'h0100 : 16'h1000;
				4'h9 : OUTPUT_TEMP = FIRST ? OUTPUT_TEMP | 16'h0200 : 16'h2000;
				4'h5 : OUTPUT_TEMP = FIRST ? OUTPUT_TEMP | 16'h0300 : 16'h3000;// 3
				4'hE : OUTPUT_TEMP = FIRST ? OUTPUT_TEMP | 16'h0400 : 16'h4000;// 4
				4'hA : OUTPUT_TEMP = FIRST ? OUTPUT_TEMP | 16'h0500 : 16'h5000;// 5
				4'h6 : OUTPUT_TEMP = FIRST ? OUTPUT_TEMP | 16'h0600 : 16'h6000;// 6
				4'hF : OUTPUT_TEMP = FIRST ? OUTPUT_TEMP | 16'h0700 : 16'h7000;// 7
				4'hB : OUTPUT_TEMP = FIRST ? OUTPUT_TEMP | 16'h0800 : 16'h8000;// 8
				4'h7 : OUTPUT_TEMP = FIRST ? OUTPUT_TEMP | 16'h0900 : 16'h9000;// 9
				4'h8 : OUTPUT_TEMP = FIRST ? OUTPUT_TEMP | 16'h0A00 : 16'hA000;// A
				4'h4 : OUTPUT_TEMP = FIRST ? OUTPUT_TEMP | 16'h0B00 : 16'hB000;// B
				4'h3 : OUTPUT_TEMP = FIRST ? OUTPUT_TEMP | 16'h0C00 : 16'hC000;// C
				4'h2 : OUTPUT_TEMP = FIRST ? OUTPUT_TEMP | 16'h0D00 : 16'hD000;// D
				4'h1 : OUTPUT_TEMP = FIRST ? OUTPUT_TEMP | 16'h0E00 : 16'hE000;// E
				4'h0 : OUTPUT_TEMP = FIRST ? OUTPUT_TEMP | 16'h0F00 : 16'hF000;// F
			endcase
			KEY_BUFFER = OUTPUT_TEMP;
		end
	end


/***************************
* Enable Display Location *
***************************/
always @(negedge SCAN_CLK or negedge RESET)
	begin
		if (!RESET) begin
			ENABLE <= 4'b1110;	
		end
		else
			ENABLE <= {ENABLE[0],ENABLE[3],ENABLE[2],ENABLE[1]};
	end

/****************************
* Data Display Multiplexer *
****************************/
always @(ENABLE or KEY_BUFFER or ANS_A or ANS_B)
	begin
		case (ENABLE)
			4'b1110: begin
				DECODE_BCD = ANS_B;
				IS_BCD = 1'b0;
			end
			4'b1101: begin
				DECODE_BCD = ANS_A;
				IS_BCD = 1'b0;
			end
			4'b1011: begin
				DECODE_BCD = KEY_BUFFER[11:8];
				IS_BCD = 1'b1;
			end
			4'b0111: begin
				DECODE_BCD = KEY_BUFFER[15:12];
				IS_BCD = 1'b1;
			end
		endcase
	end

/********************************
* Hex To Seven Segment Decoder *
********************************/
always @(DECODE_BCD, IS_BCD)
	begin
		if(IS_BCD) begin
			case (DECODE_BCD)
				5'h0 : SEGMENT = 9'b100000011;// 0
				5'h1 : SEGMENT = 9'b110011111;//1
				5'h2 : SEGMENT = 9'b100100100;//2
				5'h3 : SEGMENT = 9'b100001100;//3
				5'h4 : SEGMENT = 9'b110011000;//4
				5'h5 : SEGMENT = 9'b101001000;//5
				5'h6 : SEGMENT = 9'b101000000;//6
				5'h7 : SEGMENT = 9'b100011111;//7
				5'h8 : SEGMENT = 9'b000000000;//-8
				5'h9 : SEGMENT = 9'b000011111;//-7
				5'hA : SEGMENT = 9'b001000000;//-6
				5'hB : SEGMENT = 9'b001001000;//-5
				5'hC : SEGMENT = 9'b010011000;//-4
				5'hD : SEGMENT = 9'b000001100;//-3
				5'hE : SEGMENT = 9'b000100100;//-2
				5'hF : SEGMENT = 9'b010011111;//-1
			endcase
		end
		else begin
			case (DECODE_BCD)
				5'h0 : SEGMENT = 9'b100000011;// 0
				5'h1 : SEGMENT = 9'b110011111;//1
				5'h2 : SEGMENT = 9'b100100100;//2
				5'h3 : SEGMENT = 9'b100001100;//3
				5'h4 : SEGMENT = 9'b110011000;//4
				5'h5 : SEGMENT = 9'b101001000;//5
				5'h6 : SEGMENT = 9'b101000000;//6
				5'h7 : SEGMENT = 9'b100011111;//7
				5'h8 : SEGMENT = 9'b100000000;//8
				5'h9 : SEGMENT = 9'b100011000;//9
				5'd23 : SEGMENT = 9'b000011000;//-9
				5'd24 : SEGMENT = 9'b000000000;//-8
				5'd25 : SEGMENT = 9'b000011111;//-7
				5'd26 : SEGMENT = 9'b001000000;//-6
				5'd27 : SEGMENT = 9'b001001000;//-5
				5'd28 : SEGMENT = 9'b010011000;//-4
				5'd29 : SEGMENT = 9'b000001100;//-3
				5'd30 : SEGMENT = 9'b000100100;//-2
				5'd31 : SEGMENT = 9'b010011111;//-1
		
			endcase
		end
	end
endmodule 

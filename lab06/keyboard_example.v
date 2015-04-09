module KEYBOARD_EXAMPLE (CLK, RESET,COLUMN, ROW, ENABLE, SEGMENT);
input CLK;
input RESET;
input [3:0] COLUMN;
output [3:0] ROW;
output [3:0] ENABLE;
output [7:0] SEGMENT;
reg [3:0] ROW;
reg [3:0] DEBOUNCE_COUNT;
reg [3:0] SCAN_CODE;
reg [3:0] DECODE_BCD;
reg [3:0] KEY_CODE;
reg [3:0] ENABLE;
reg [7:0] SEGMENT;
reg [11:0] KEY_BUFFER;
reg [14:1] DIVIDER;
reg PRESS;
wire PRESS_VALID;
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
* Debounce Circuit *
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

assign PRESS_VALID = (DEBOUNCE_COUNT == 4'hD) ?1'b1 : 1'b0;

/******************
* Fetch Key Code *
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
always @(KEY_CODE)
	begin
		case (KEY_CODE)
			4'hC : KEY_BUFFER = 12'h030; // 0
			4'hD : KEY_BUFFER = 12'h131; // 1
			4'h9 : KEY_BUFFER = 12'h232; // 2
			4'h5 : KEY_BUFFER = 12'h333; // 3
			4'hE : KEY_BUFFER = 12'h434; // 4
			4'hA : KEY_BUFFER = 12'h535; // 5
			4'h6 : KEY_BUFFER = 12'h636; // 6
			4'hF : KEY_BUFFER = 12'h737; // 7
			4'hB : KEY_BUFFER = 12'h838; // 8
			4'h7 : KEY_BUFFER = 12'h939; // 9
			4'h8 : KEY_BUFFER = 12'hA41; // A
			4'h4 : KEY_BUFFER = 12'hB42; // B
			4'h3 : KEY_BUFFER = 12'hC43; // C
			4'h2 : KEY_BUFFER = 12'hD44; // D
			4'h1 : KEY_BUFFER = 12'hE45; // E
			4'h0 : KEY_BUFFER = 12'hF46; // F
		endcase
	end

/***************************
* Enable Display Location *
***************************/
always @(negedge SCAN_CLK or negedge RESET)
	begin
		if (!RESET)
			ENABLE <= 4'b0111;
		else
			ENABLE <= {ENABLE[1],1'b1,ENABLE[0],ENABLE[3]};
	end

/****************************
* Data Display Multiplexer *
****************************/
always @(ENABLE or KEY_BUFFER)
	begin
		case (ENABLE)
			4'b1110:DECODE_BCD = KEY_BUFFER[3:0];
			4'b1101:DECODE_BCD = KEY_BUFFER[7:4];
			4'b0111:DECODE_BCD = KEY_BUFFER[11:8];
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

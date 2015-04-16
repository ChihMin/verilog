module LAB_06_t;

KEYBOARD_EXAMPLE keyboard(CLK, RESET,COLUMN, ROW, ENABLE, SEGMENT);
reg CLK;
reg RESET;
reg [3:0] COLUMN;
wire [3:0] ROW;
wire [3:0] ENABLE;
wire [7:0] SEGMENT;

endmodule

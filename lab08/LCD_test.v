module LCD_test;

reg CLK;
reg RESET;
wire LCD_ENABLE; 
wire LCD_RW;
wire LCD_DI;
wire LCD_CS1; 
wire LCD_CS2; 
wire LCD_RST; 
wire [7:0] LCD_DATA;

LCD_Control LCD(CLK, RESET, LCD_ENABLE, LCD_RW, LCD_DI, LCD_CS1, LCD_CS2, LCD_RST,LCD_DATA);

initial begin
end

endmodule

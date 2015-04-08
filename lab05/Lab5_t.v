module Lab5_t;
	reg clk, reset, en, speed, mode;
	wire	[7:0]	DISPLAY;
	wire	[3:0]	DIGIT;
	wire	max, min;

	Lab5 apple(DIGIT, DISPLAY, max, min, clk, reset, en, speed, mode);
	
	initial begin
		clk = 0;
		en = 1;
		speed = 1;
		mode = 1;
		reset = 0;
		#1 reset = 1;
	end

	initial begin
		#2000 $finish;
	end
	
	always	#10
		clk = ~clk;

endmodule

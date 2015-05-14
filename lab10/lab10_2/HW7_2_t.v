module HW7_2_t;
	reg	clk,
			rst_n,
			money_5,
			money_10,
			money_50,
			tea,
			coke,
			sprite,
			cancel;
	
	wire	drop_tea, 
			drop_coke, 
			drop_sprite;
		
	wire	[7:0] money;
	wire	[3:0] DIGIT; 
	wire	[7:0] DISPLAY;
	wire	state;
					
	HW7_2 homework(
			clk, rst_n, cancel, 
			tea, coke, sprite, 
			money_5, money_10, money_50,
			drop_tea, drop_coke, drop_sprite,
			DIGIT, DISPLAY, money, state
	);
	
	initial begin
		$monitor($time, " ---> tea %d, coke %d, sprite %d; money5 = %d, money_10 = %d, money_50 = %d, total = %d, state = %d",
						
						drop_tea, drop_coke, drop_sprite,
						money_5, money_10, money_50, money, state);
	end


	initial	begin
		clk = 0; rst_n = 0; money_5 = 0; money_10 = 0; 
		money_50 = 0;
		tea = 0; coke = 0; sprite = 0;
		cancel = 0;
		
		#5  rst_n = 1;
	end
	
	always #10
		clk = ~clk;
	
	initial fork
		#10 money_5 = 1;
		#20 money_5 = 0;
		#30 money_50 = 1;
		#40 money_50 = 0;
		#50 tea = 1;
		#60 tea = 0;
		#210 cancel = 1;

	join
	
	initial
		#300 $finish;
endmodule 

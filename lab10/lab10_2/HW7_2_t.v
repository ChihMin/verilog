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
		clk = 0; rst_n = 0; money_5 = 1; money_10 = 1; 
		money_50 = 1;
		tea = 1; coke = 1; sprite = 1;
		cancel = 1;
		
		#5  rst_n = 1;
	end
	
	always #10
		clk = ~clk;
	
	initial fork
		//Q1
		#10 money_5 = 0;
		#20 money_5 = 1;
		#30 money_10 = 0;
		#40 money_10 = 1;
		#50 tea = 0;
		#60 tea = 1;
		
		//Q2
		#90 money_5 = 0;
		#100 money_5 = 1;
		#110 money_5 = 0;
		#120 money_5 = 1;
		#130 money_10 = 0;
		#140 money_10 = 1;
		#150 coke = 0;
		#160 coke = 1;	

		//Q3
		#190 money_10 = 0;
		#200 money_10 = 1;
		#210 money_50 = 0;
		#220 money_50 = 1;
		#230 sprite = 0;
		#240 sprite = 1;
	join
	
	initial
		#1000 $finish;
endmodule 

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
					
	lab10 YAY(
			clk, rst_n, cancel, 
			tea, coke, sprite, 
			money_5, money_10, money_50,
			drop_tea, drop_coke, drop_sprite,
			DIGIT, DISPLAY, money
	);
	
	initial begin
		$monitor($time, " ---> ava_tea %d, ava_coke %d, ava_sprite %d; money5 = %d, money_10 = %d, money_50 = %d, total = %d",
						
						drop_tea, drop_coke, drop_sprite,
						money_5, money_10, money_50, money);
	end


	initial	begin
		clk = 0; rst_n = 0; coin5 = 0; coin10 = 0;
		tea = 0; coke = 0; sprite = 0;
		cancel = 0;
		
		#5  rst_n = 1;
	end
	
	always #10
		clk = ~clk;
	
	initial fork
		#10 money_5 = 1;	
		#110 money_5 = 0;
		#110 tea = 1;
		#112 tea = 0;

		#190 money_10 = 1;
		#230 money_10 = 0;
		#230 cancel = 1;	
	join
	
	initial
		#300 $finish;
endmodule 

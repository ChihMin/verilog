module HW7_2_t;
	reg		clk,
			rst_n,
			coin5,
			coin10,
			sel_water,
			sel_coke,
			sel_coffee,
			cancel;
	
	wire	available_water,
			available_coke,
			available_coffee,
			drop_water, 
			drop_coke, 
			drop_coffee,
			change5,
			change10;	

	HW7_2 vending(
			clk,
			rst_n,
			coin5,
			coin10,
			sel_water,
			sel_coke,
			sel_coffee,
			cancel,
			available_water,
			available_coke,
			available_coffee,
			drop_water, 
			drop_coke, 
			drop_coffee,
			change5,
			change10	
	);
	initial begin
		$monitor($time, " ---> ava_water %d, ava_coke %d, ava_coffee %d; d_w %d, d_cok %d, d_cof %d; c5 %d, c10 %d",
						available_water, available_coke, available_coffee,
						drop_water, drop_coke, drop_coffee, change5, change10);
	end


	initial	begin
		clk = 0; rst_n = 0; coin5 = 0; coin10 = 0;
		sel_water = 0; sel_coke = 0; sel_coffee = 0;
		cancel = 0;
		
		#5  rst_n = 1;
	end
	
	always #10
		clk = ~clk;
	
	initial fork
		#10 coin5 = 1;	
		#110 coin5 = 0;
		#110 sel_water = 1;
		#120 sel_water = 0;
	join
	
	initial
		#300 $finish;
endmodule 

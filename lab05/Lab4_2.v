module Lab5(DIGIT, DISPLAY, max, min, clk, reset, en, speed, mode);
	input clk, reset, en, speed, mode;
	output	[7:0]		DISPLAY;
	output	[3:0]		DIGIT;
	output reg max, min;
	
	wire tmp_max, tmp_min;	
	wire de_reset, de_en;
	wire div22, div24, div15;
	reg final_clk;
	reg dir = 1'b1;
	reg now_dir;
	wire [3:0] BCD0, BCD1;
	
	clock_divider24 DIV1(.clk(clk), .clk_div(div22));
	clock_divider22 DIV2(.clk(clk), .clk_div(div24));
	clock_divider15 DIV3(.clk(clk), .clk_div(div15));
	
	debounce DEB1(.pb_debounced(de_reset), .pb(reset), .clk(div15));
	debounce DEB2(.pb_debounced(de_en), .pb(en), .clk(div15));
	
	lab4_1 BCD_COUNTER(	.mode(mode), 
								.en(de_en), 
								.reset(de_reset),
								.clk(final_clk),
								.BCD0(BCD0), 
								.BCD1(BCD1), 
								.max(tmp_max),
								.min(tmp_min),
								.dir(dir)
	);
	
	Show disp(	.DIGIT(DIGIT), 
					.DISPLAY(DISPLAY), 
					.BCD0(BCD0), 
					.BCD1(BCD1), 
					.clk(div15)
	);
	
	
	always@(speed, div22, div24) begin
		if(speed == 1'b1)
			final_clk = div22;
		else
			final_clk = div24;
	end
	
	always@(BCD0, BCD1, mode, tmp_max, tmp_min, dir) begin
		min = tmp_min;
		max = tmp_max;
		
		if(mode == 1'b1)	begin
			if(BCD0 == 4'd9 && BCD1 == 4'd9 && dir == 1'b1) begin
				dir = 1'b0;
			end
			else if(BCD0 == 4'd0 && BCD1 == 4'd0 && dir == 1'b0) begin
				dir = 1'b1;
			end
			else if(dir == 1'b1)
				dir = 1'b1;
			else
				dir = 1'b0;
		end
		else	begin
			if(BCD0 == 4'd0 && BCD1 == 4'd6 && dir == 1'b1) begin
				dir = 1'b0;
			end
			else if(BCD0 == 4'd0 && BCD1 == 4'd0 && dir == 1'b0) begin
				dir = 1'b1;
			end
			else if( dir == 1'b1 )
				dir = 1'b1;
			else
				dir = 1'b0;
		end
	end
	
endmodule

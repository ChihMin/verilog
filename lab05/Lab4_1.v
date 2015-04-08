module lab4_1(cout, mode, en, reset, clk, BCD0, BCD1, max, min, dir);
	input clk;
	input reset;
	input en;
	input mode;
	input dir;
	output reg max, min;
	output cout;
	output 	reg [3:0]	BCD0;
	output 	reg [3:0]	BCD1;
	
	wire	cout0;
	reg	reg_en = 1'b1;
	reg	outputs0, outputs1;
	wire	[3:0]	A, B;
	
	Lab3_2 BCD_COUNTER_0(.cout(cout0), .BCD(A), .dir(dir), .en(reg_en), .reset(reset), .clk(clk));
	Lab3_2 BCD_COUNTER_1(.cout(cout), .BCD(B), .dir(dir), .en(cout0), .reset(reset), .clk(clk));	
	
	always@(negedge en) begin
		reg_en = !reg_en;
	end
	
	always@(A, B) begin
		BCD0 = A;
		BCD1 = B;
	end
/*
	always@(A, B, mode) begin
		if(mode == 1'b1)	begin
			if(A == 4'd8 && B == 4'd9 && dir == 1'b1) begin
				dir <= 1'b0;
				max = 1'b1;
			end
			else if(A == 4'd1 && B == 4'd0 && dir == 1'b0) begin
				dir <= 1'b1;
				min = 1'b1;
			end
			else begin
				max = 1'b0;
				min = 1'b0;
			end
		end
		else	begin
			if(A == 4'd9 && B == 4'd5 && dir == 1'b1) begin
				dir <= 1'b0;
				max = 1'b1;
			end
			else if(A == 4'd1 && B == 4'd0 && dir == 1'b0) begin
				dir <= 1'b1;
				min = 1'b1;
			end
			else begin
				max = 1'b0;
				min = 1'b0;
			end
		end
	end
*/
	always@(A, B, mode) begin
		if( mode == 1'b0 ) begin
			if(A == 4'd9 && B == 4'd5) begin
				max = 1'b1;
			end
			else if(A == 4'd1 && B == 4'd0) begin
				min = 1'b1;
			end
			else begin
				max = 1'b0;
				min = 1'b0;
			end
		end
		
		else begin
			if(A == 4'd8 && B == 4'd9) begin
				max = 1'b1;
			end
			else if(A == 4'd1 && B == 4'd0) begin
				min = 1'b1;
			end
			else begin
				max = 1'b0;
				min = 1'b0;
			end
		end
	end
	
endmodule

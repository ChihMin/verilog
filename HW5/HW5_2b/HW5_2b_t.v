module HW5_2a_t;
	wire	[1:0]	out0, out1, out2, out3;
	reg		[7:0]	D;
	reg		[1:0]	in0, in1, in2, in3;

	HW5_2b sorter(
		.out0( out0 ),
		.out1( out1 ),
		.out2( out2 ),
		.out3( out3 ),
		.in0( D[7:6] ),
		.in1( D[5:4] ),
		.in2( D[3:2] ),
		.in3( D[1:0] )
	);

	initial begin
		$monitor($time, "--> (%d %d %d %d) -> ( %d %d %d %d)", 
				D[7:6], D[5:4], D[3:2], D[1:0], out0, out1, out2, out3);
	end
	
	initial begin
		D = 8'd0;

		repeat (255) begin
			#10
			D = D + 1;
		end
		#20
		$finish; 
	end

endmodule

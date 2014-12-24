module HW5_2a_t;
	reg		[3:0]	D;
	wire	[1:0]	x, y;
	
	HW5_2a sorter(
		.a( D[3:2] ),
		.b( D[1:0] ),
		.x( x ),
		.y( y )
	);

	initial begin
		$monitor($time, " --> Max( %d , %d ) is %d, other is %d", D[3:2], D[1:0], x, y);
	end

	initial begin
		D = 4'd0;

		repeat (15) begin
			#10
			D = D + 1;
		end
		#20
		$finish; 
	end
endmodule

module adder_t;
	reg	signed	[5:0]	D;
	wire signed	[2:0]	S;
	wire	V;
	
	HW5_1 adder
	(
		.A( D[5:3] ),
		.B( D[2:0] ),
		.S( S ),
		.V( V )
	);

	
	
	initial begin
		$monitor($time, "--> A = %b, B = %b, S = %d, Overflow = %b", D[5:3], D[2:0], S, V);
	end

	initial begin
		D = 6'd0;
		
		repeat (63) begin
			#10;
			D = D + 1;
		end

		#10
		$finish;
	end

endmodule

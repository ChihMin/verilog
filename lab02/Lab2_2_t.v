module Lab2_2_t;

	reg		[3:0]	A, B;
	wire	A_lt_B, A_gt_B, A_eq_B;
	parameter cyc = 10;
	reg		[4:0]	i, j, k;

Lab2_2 U1(
	.A3(A[3]), .A2(A[2]), .A1(A[1]), .A0(A[0]),
	.B3(B[3]), .B2(B[2]), .B1(B[1]), .B0(B[0]), 
	.A_lt_B(A_lt_B), .A_gt_B(A_gt_B), .A_eq_B(A_eq_B)
);

	initial begin
		for(i = 0; i < 16; i = i + 1) begin
			for(j = 0; j < 16; j = j + 1) begin
				#(cyc)
				for(k = 0; k < 4; k = k + 1) begin
					A[k] = i[k];
					B[k] = j[k];
				end
			end
		end
		#10 $finish;
	end
	
	initial begin
		$monitor($time, "--> A = %d, B = %d , A_lt_B = %d, A_gt_B = %d, A_eq_B = %d", A, B, A_lt_B, A_gt_B, A_eq_B ); 
	end
endmodule

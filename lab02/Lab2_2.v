module Lab2_2(A_lt_B, A_gt_B, A_eq_B, A3, A2, A1, A0, B3, B2, B1, B0);
	input	A3, A2, A1, A0, B3, B2, B1, B0;
	output	A_lt_B, A_gt_B, A_eq_B;
	
	wire	tmplt1, tmpgt1, tmpeq1;

Lab2_1 C1( .A_lt_B(tmplt1), .A_gt_B(tmpgt1), .A_eq_B(tmpeq1), .A1(A3), .A0(A2), .B1(B3), .B0(B2));
Lab2_1 C2( .A_lt_B(tmplt2), .A_gt_B(tmpgt2), .A_eq_B(tmpeq2), .A1(A1), .A0(A0), .B1(B1), .B0(B0));
	
	assign A_lt_B = ( tmplt1 | ( tmpeq1 & tmplt2 ) ); 
	assign A_gt_B = ( tmpgt1 | ( tmpeq1 & tmpgt2 ) );
	assign A_eq_B = ( tmpeq1 & tmpeq2 );

endmodule

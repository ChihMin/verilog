module HW5_2a(x, y, a, b);
	output	[1:0]	x, y;
	input	[1:0]	a, b;

	reg		[1:0]	x, y;
	

always@*
	if( a > b )	begin
		x = a;
		y = b;
	end
	else begin
		x = b;
		y = a;
	end
	
endmodule

module HW5_2b(out0, out1, out2, out3, in0, in1, in2, in3);
	output	[1:0]	out0, out1, out2, out3;
	input	[1:0]	in0, in1, in2, in3;
	wire	[1:0]	x1, x2, x3, x4;
	wire	[1:0]	y1, y2, y3, y4;
	wire	[1:0]	z1, z2, z3, z4; 

	HW5_2a	sorter1(y1, x2, in0, in1);
	HW5_2a	sorter2(x3, y4, in2, in3);

	HW5_2a	sorter3(y2, y3, x2, x3);
	
	HW5_2a	sorter4(z1, z2, y1, y2);
	HW5_2a	sorter5(z3, z4, y3, y4);
	
	assign	out0 = z1;
	assign	out3 = z4;

	HW5_2a	sorter6(out1, out2, z2, z3); 
endmodule

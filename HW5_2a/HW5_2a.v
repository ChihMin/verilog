module HW5_2a(x, y, a, b);
	output	[1:0]	x, y;
	input	[1:0]	a, b;

	reg		[1:0]	x, y;
	

always@*
	if( a > b )	begin
		x = a;
		y = b;
	end
	else if( a < b ) begin
		x = b;
		y = a;
	end
	else begin
		x = a;
		y = b;
	end
endmodule

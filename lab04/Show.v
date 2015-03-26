module Show(DISPLAY, DIGIT, BCD1, BCD0, clk);
output [7:0] DISPLAY;
output reg [3:0]	DIGIT;
input [3:0] BCD1, BCD0;
input clk;
reg	[3:0]	value;

always@(posedge clk) begin
	case(DIGIT)
		4'b1110: begin
			value <= BCD1;
			DIGIT <= 4'b1101;
		end
		4'b1101: begin 
			value <= BCD0;
			DIGIT <= 4'b1110;
		end
		default begin
			DIGIT <= 4'b1110;
		end
	endcase
end


assign DISPLAY = (value == 0) ? 8'b00000011 :
						(value == 1) ? 8'b10011111 :
						(value == 2) ? 8'b00100100 :
						(value == 3) ? 8'b00001100 :
						(value == 4) ? 8'b10011000 :
						(value == 5) ? 8'b01001000 :
						(value == 6) ? 8'b01000000 :
						(value == 7) ? 8'b00011111 :
						(value == 8) ? 8'b00000000 :
						(value == 9) ? 8'b00001000 :
											8'b11111111 ;
endmodule

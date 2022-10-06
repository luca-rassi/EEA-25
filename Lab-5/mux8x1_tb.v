`timescale 10ns/10ps
`include "mux8x1.v"

module mux8x1_tb;

	reg[3:0] i0, i1, i2, i3, i4, i5, i6, i7;
	reg[2:0] s;
	wire [3:0] y;

	mux8x1 uut(i0, i1, i2, i3, i4, i5, i6, i7, s, y);

	initial begin
		$dumpfile ("mux8x1_tb.vcd");
		$dumpvars (0, mux8x1_tb);
	end

	initial begin
		i0 = 1; i1 = 2; i2 = 3; i3 = 4; i4 = 5; i5 = 6; i6 =7; i7 = 8; s = 0; #1
		i0 = 1; i1 = 2; i2 = 3; i3 = 4; i4 = 5; i5 = 6; i6 =7; i7 = 8; s = 1; #1
		i0 = 1; i1 = 2; i2 = 3; i3 = 4; i4 = 5; i5 = 6; i6 =7; i7 = 8; s = 2; #1
		i0 = 1; i1 = 2; i2 = 3; i3 = 4; i4 = 5; i5 = 6; i6 =7; i7 = 8; s = 3; #1
		i0 = 1; i1 = 2; i2 = 3; i3 = 4; i4 = 5; i5 = 6; i6 =7; i7 = 8; s = 4; #1
		i0 = 1; i1 = 2; i2 = 3; i3 = 4; i4 = 5; i5 = 6; i6 =7; i7 = 8; s = 5; #1
		i0 = 1; i1 = 2; i2 = 3; i3 = 4; i4 = 5; i5 = 6; i6 =7; i7 = 8; s = 6; #1
		i0 = 1; i1 = 2; i2 = 3; i3 = 4; i4 = 5; i5 = 6; i6 =7; i7 = 8; s = 7; #1
		$finish;
	end

endmodule

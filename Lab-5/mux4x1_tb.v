`timescale 10ns/10ps
`include "mux4x1.v"

module mux4x1_tb;

	reg [3:0] i0, i1, i2, i3;
	reg [1:0] s;
	wire [3:0] y;

	mux4x1 uut(i0, i1, i2, i3, s, y);

	initial begin
		$dumpfile ("mux4x1_tb.vcd");
		$dumpvars (0, mux4x1_tb);
	end

	initial begin
		i0 = 1; i1 = 2; i2 = 3; i3 = 4; s = 0; #1
		i0 = 1; i1 = 2; i2 = 3; i3 = 4; s = 1; #1
		i0 = 1; i1 = 2; i2 = 3; i3 = 4; s = 2; #1
		i0 = 1; i1 = 2; i2 = 3; i3 = 4; s = 3; #1
		i0 = 5; i1 = 6; i2 = 7; i3 = 8; s = 0; #1
		i0 = 9; i1 = 10; i2 = 11; i3 = 12; s = 1; #1
		i0 = 4; i1 = 3; i2 = 2; i3 = 1; s = 2; #1
		i0 = 15; i1 = 15; i2 = 15; i3 = 1; s = 3; #1
		$finish;
	end

endmodule

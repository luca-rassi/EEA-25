`timescale 10ns/1ps
`include "top_level.v"

module top_level_tb;

	reg D1, rst;
	wire [6:0] out;

	top_level uut(D1,rst,out);

	initial
		D1 = 1'b0;

	always
		#1 D1 = ~D1;

	initial begin
		$monitor($time, "D1 = %b, rst = %b, out = %b", D1, rst, out);

		rst = 0;
		#1 rst = 1;
		#31 $finish;
	end

	initial begin
		$dumpfile("top_level_tb.vcd");
		$dumpvars(0, top_level_tb);
	end

endmodule

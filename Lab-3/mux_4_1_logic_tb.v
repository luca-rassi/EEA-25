`include "mux_4_1_logic.v"
`timescale 1ns/1ps // time unit / simulation precision

module mux_4_1_logic_tb;

	reg [3:0] IN;
	reg [1:0] S;
	reg EN;
	wire Y;

	mux_4_1_logic uut (IN, S, EN, Y);

	initial begin
		$dumpfile("mux_4_1_logic_tb.vcd");
		$dumpvars(0, mux_4_1_logic_tb);
	end

	initial begin
		EN = 1; IN = 3; S = 0; #1
		EN = 1; IN = 3; S = 1; #1
		EN = 1; IN = 3; S = 2; #1
		EN = 1; IN = 3; S = 3; #1
		EN = 1; IN = 4; S = 0; #1
		EN = 1; IN = 7; S = 1; #1
		EN = 1; IN = 2; S = 2; #1
		EN = 1; IN = 8; S = 3; #1
		
		$finish;
	end

endmodule

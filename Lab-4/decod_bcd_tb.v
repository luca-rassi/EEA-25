`timescale 10ns/10ps
`include "decod_bcd.v"

module decod_bcd_tb;

	reg [3:0] in;
	wire [6:0] out;

	decod_bcd uut(in, out);

	initial begin
		$dumpfile("decod_bcd_tb.vcd");
		$dumpvars(0, decod_bcd_tb);
	end

	initial begin
		for(integer i=0; i<10; i = i + 1) begin
			in = i; #1;
		end
	end

endmodule

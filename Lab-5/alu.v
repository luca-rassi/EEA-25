`include "mux8x1.v"

module alu (
	input [3:0] src_a,
	input [3:0] src_b,
	input [2:0] operation,
	output [3:0] alu_result,
	output zero_flag
);
	wire[3:0] w0, w1, w2, w3, w4, w5, w6, w7;
	assign w0 = src_a & src_b;
	assign w1 = src_a | src_b;
	assign w2 = src_a + src_b;
	assign w3 = src_a << src_b;
	assign w4 = src_a - src_b;
	assign w5 = src_a >> src_b;
	assign w6 = src_a < src_b? 'd1:'d0;
	assign w7 = src_a ^ src_b;
	
	mux8x1 mux(w0, w1, w2, w3, w4, w5, w6, w7, operation, alu_result);
	
	assign zero_flag = alu_result == 'd0? 1'b1:1'b0;	
endmodule

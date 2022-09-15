`include "frequency_divider.v"
`include "decod_bcd.v"

module top_level (
	input D1,
	input rst,
	output [6:0] out
);
	wire [3:0] aux;
	frequency_divider fd(D1, rst, aux);
	decod_bcd dec(aux, out);

endmodule

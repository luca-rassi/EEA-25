module mux_4_1_logic (

	// Inputs
	input [3:0] IN,
	input [1:0] S,
	input EN,
	
	// Outputs
	output Y
);
	wire x0, x1, x2, x3;

	assign x3 = (EN)&(S[0])&(S[1])&(IN[3]);
	assign x2 = (EN)&(~S[0])&(S[1])&(IN[2]);
	assign x1 = (EN)&(S[0])&(~S[1])&(IN[1]);
	assign x0 = (EN)&(~S[0])&(~S[1])&(IN[0]);

	assign Y = x3 | x2 | x1 | x0;

endmodule

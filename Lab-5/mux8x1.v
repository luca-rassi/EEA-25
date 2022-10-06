module mux8x1 (
	// Inputs 
	input [3:0] i0, i1, i2, i3, i4, i5, i6, i7,
	input [2:0] s,
	// Outputs
	output [3:0] y
);
	assign y[3] = i0[3] & ~s[0] & ~s[1] & ~s[2]	|
		      i1[3] &  s[0] & ~s[1] & ~s[2]	|
		      i2[3] & ~s[0] &  s[1] & ~s[2] 	|
		      i3[3] &  s[0] &  s[1] & ~s[2]	|
		      i4[3] & ~s[0] & ~s[1] &  s[2] 	|
		      i5[3] &  s[0] & ~s[1] &  s[2] 	|
		      i6[3] & ~s[0] &  s[1] &  s[2]  	|
		      i7[3] &  s[0] &  s[1] &  s[2];

	assign y[2] = i0[2] & ~s[0] & ~s[1] & ~s[2]	|
		      i1[2] &  s[0] & ~s[1] & ~s[2]	|
		      i2[2] & ~s[0] &  s[1] & ~s[2] 	|
		      i3[2] &  s[0] &  s[1] & ~s[2]	|
		      i4[2] & ~s[0] & ~s[1] &  s[2] 	|
		      i5[2] &  s[0] & ~s[1] &  s[2] 	|
		      i6[2] & ~s[0] &  s[1] &  s[2]  	|
		      i7[2] &  s[0] &  s[1] &  s[2];

	assign y[1] = i0[1] & ~s[0] & ~s[1] & ~s[2]	|
		      i1[1] &  s[0] & ~s[1] & ~s[2]	|
		      i2[1] & ~s[0] &  s[1] & ~s[2] 	|
		      i3[1] &  s[0] &  s[1] & ~s[2]	|
		      i4[1] & ~s[0] & ~s[1] &  s[2] 	|
		      i5[1] &  s[0] & ~s[1] &  s[2] 	|
		      i6[1] & ~s[0] &  s[1] &  s[2]  	|
		      i7[1] &  s[0] &  s[1] &  s[2];

	assign y[0] = i0[0] & ~s[0] & ~s[1] & ~s[2]	|
		      i1[0] &  s[0] & ~s[1] & ~s[2]	|
		      i2[0] & ~s[0] &  s[1] & ~s[2] 	|
		      i3[0] &  s[0] &  s[1] & ~s[2]	|
		      i4[0] & ~s[0] & ~s[1] &  s[2] 	|
		      i5[0] &  s[0] & ~s[1] &  s[2] 	|
		      i6[0] & ~s[0] &  s[1] &  s[2]  	|
		      i7[0] &  s[0] &  s[1] &  s[2];


endmodule

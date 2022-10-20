module reg_file (
	input [4:0] rg_A1,
	input [4:0] rg_A2,
	input [4:0] rg_A3,
	input [31:0] rg_WD3,
	output [31:0]  rg_RD1,
	output [31:0] rg_RD2,
	input rg_WE3,
	input clock,
	input reset
);

 reg [31:0] reg_memory [31:0];
    integer i=0;

    always @(posedge reset)
    begin
        reg_memory[0] = 32'h0;
        reg_memory[1] = 32'h1;
        reg_memory[2] = 32'h2;
        reg_memory[3] = 32'h3;
        reg_memory[4] = 32'h4;
        reg_memory[5] = 32'h5;
        reg_memory[6] = 32'h6;
        reg_memory[7] = 32'h7;
        reg_memory[8] = 32'h8;
        reg_memory[9] = 32'h9;
        reg_memory[10] = 32'h0A;
        reg_memory[11] = 32'h0B;
        reg_memory[12] = 32'h0C;
        reg_memory[13] = 32'h0D;
        reg_memory[14] = 32'h0E;
        reg_memory[15] = 32'h0F;
        reg_memory[16] = 32'h10;
        reg_memory[17] = 32'h11;
        reg_memory[18] = 32'h12;
        reg_memory[19] = 32'h13;
        reg_memory[20] = 32'h14;
	reg_memory[21] = 32'h15;
	reg_memory[22] = 32'h16;
	reg_memory[23] = 32'h17;
	reg_memory[24] = 32'h18;
	reg_memory[25] = 32'h19;
	reg_memory[26] = 32'h1A;
	reg_memory[27] = 32'h1B;
	reg_memory[28] = 32'h1C;
	reg_memory[29] = 32'h1D;
	reg_memory[30] = 32'h1E;
	reg_memory[31] = 32'h1F;
    end

    assign rg_RD1 = reg_memory[rg_A1];
    assign rg_RD2 = reg_memory[rg_A2];

    always @(posedge clock)
    begin
        if (rg_WE3) begin
            reg_memory[rg_A3] = rg_WD3;
        end     
    end

endmodule

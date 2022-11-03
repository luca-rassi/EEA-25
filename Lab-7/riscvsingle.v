// Single-cycle processor

// Testbench
module testbench;
	reg clk;
	reg reset;
	wire [31:0] WriteData;
	wire [31:0] DataAdr;
	wire MemWrite;
	top dut(
		.clk(clk),
		.reset(reset),
		.WriteData(WriteData),
		.DataAdr(DataAdr),
		.MemWrite(MemWrite)
	);
	// Reset
	initial begin
		reset <= 1; #(5); reset <= 0;
	end
	// Clock signal
	always begin
		clk <= 1; #(10); clk <= 0; #(10);
	end
	// Check outcome
	always @(negedge clk)
		if (MemWrite)
			if ((DataAdr === 100) & (WriteData === 25)) begin
				$display("Simulation succeeded");
				$stop;
			end
			else if (DataAdr !== 96) begin
				$display("Simulation failed");
				$stop;
			end

	initial begin
		$dumpfile("testbench.vcd");
		$dumpvars(0, testbench);
	end

	initial begin
		#1000;
		$finish;
	end
endmodule

// Top-level module
module top (
	clk,
	reset,
	WriteData,
	DataAdr,
	MemWrite
);
	input wire clk;
	input wire reset;
	output wire [31:0] WriteData;
	output wire [31:0] DataAdr;
	output wire MemWrite;
	wire [31:0] PC;
	wire [31:0] Instr;
	wire [31:0] ReadData;
	// Single-cycle processor
	riscvsingle rvsingle(
		.clk(clk),
		.reset(reset),
		.PC(PC),
		.Instr(Instr),
		.MemWrite(MemWrite),
		.ALUResult(DataAdr),
		.WriteData(WriteData),
		.ReadData(ReadData)
	);
	// Instruction memory
	imem imem(
		.a(PC),
		.rd(Instr)
	);
	// Data memory
	dmem dmem(
		.clk(clk),
		.we(MemWrite),
		.a(DataAdr),
		.wd(WriteData),
		.rd(ReadData)
	);
endmodule

// Single-cycle  (controller + datapath)
module riscvsingle (
	clk,
	reset,
	PC,
	Instr,
	MemWrite,
	ALUResult,
	WriteData,
	ReadData
);
	input wire clk;
	input wire reset;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire MemWrite;
	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire ALUSrc;
	wire RegWrite;
	wire Jump;
	wire Zero;
	wire [1:0] ResultSrc;
	wire [1:0] ImmSrc;
	wire [2:0] ALUControl;
	wire PCSrc;
	controller c(
		.op(Instr[6:0]),
		.funct3(Instr[14:12]),
		.funct7b5(Instr[30]),
		.Zero(Zero),
		.ResultSrc(ResultSrc),
		.MemWrite(MemWrite),
		.PCSrc(PCSrc),
		.ALUSrc(ALUSrc),
		.RegWrite(RegWrite),
		.Jump(Jump),
		.ImmSrc(ImmSrc),
		.ALUControl(ALUControl)
	);
	datapath dp(
		.clk(clk),
		.reset(reset),
		.ResultSrc(ResultSrc),
		.PCSrc(PCSrc),
		.ALUSrc(ALUSrc),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUControl(ALUControl),
		.Zero(Zero),
		.PC(PC),
		.Instr(Instr),
		.ALUResult(ALUResult),
		.WriteData(WriteData),
		.ReadData(ReadData)
	);
endmodule

// Controller (main + ALU decoders)
module controller (
	op,
	funct3,
	funct7b5,
	Zero,
	ResultSrc,
	MemWrite,
	PCSrc,
	ALUSrc,
	RegWrite,
	Jump,
	ImmSrc,
	ALUControl
);
	input wire [6:0] op;
	input wire [2:0] funct3;
	input wire funct7b5;
	input wire Zero;
	output wire [1:0] ResultSrc;
	output wire MemWrite;
	output wire PCSrc;
	output wire ALUSrc;
	output wire RegWrite;
	output wire Jump;
	output wire [1:0] ImmSrc;
	output wire [2:0] ALUControl;
	wire [1:0] ALUOp;
	wire Branch;
	maindec md(
		.op(op),
		.ResultSrc(ResultSrc),
		.MemWrite(MemWrite),
		.Branch(Branch),
		.ALUSrc(ALUSrc),
		.RegWrite(RegWrite),
		.Jump(Jump),
		.ImmSrc(ImmSrc),
		.ALUOp(ALUOp)
	);
	aludec ad(
		.opb5(op[5]),
		.funct3(funct3),
		.funct7b5(funct7b5),
		.ALUOp(ALUOp),
		.ALUControl(ALUControl)
	);
	assign PCSrc = (Branch & Zero) | Jump;
endmodule

// Controller - main decoder
module maindec (
	op,
	ResultSrc,
	MemWrite,
	Branch,
	ALUSrc,
	RegWrite,
	Jump,
	ImmSrc,
	ALUOp
);

	input wire [6:0] op;
	output wire [1:0] ResultSrc;
	output wire MemWrite;
	output wire Branch;
	output wire ALUSrc;
	output wire RegWrite;
	output wire Jump;
	output wire [1:0] ImmSrc;
	output wire [1:0] ALUOp;
	reg [10:0] controls;
	
	assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump} = controls;
	
	always @(*)
		case(op)
			7'b0000011: controls <= 11'b10010010000;	//Rtyp
			7'b0100011: controls <= 11'b00111000000;	//LW
			7'b0110011: controls <= 11'b1xx00000100;	//SW
			7'b1100011: controls <= 11'b01000001010;	//BEQ
			7'b0010011: controls <= 11'b10010000100;	//ADDI
			7'b1101111: controls <= 11'b11100100001;	//J
			default:   controls <= 11'bxxxxxxxxxxx;	//?
		endcase
endmodule 

// Controller - ALU decoder
module aludec (
	opb5,
	funct3,
	funct7b5,
	ALUOp,
	ALUControl
);
	input wire opb5;
	input wire [2:0] funct3;
	input wire funct7b5;
	input wire [1:0] ALUOp;
	output reg [2:0] ALUControl;
	
	wire RtypeSub;
	assign RtypeSub = funct7b5 & opb5;
	
	always@(*)
		case(ALUOp)
			2'b00: ALUControl <= 3'b000; //ADD
			2'b01: ALUControl <= 3'b001; //sub
			default: case(funct3)
					3'b000: if(RtypeSub)
							ALUControl = 3'b001;
						else
							ALUControl = 3'b000;
					3'b010: ALUControl = 3'b101;
					3'b110: ALUControl = 3'b011;
					3'b111: ALUControl = 3'b010;
					default: ALUControl = 3'bxxx;
			endcase
		endcase
endmodule
	
// Datapath
module datapath (
	clk,
	reset,
	ResultSrc,
	PCSrc,
	ALUSrc,
	RegWrite,
	ImmSrc,
	ALUControl,
	Zero,
	PC,
	Instr,
	ALUResult,
	WriteData,
	ReadData
);
	input wire clk;
	input wire reset;
	input wire [1:0] ResultSrc;
	input wire PCSrc;
	input wire ALUSrc;
	input wire RegWrite;
	input wire [1:0] ImmSrc;
	input wire [2:0] ALUControl;
	output wire Zero;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire [31:0] PCNext;
	wire [31:0] PCPlus4;
	wire [31:0] PCTarget;
	wire [31:0] ImmExt;
	wire [31:0] SrcA;
	wire [31:0] SrcB;
	wire [31:0] Result;
	flopr #(.WIDTH(32)) pcreg(
		.clk(clk),
		.reset(reset),
		.d(PCNext),
		.q(PC)
	);
	adder pcadd4(
		.a(PC),
		.b(32'd4),
		.y(PCPlus4)
	);
	adder pcaddbranch(
		.a(PC),
		.b(ImmExt),
		.y(PCTarget)
	);
	mux2 #(.WIDTH(32)) pcmux(
		.d0(PCPlus4),
		.d1(PCTarget),
		.s(PCSrc),
		.y(PCNext)
	);
	regfile rf(
		.clk(clk),
		.we3(RegWrite),
		.a1(Instr[19:15]),
		.a2(Instr[24:20]),
		.a3(Instr[11:7]),
		.wd3(Result),
		.rd1(SrcA),
		.rd2(WriteData)
	);
	extend ext(
		.instr(Instr[31:7]),
		.immsrc(ImmSrc),
		.immext(ImmExt)
	);
	mux2 #(.WIDTH(32)) srcbmux(
		.d0(WriteData),
		.d1(ImmExt),
		.s(ALUSrc),
		.y(SrcB)
	);
	alu alu(
		.a(SrcA),
		.b(SrcB),
		.alucontrol(ALUControl),
		.result(ALUResult),
		.zero(Zero)
	);
	mux3 #(.WIDTH(32)) resultmux(
		.d0(ALUResult),
		.d1(ReadData),
		.d2(PCPlus4),
		.s(ResultSrc),
		.y(Result)
	);
endmodule

// Register file
module regfile (
	clk,
	we3,
	a1,
	a2,
	a3,
	wd3,
	rd1,
	rd2
);

	input wire clk;
	input wire we3;
	input wire [4:0] a1;
	input wire [4:0] a2;
	input wire [4:0] a3;
	input wire [31:0] wd3;
	output wire [31:0] rd1;
	output wire [31:0] rd2;
	reg [31:0] rf[31:0];
	
	always@(posedge clk)
		if(we3) rf[a3] <=wd3;
		
	assign rd1 = (a1 != 0) ? rf[a1] : 0;
	assign rd2 = (a2 != 0) ? rf[a2] : 0;
endmodule 
	
// ADDER
module adder (
	a,
	b,
	y
);
	input [31:0] a;
	input [31:0] b;
	output wire [31:0] y;
	assign y = a + b;
endmodule

// EXTEND UNIT
module extend (
	instr,
	immsrc,
	immext
);

	input wire [31:7] instr;
	input wire [1:0] immsrc;
	output reg [31:0] immext;
	
	always@(*)
		case(immsrc)
			2'b00: immext = {{20{instr[31]}}, instr[31:20]};
			2'b01: immext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
			2'b10: immext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
			2'b11: immext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
			default: immext = 32'bx;
		endcase
endmodule

// RESETTABLE FLIP-FLOP
module flopr (
	clk,
	reset,
	d,
	q
);
	parameter WIDTH = 8;
	
	input wire clk;
	input wire reset;
	input wire [WIDTH-1:0] d;
	output reg [WIDTH-1:0] q;
	
	always@(posedge clk, posedge reset)
		if(reset) q <= 7'b0;
		else q <= d;
endmodule

// MUX 2:1
module mux2 (
	d0,
	d1,
	s,
	y
);
	parameter WIDTH = 8;
	
	input wire [WIDTH-1:0] d0;
	input wire [WIDTH-1:0] d1;
	input wire s;
	output wire [WIDTH-1:0] y;
	
	assign y = s ? d1 : d0;
endmodule

// MUX 3:1
module mux3 (
	d0,
	d1,
	d2,
	s,
	y
);
	parameter WIDTH = 8;
	
	input wire [WIDTH-1:0] d0;
	input wire [WIDTH-1:0] d1;
	input wire [WIDTH-1:0] d2;
	input wire [1:0] s;
	output wire [WIDTH-1:0] y;
	
	assign y = (s == 2'b10) ? d2 : (s == 2'b01) ? d1 : d0;
	
endmodule

// Instruction memory
module imem (
	a,
	rd
);
	input wire [31:0] a;
	output wire [31:0] rd;
	reg [31:0] RAM [63:0];
	initial $readmemh("riscvtest.hex", RAM);
	assign rd = RAM[a[31:2]];
endmodule

// Data memory
module dmem (
	clk,
	we,
	a,
	wd,
	rd
);

	input wire clk;
	input wire we;
	input wire [31:0] a;
	input wire [31:0] wd;
	output [31:0] rd;
	
	reg [31:0] RAM[63:0];
	
	assign rd = RAM[a[31:2]];
	
	always@(posedge clk)
		if(we) RAM[a[31:2]] <=wd;
endmodule

//ALU
module alu (
	a,
	b,
	alucontrol,
	result,
	zero
);
	input wire [31:0] a;
	input wire [31:0] b;
	input wire [2:0] alucontrol;
	output reg [31:0] result;
	output wire zero;
	wire [31:0] condinvb;
	wire [31:0] sum;
	wire v;
	wire isAddSub;
	assign condinvb = (alucontrol[0] ? ~b : b);
	assign sum = (a + condinvb) + alucontrol[0];
	assign isAddSub = (~alucontrol[2] & ~alucontrol[1]) | (~alucontrol[1] & alucontrol[0]);
	always @(*)
		case (alucontrol)
			3'b000: result = sum;
			3'b001: result = sum;
			3'b010: result = a & b;
			3'b011: result = a | b;
			3'b100: result = a ^ b;
			3'b101: result = sum[31] ^ v;
			3'b110: result = a << b[4:0];
			3'b111: result = a >> b[4:0];
			default: result = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
		endcase
	assign zero = result == 32'b00000000000000000000000000000000;
	assign v = (~((alucontrol[0] ^ a[31]) ^ b[31]) & (a[31] ^ sum[31])) & isAddSub;
endmodule

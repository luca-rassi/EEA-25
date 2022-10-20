`include "reg_file.v"

module reg_file_tb ();

	reg [4:0] rg_A1, rg_A2, rg_A3;
	reg [31:0] rg_WD3;
	wire [31:0] rg_RD1, rg_RD2;
	reg rg_WE3;
	reg clock, reset;
	integer i;
	
	reg_file uut (
		rg_A1, rg_A2, rg_A3, rg_WD3,
		rg_RD1, rg_RD2, rg_WE3,
		clock, reset);

	initial begin
		$dumpfile("reg_file_output_wave.vcd");
		$dumpvars(0, reg_file_tb);
	end
	//first lets set the values of register to default
	initial begin
		reset = 1;
		#15 reset = 0;
	end
	//Let's set the interval of a clock
	initial begin
		clock = 0;
		forever #20 clock = ~clock;
	end
	//We will write some values to address 0 to 5
	initial begin
		rg_WE3 =0;
		#40
		rg_WE3 =1; rg_WD3=10; rg_A3=0;
		#40
		rg_WE3 =1; rg_WD3=20; rg_A3=1;
		#40
		rg_WE3 =1; rg_WD3=30; rg_A3=2;
		#40
		rg_WE3 =1; rg_WD3=40; rg_A3=3;
		#40
		rg_WE3 =1; rg_WD3=50; rg_A3=4;
		#40
		rg_WE3 =1; rg_WD3=60; rg_A3=5;
		#40
		rg_WE3 =0;
	end
	//let's check what we have changed
	initial begin
	#300
		for (i = 0; i < 5; i = i + 2) begin
			rg_A1 = i;
			rg_A2 = i + 1;
			#20;
		end
	end
	//let's reset and check the values at all addresses
	initial begin
		#360
		reset=1;
		#15 reset = 0;
		#5
		for (i = 0; i < 31; i = i + 2) begin
			rg_A1 = i;
			rg_A2 = i + 1;
			#20;
		end
	end
	

	initial begin
		#700 $finish;
	end

endmodule

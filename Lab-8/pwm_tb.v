`include "pwm.v"

module pwm_tb();

	parameter WIDTH = 12;

	reg CLK;
	reg WSTRB;
	reg SEL;
	reg [31:0] WDATA;

	wire LED;

	pwm uut(	.clk(CLK),
			.wstrb(WSTRB),
			.sel(SEL),
			.wdata(WDATA),
			.led(LED)
		);
		
	initial begin
		$dumpfile("pwm_tb.vcd");
		$dumpvars(0, pwm_tb);
	end
	
	initial begin
		CLK = 0;
		forever #21 CLK = ~CLK;
	end


	initial begin
		WDATA = 0; SEL = 1; WSTRB = 1;
		#500
		WDATA = 1; SEL = 1; WSTRB = 1;
		#500
		WDATA = 2; SEL = 1; WSTRB = 1;
		#500
		WDATA = 3; SEL = 1; WSTRB = 1;
		#500
		WDATA = 4; SEL = 1; WSTRB = 0;
		#500
		WDATA = 5; SEL = 0; WSTRB = 1;
		#500
		WDATA = 6; SEL = 0; WSTRB = 0;
		#500
		WDATA = 7; SEL = 0; WSTRB = 0;
		#500
		WDATA = 8; SEL = 0; WSTRB = 0;
		#500
		WDATA = 9; SEL = 0; WSTRB = 0;
		#500
		WDATA = 10; SEL = 0; WSTRB = 0;
		
	end
	
	initial begin
		#5500 $finish;
	end

endmodule

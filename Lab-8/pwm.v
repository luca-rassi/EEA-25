module pwm #(

	parameter WIDTH = 12
) (
	input		clk,
	input		wstrb,
	input		sel,
	input	[31:0]	wdata,

	output led
);

	reg		pwm_led = 1'b0;
	reg [WIDTH-1:0]	pwm_count = 0;
	reg [WIDTH-1:0]	count = 0;

	assign led = pwm_led;

	always @ (posedge clk) begin

		if(sel && wstrb) begin
			pwm_count <= wdata[WIDTH-1:0];
			count <= 0;

		end else begin
			count <= count + 1;
			if (count < pwm_count) begin
				pwm_led <= 1'b1;
			end else begin
				pwm_led <= 1'b0;
			end
		end
	end

endmodule

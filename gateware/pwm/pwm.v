`default_nettype none

module top(
    input clk,
    output nLED
);

	reg [7:0] dutyCycle = 0;
	reg countUp = 1;
	wire dividedPulse;

	// Fade up / down to "heartbeat" LED
	always @(posedge clk) begin
		if (dividedPulse) begin
			if (dutyCycle == 1) begin
				countUp <= 1;
			end else if (dutyCycle == 254) begin
				countUp <= 0;
			end

			if (countUp) begin
				dutyCycle <= dutyCycle + 1;
			end else begin
				dutyCycle <= dutyCycle - 1;
			end
		end
	end

	clk_div_hz #(
		.FREQUENCY(500)
	) inst_clk_div_hz (
		.clk          (clk),
		.rst          (1'b0),
		.enable       (1'b1),
		.dividedClk   (),
		.dividedPulse (dividedPulse)
	);

	pwm #(
		.FREQUENCY(1_000)
	) inst_pwm (
		.clk       (clk),
		.rst       (1'b0),
		.enable    (1'b1),
		.dutyCycle (dutyCycle),
		.out       (),
		.nOut      (nLED)
	);

endmodule


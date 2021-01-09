`default_nettype none

module pwm #(
	parameter integer FREQUENCY = 1000
	)(
    input clk,
    input rst,
    input enable,
    input [7:0] dutyCycle,
    output out,
    output nOut
);

	wire dividedPulse;
	reg [0:7] counter = 0;
	reg out;
	wire nOut;

	// accumulator for ramp function
	always @(posedge clk) begin
		if (rst) begin
			counter <= 0;
		end
		else if (dividedPulse && enable) begin
			counter <= counter + 1;
		end
	end

	// flip flop output upon comparison
	always @(posedge clk) begin
		if (rst) begin
			out <= 0;
		end
		else if ((counter < dutyCycle) && enable) begin
			out <= 1;
		end
		else if ((counter >= dutyCycle) && enable) begin
			out <= 0;
		end
	end

	assign nOut = ~out;
	
	// divided down clock as required		
	clk_div_hz #(
			.FREQUENCY(FREQUENCY * 256)
		) inst_clockDividerHz (
			.clk        	(clk),
			.rst        	(rst),
			.enable     	(enable),
			.dividedClk 	(),
			.dividedPulse	(dividedPulse)
		);
endmodule
`default_nettype none

module clk_div_hz #(
	parameter integer FREQUENCY = 1
	)(
	input clk,
	input rst,
	input enable,
	output reg dividedClk = 0,
	output reg dividedPulse = 0
);	

	// calculate threshold value from frequency
	localparam CLK_FREQ = 32'd12_000_000;
	localparam THRESHOLD = CLK_FREQ / FREQUENCY / 2;
	
	reg [31:0] counter = 0;

	// accumulator counting up / resetting
	always @(posedge clk) begin
		if (rst || (counter >= THRESHOLD - 1)) begin
			counter <= 0;
			// give a pulse for one clock cycle only
			dividedPulse <= (1 & dividedClk);
		end
		else if (enable) begin
			counter <= counter + 1;
			dividedPulse <= 0;
		end
	end

	// generate divided down clock
	always @(posedge clk) begin
		if (rst) begin
			dividedClk <= 0;
		end
		else if (counter >= THRESHOLD - 1) begin
			dividedClk <= ~dividedClk;
		end
	end
endmodule
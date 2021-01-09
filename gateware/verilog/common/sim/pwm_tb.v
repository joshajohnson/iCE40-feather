`timescale 1ns/1ps
`include "pwm.v"

module pwm_tb();

	logic clk, rst, enable;
	wire out, nOut;
	reg [7:0] dutyCycle;

	// Clock
	initial begin
		clk = 0;
		forever #(42) clk = ~clk;
	end

	initial begin
		rst = 1;
		enable = 0;
		dutyCycle = 8'd50;

		#(100)

		rst = 0;
		#(100)
		enable = 1;

		#(30_00_232)
		rst = 1;
		#(500)
		rst = 0;
		dutyCycle = 8'd128;
	end


	pwm #(
		.FREQUENCY(1_000_000)
	) inst_pwm (
		.clk       (clk),
		.rst       (rst),
		.enable    (enable),
		.dutyCycle (dutyCycle),
		.out       (out),
		.nOut      (nOut)
	);


	// Dump wave
	initial begin
		$dumpfile("pwm_tb.lxt");
		$dumpvars(0,pwm_tb);
	end
	
	// Count in 10% increments and finish sim when time is up
	localparam SIM_TIME_MS = 10;
	localparam SIM_TIME = SIM_TIME_MS * 1_000_000; // @ 1 ns / unit
	initial begin
		$display("Simulation Started");
		#(SIM_TIME/10);
		$display("10%");
		#(SIM_TIME/10);
		$display("20%");
		#(SIM_TIME/10);
		$display("30%");
		#(SIM_TIME/10);
		$display("40%");
		#(SIM_TIME/10);
		$display("50%");
		#(SIM_TIME/10);
		$display("60%");
		#(SIM_TIME/10);
		$display("70%");
		#(SIM_TIME/10);
		$display("80%");
		#(SIM_TIME/10);
		$display("90%");
		#(SIM_TIME/10);
		$display("Finished");
		$finish;
	end

endmodule

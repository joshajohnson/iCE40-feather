`timescale 1ns/1ps
`include "blink.v"

module blink_tb();

	logic clk;
	wire nLED;

	// Clock
	initial begin
		clk = 0;
		forever #(42) clk = ~clk;
	end

	top inst_top (.clk(clk), .nLED(nLED));

	// Dump wave
	initial begin
		$dumpfile("blink_tb.lxt");
		$dumpvars(0,blink_tb);
	end
	
	// Count in 10% increments and finish sim when time is up
	localparam SIM_TIME_MS = 100;
	localparam SIM_TIME = SIM_TIME_MS * 1000_000; // @ 1 ns / unit
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

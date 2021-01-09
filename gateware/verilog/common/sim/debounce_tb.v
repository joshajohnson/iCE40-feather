`timescale 1ns/1ps
`include "debounce.v"

module debounce_tb();

	logic clk;
	reg button = 0;
	wire button_db, button_rising, button_falling;

	// Clock
	initial begin
		clk = 0;
		forever #(42) clk = ~clk;
	end

	initial begin
		button = 0;
		#(50_000_000) // 50ms
		button = 1;
		#(10_000_000) // 10ms
		button = 0;
		#(10_000_000) // 10ms
		button = 1;
		#(50_000_000) // 50ms
		button = 0;
		#(10_000_000) // 10ms
		button = 1;
		#(1000_000_000) // 100ms
		button = 0;
		#(10_000_000) // 10ms
		button = 1;
		#(10_000_000) // 10ms
		button = 0;
	end

	debounce inst_debounce
		(
			.clk            (clk),
			.button         (button),
			.button_db      (button_db),
			.button_rising  (button_rising),
			.button_falling (button_falling)
		);


	// Dump wave
	initial begin
		$dumpfile("debounce_tb.lxt");
		$dumpvars(0,debounce_tb);
	end
	
	// Count in 10% increments and finish sim when time is up
	localparam SIM_TIME_MS = 500;
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

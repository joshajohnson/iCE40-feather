`timescale 1ns/1ps

`define SIMULATION

`include "dot.v"

module dot_tb();

	logic clk;
	reg btn_up = 0;
	reg btn_left = 0;
	reg btn_right = 0;
	reg btn_down = 0;
	wire [5:0] row, col;

	// Clock
	initial begin
		clk = 0;
		forever #(42) clk = ~clk;
	end

	initial begin
		#(5_000_000); // 5 ms
		btn_up = 1;
		#(84)
		btn_up = 0;

		#(55_000_000) // 55 ms
		btn_right = 1;
		#(84)
		btn_right = 0;

		#(22_000_000) // 22 ms
		btn_down = 1;
		#(84)
		btn_down = 0;

		#(35_000_000) // 35 ms
		btn_down = 1;
		#(84)
		btn_down = 0;
	end


	top inst_top
	(
		.clk       (clk),
		.btn_up    (btn_up),
		.btn_left  (btn_left),
		.btn_right (btn_right),
		.btn_down  (btn_down),
		.row       (row),
		.col       (col)
	);

	// Dump wave
	initial begin
		$dumpfile("dot_tb.lxt");
		$dumpvars(0,dot_tb);
	end
	
	// Count in 10% increments and finish sim when time is up
	localparam SIM_TIME_MS = 150;
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

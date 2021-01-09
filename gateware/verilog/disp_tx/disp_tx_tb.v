`timescale 1ns/1ps
`define SIMULATION
`include "disp_tx.v"

module disp_tx_tb();

	logic clk, btn_up, btn_left, btn_right, btn_down;
	wire [5:0] row, col;
	wire uart_tx;

	// Clock
	initial begin
		clk = 0;
		forever #(42) clk = ~clk;
	end

	top inst_top
	(
		.clk       (clk),
		.btn_up    (btn_up),
		.btn_left  (btn_left),
		.btn_right (btn_right),
		.btn_down  (btn_down),
		.UART_TX   (uart_tx),
		.row       (row),
		.col       (col)
	);

	initial begin
		btn_right = 0;
		btn_up = 0;
		#(5_000_000) // 5 ms
		btn_right = 1;
		#(86)
		btn_right = 0;

		#(3_000_000) // 3 ms
		btn_up = 1;
		#(86)
		btn_up = 0;
	end


	// Dump wave
	initial begin
		$dumpfile("disp_tx_tb.lxt");
		$dumpvars(0,disp_tx_tb);
	end
	
	// Count in 10% increments and finish sim when time is up
	localparam SIM_TIME_MS = 20;
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

`timescale 1ns/1ps
`include "led_matrix.v"

module led_matrix_tb();

	logic clk;
	wire [35:0] img;
	// Clock
	initial begin
		clk = 0;
		forever #(42) clk = ~clk;
	end

	led_matrix inst_led_matrix
	(
		.clk (clk),
		.img (img)
	);

	assign img [5:0] 	= 6'b100001;
	assign img [11:6] 	= 6'b010010;
	assign img [17:12] = 6'b001100;
	assign img [23:18] = 6'b010010;
	assign img [29:24] = 6'b100001;
	assign img [35:30] = 6'b000000;


	// Dump wave
	initial begin
		$dumpfile("led_matrix_tb.lxt");
		$dumpvars(0,led_matrix_tb);
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

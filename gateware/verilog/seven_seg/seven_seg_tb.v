`timescale 1ns/1ps
`include "seven_seg.v"

module seven_seg_tb();

	logic clk;
	reg [7:0] sw;
	reg switch = 0;

	// Clock
	initial begin
		clk = 0;
		forever #(42) clk = ~clk;
	end

	initial begin
		sw = 8'd0;
		#900
		sw = 8'd1;
		#900
		sw = 8'd2;
		#900
		sw = 8'd3;
		#900
		sw = 8'd4;
		#900
		sw = 8'd5;
		#900
		sw = 8'd35;
		#900
		sw = 8'd45;
		#900
		sw = 8'd32;
		#900
		sw = 8'd99;
		#900
		sw = 8'd100;
		#900
		sw = 8'd120;
		#900
		sw = 8'd127;
		#900
		sw = 8'd128;
		#900
		sw = 8'd210;
		#900
		sw = 8'd255;

	end



	top inst_top (.clk(clk), .sw(sw),. switch(switch));

	// Dump wave
	initial begin
		$dumpfile("seven_seg_tb.lxt");
		$dumpvars(0,seven_seg_tb);
	end
	
	// Count in 10% increments and finish sim when time is up
	localparam SIM_TIME_MS = 10;
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

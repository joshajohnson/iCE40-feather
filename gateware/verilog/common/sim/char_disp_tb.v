`timescale 1ns/1ps
`include "char_disp.v"

module char_disp_tb();

	logic clk;
	reg [7:0] data;
	wire [35:0] img;

	// Clock
	initial begin
		clk = 0;
		forever #(42) clk = ~clk;
	end

	char_disp inst_char_disp (.clk(clk), .data(data), .img(img));

	initial begin
		data = 8'b01000001;
		#(1000)
		data = 8'd49;
		#(1000)
		data = "2";
	end


	// Dump wave
	initial begin
		$dumpfile("char_disp_tb.lxt");
		$dumpvars(0,char_disp_tb);
	end
	
	// Count in 10% increments and finish sim when time is up
	localparam SIM_TIME_MS = 1;
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

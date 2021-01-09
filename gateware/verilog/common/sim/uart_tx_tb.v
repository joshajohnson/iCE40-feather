`timescale 1ns/1ps
`include "uart_tx.v"

module uart_tx_tb();

	logic clk;
	wire uart_tx, ready;
	reg [7:0] data;
	reg send = 0;

	// Clock
	initial begin
		clk = 0;
		forever #(42) clk = ~clk;
	end

	uart_tx inst_uart_tx (
		.clk(clk), 
		.data(data), 
		.send(send), 
		.uart_tx(uart_tx), 
		.ready(ready)
	);

	initial begin
		data[7:0] = "H";
		#(100_000)
		send <= 1;
		#(86)
		send <= 0;

		#(2000_000)
		data[7:0] = "i";
		send <= 1;
		#(86)
		send <= 0;
	end


	// Dump wave
	initial begin
		$dumpfile("uart_tx_tb.lxt");
		$dumpvars(0,uart_tx_tb);
	end
	
	// Count in 10% increments and finish sim when time is up
	localparam SIM_TIME_MS = 4;
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

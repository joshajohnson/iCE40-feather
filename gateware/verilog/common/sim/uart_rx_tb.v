`timescale 1ns/1ps
`include "uart_rx.v"

module uart_rx_tb();

	reg clk, rst, uart_rx;
	wire ready;
	wire [7:0] data;

	// Clock
	initial begin
		clk = 0;
		forever #(42) clk = ~clk;
	end

	uart_rx inst_uart_rx (.clk(clk), .rst(rst), .uart_rx(uart_rx), .ready(ready), .data(data));

	initial begin
		rst = 0;
		uart_rx = 1;

		#(100000)

		// Start bit
		uart_rx <= 0;
		#(104167) // 1/9600 ns

		// Bit 0
		uart_rx <= 1;
		#(104167) // 1/9600 ns

		// Bit 1
		uart_rx <= 0;
		#(104167) // 1/9600 ns

		// Bit 2
		uart_rx <= 1;
		#(104167) // 1/9600 ns

		// Bit 3
		uart_rx <= 0;
		#(104167) // 1/9600 ns

		// Bit 4
		uart_rx <= 0;
		#(104167) // 1/9600 ns

		// Bit 5
		uart_rx <= 0;
		#(104167) // 1/9600 ns

		// Bit 6
		uart_rx <= 1;
		#(104167) // 1/9600 ns

		// Bit 7
		uart_rx <= 0;
		#(104167) // 1/9600 ns

		// Stop bit
		uart_rx <= 1;
		#(204167)

		// Start bit
		uart_rx <= 0;
		#(104167) // 1/9600 ns

		// Bit 0
		uart_rx <= 1;
		#(104167) // 1/9600 ns

		// Bit 1
		uart_rx <= 0;
		#(104167) // 1/9600 ns

		// Bit 2
		uart_rx <= 1;
		#(104167) // 1/9600 ns

		// Bit 3
		uart_rx <= 0;
		#(104167) // 1/9600 ns

		// Bit 4
		uart_rx <= 1;
		#(104167) // 1/9600 ns

		// Bit 5
		uart_rx <= 0;
		#(104167) // 1/9600 ns

		// Bit 6
		uart_rx <= 1;
		#(104167) // 1/9600 ns

		// Bit 7
		uart_rx <= 0;
		#(104167) // 1/9600 ns

		// Stop bit
		uart_rx <= 1;

	end

	// Dump wave
	initial begin
		$dumpfile("uart_rx_tb.lxt");
		$dumpvars(0,uart_rx_tb);
	end
	
	// Count in 10% increments and finish sim when time is up
	localparam SIM_TIME_MS = 5;
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

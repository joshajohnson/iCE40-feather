`default_nettype none

module top(
    input clk,
    input wire UART_RX,
    output wire [5:0] row,
    output wire [5:0] col
);

	wire [35:0] img;
	reg [35:0] img_show;

	// Display whatever char recently arrived
	always @(posedge clk) begin
		if (ready) begin
			img_show <= img;
		end
	end
	
	// Uart RX 
	wire ready;
	wire [7:0] data;
	uart_rx inst_uart_rx (
		.clk(clk), 
		.rst(1'b0), 
		.uart_rx(UART_RX), 
		.ready(ready), 
		.data(data)
	);

	// Display lookup table
	char_disp inst_char_disp (
		.clk(clk), 
		.data(data), 
		.img(img)
	);

	// Drive matrix
	led_matrix inst_led_matrix (
		.clk	(clk), 
		.img	(img_show), 
		.row 	(row), 
		.col 	(col)
	);

endmodule


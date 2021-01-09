`default_nettype none

module top(
    input clk,
    input btn_up,
    input btn_left,
    input btn_right,
    input btn_down,
    output wire UART_TX,
    output wire [5:0] row,
    output wire [5:0] col,
    output wire nLED_RED_fw
);

	wire btn_up_rising, btn_left_rising, btn_right_rising;
	wire pulse_1Hz;
	assign  nLED_RED_fw = UART_TX;

	// Contstrain to available ascii values
	// dec 65 - 90, 48 - 57, and 33 supported so far
	reg [7:0] ascii_num = 8'd65;
	always @(posedge clk) begin
		if (btn_right_rising) begin
			if (ascii_num == 90)
				ascii_num <= 48;
			else if (ascii_num == 57)
				ascii_num <= 33;
			else if (ascii_num == 33) 
				ascii_num <= 65;
			else 
				ascii_num <= ascii_num + 1;
		end

		if (btn_left_rising) begin
			if (ascii_num == 33)
				ascii_num <= 57;
			else if (ascii_num == 48)
				ascii_num <= 90;
			else if (ascii_num == 65) 
				ascii_num <= 33;
			else 
				ascii_num <= ascii_num - 1;
		end
	end

	// Transmit if up button is pressed
	reg send = 1'b0;
	wire ready;
	always @(posedge clk) begin
		if (btn_up_rising && ready)
			send <= 1'b1;
		else 
			send <= 1'b0;

	end

	// Send Bits
	uart_tx inst_uart_tx (
		.clk(clk), 
		.data(ascii_num), 
		.send(send), 
		.uart_tx(UART_TX), 
		.ready(ready)
	);


	// Show selected char on display
	wire [35:0] img;
	char_disp inst_char_disp (
		.clk(clk), 
		.data(ascii_num), 
		.img(img)
	);

	// Drive matrix
	led_matrix inst_led_matrix (
		.clk	(clk), 
		.img	(img), 
		.row 	(row), 
		.col 	(col)
	);

`ifdef SIMULATION
	// Increase the 1Hz clock speed
	clk_div_hz #(
		.FREQUENCY(1000)
	) inst_clk_div_hz (
		.clk          (clk),
		.rst          (1'b0),
		.enable       (1'b1),
		.dividedClk   (),
		.dividedPulse (pulse_1Hz)
	);

	// pass buttons through without debounce
	assign btn_up_rising = btn_up;
	assign btn_right_rising = btn_right;
	assign btn_left_rising = btn_left;

`else
	// 1Hz clock
	clk_div_hz #(
		.FREQUENCY(1)
	) inst_clk_div_hz_0 (
		.clk          (clk),
		.rst          (1'b0),
		.enable       (1'b1),
		.dividedClk   (),
		.dividedPulse (pulse_1Hz)
	);

	// debonce buttons
	debounce debounce_up
	(
		.clk            (clk),
		.button         (btn_up),
		.button_db      (),
		.button_rising  (btn_up_rising),
		.button_falling ()
	);

	debounce debounce_left
	(
		.clk            (clk),
		.button         (btn_left),
		.button_db      (),
		.button_rising  (btn_left_rising),
		.button_falling ()
	);

	debounce debounce_right
	(
		.clk            (clk),
		.button         (btn_right),
		.button_db      (),
		.button_rising  (btn_right_rising),
		.button_falling ()
	);

`endif
endmodule


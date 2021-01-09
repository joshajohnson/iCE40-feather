`default_nettype none

module uart_rx(
    input wire clk,
    input wire rst,
    input wire uart_rx,
    output reg ready,
    output reg [7:0] data
);

	localparam BAUD_RATE = 9600;

	// UART State Machine
	localparam [3:0] IDLE 	= 4'b0000;
	localparam [3:0] START 	= 4'b0001;
	localparam [3:0] BIT0 	= 4'b0010;
	localparam [3:0] BIT1 	= 4'b0011;
	localparam [3:0] BIT2 	= 4'b0100;
	localparam [3:0] BIT3 	= 4'b0101;
	localparam [3:0] BIT4 	= 4'b0110;
	localparam [3:0] BIT5 	= 4'b0111;
	localparam [3:0] BIT6 	= 4'b1000;
	localparam [3:0] BIT7 	= 4'b1001;
	localparam [3:0] STOP 	= 4'b1010;

	reg [3:0] state = 0;
	reg [3:0] next_state = 0;

	// Drive state machine
	always @(*) begin
		state <= next_state;
	end

	// Mode state machine
	always @(posedge clk) begin
		case (state)
			IDLE : begin
				ready <= 1'b0;
				// Wait until falling edge on UART to begin
				if (uart_edge) begin
					next_state <= START;
					data[7:0] <= 8'b0;
					clk_rst <= 1'b0;
				end
				
			end

			START : begin
				// Hold off half period
				if (sample_now)
					next_state <= BIT0;
			end

			BIT0 : begin
				// Sample first bit
				if (sample_now) begin
					data[0] <= uart_buf[1];
					next_state <= BIT1;
				end
			end

			BIT1 : begin
				if (sample_now) begin
					data[1] <= uart_buf[1];
					next_state <= BIT2;
				end
			end

			BIT2 : begin
				if (sample_now) begin
					data[2] <= uart_buf[1];
					next_state <= BIT3;
				end
			end

			BIT3 : begin
				if (sample_now) begin
					data[3] <= uart_buf[1];
					next_state <= BIT4;
				end
			end

			BIT4 : begin
				if (sample_now) begin
					data[4] <= uart_buf[1];
					next_state <= BIT5;
				end
			end

			BIT5 : begin
				if (sample_now) begin
					data[5] <= uart_buf[1];
					next_state <= BIT6;
				end
			end

			BIT6 : begin
				if (sample_now) begin
					data[6] <= uart_buf[1];
					next_state <= BIT7;
				end
			end

			BIT7 : begin
				if (sample_now) begin
					data[7] <= uart_buf[1];
					next_state <= STOP;
				end
			end

			STOP : begin
				if (sample_now) begin
					ready <= 1'b1;
					next_state <= IDLE;
				end
				
			end

			default: next_state <= IDLE;
		endcase
	end


	// Input buffering / edge detection
	reg uart_buf [1:0];
	reg uart_edge = 0;

	always @(posedge clk) begin
		uart_buf[0] <= uart_rx;
		uart_buf[1] <= uart_buf[0];
		uart_edge <= (uart_buf[0] == 1'b0 && uart_buf[1] == 1'b1) ? 1 : 0;
	end

	// UART Clock
	wire dividedPulse;
	reg sample_now = 0;
	reg clk_rst = 1'b1;

	clk_div_hz #(
			.FREQUENCY(BAUD_RATE * 2)
		) inst_clockDividerHz (
			.clk        	(clk),
			.rst        	(clk_rst),
			.enable     	(1'b1),
			.dividedClk 	(),
			.dividedPulse	(dividedPulse)
		);

	// Generate sampling pulses
	reg counter = 1;
	always @(posedge clk) begin
		sample_now <= counter && dividedPulse; 
		if (dividedPulse) begin
			counter <= counter + 1;
		end
	end

endmodule
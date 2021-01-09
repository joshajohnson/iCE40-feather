`default_nettype none

module top(
    input clk,
    input btn_up,
    input btn_left,
    input btn_right,
    input btn_down,
    output wire [5:0] row,
    output wire [5:0] col
);

	wire btn_up_rising, btn_left_rising, btn_right_rising, btn_down_rising;
	reg error 		= 0;
	reg reset_game 	= 1;
	reg clk_1Hz_rst = 0;

	// Matrix dimensions
	localparam DIM_X = 6;
	localparam DIM_Y = 6;

	// Mode State Machine
	localparam IDLE 	= 4'b0000;
	localparam BEGIN 	= 4'b0010;
	localparam PLAY 	= 4'b0100;
	localparam END 		= 4'b1000;

	reg [3:0] state = IDLE;
	reg [3:0] next_state;

	// Display control
	reg [3:0] display = 0;
	reg [2:0] countdown = 0;

	localparam START	= 4'b0000;
	localparam ONE		= 4'b0001;
	localparam TWO		= 4'b0010;
	localparam THREE	= 4'b0011;
	localparam GAME 	= 4'b0100;
	localparam DEAD 	= 4'b1000;

	// Drive state machine
	always @(*) begin
		state <= next_state;
	end

	// Mode state machine
	always @(posedge clk) begin
		case (state)
			IDLE : begin
				// Move to begin once a key is pressed
				display <= START;
				clk_1Hz_rst <= 1;
				if (btn_up_rising || btn_right_rising || btn_left_rising || btn_down_rising) begin
					next_state <= BEGIN;
					reset_game <= 0;
					countdown <= 3;
				end
			end

			BEGIN : begin
				// Display 3,2,1 on screen before beginning game
				clk_1Hz_rst <= 0;
				display <= countdown;
				if (pulse_1Hz) begin
					countdown <= countdown - 1;
				end

				if (countdown == 0) begin
					next_state <= PLAY;
				end
			end

			PLAY : begin
				// Play dot util it ends
				display <= GAME;
				if (error) begin
					next_state <= END;
				end
			end

			END : begin
				// Display sad face until button pressed 
				display <= DEAD;
				if (btn_up_rising || btn_left_rising || btn_right_rising || btn_down_rising) begin
					next_state <= IDLE;
					reset_game <= 1;
				end
			end

			default: next_state <= IDLE;
		endcase
	end

	// Direction of dot
	localparam UP 		= 4'b0001;
	localparam DOWN 	= 4'b0010;
	localparam LEFT 	= 4'b0100;
	localparam RIGHT 	= 4'b1000;

	// Initial direction of dot
	reg [3:0] direction, prev_direction;

	// Position
	reg [2:0] pos_x = 0;
	reg [2:0] pos_y = 0;

	// Change direction after button press
	always @(posedge clk) begin
		if (reset_game) begin
			direction <= (1<<start_dir); // Pseudo random initial direction
		end else if (btn_up_rising && ~(prev_direction == DOWN)) begin
			direction <= UP;
		end else if (btn_left_rising && ~(prev_direction == RIGHT)) begin
			direction <= LEFT;
		end else if (btn_right_rising && ~(prev_direction == LEFT)) begin
			direction <= RIGHT;
		end else if (btn_down_rising && ~(prev_direction == UP)) begin
			direction <= DOWN;
		end 
	end

	// Update prev position every move to prevent cheat of double press in timestep
	always @(posedge clk) begin
		if(pulse_1Hz) begin
			prev_direction <= direction;
		end
	end

	// Move dot every clock cycle only if playing dot
	wire pulse_1Hz;
	always @(posedge clk) begin
		if (reset_game) begin
			error <= 1'b0;
			pos_x <= start_x + 1; // Pseudo random initial state
			pos_y <= start_y + 1;
		end else if (pulse_1Hz && (state == PLAY)) begin
			case(direction)
			UP: 	if (pos_y < DIM_Y) begin
						if (pos_y < DIM_Y - 1) begin
							pos_y <= pos_y + 1;
							error <= 1'b0;
						end else begin
							error <= 1'b1;
						end
					end 

			LEFT: 	if (pos_x >= 0) begin
						if (pos_x > 0) begin
							pos_x <= pos_x - 1;
							error <= 1'b0;
				  		end else begin
				  			error <= 1'b1;
				  		end

				  	end 

			RIGHT: 	if (pos_x < DIM_X) begin
						if (pos_x < DIM_X - 1) begin
							pos_x <= pos_x + 1;
							error <= 1'b0;
						end else begin
							error <= 1'b1;
						end
					end

			DOWN: 	if (pos_y >= 0) begin
						if (pos_y > 0) begin
							pos_y <= pos_y - 1;
							error <= 1'b0;
				  		end else begin
				  			error <= 1'b1;
				  		end

				  	end 

			default: pos_x = pos_x;
			endcase
		end
	end

	// Display image on screen
	reg [35:0] img;
	always @(posedge clk) begin
		case (display)
			START :	begin
					img [5:0] 		= 6'b000000;
					img [11:6] 		= 6'b010010;
					img [17:12] 	= 6'b000000;
					img [23:18] 	= 6'b100001;
					img [29:24] 	= 6'b011110;
					img [35:30] 	= 6'b000000;
			end 

			ONE : 	begin
					img [5:0] 		= 6'b011100;
					img [11:6] 		= 6'b000100;
					img [17:12] 	= 6'b000100;
					img [23:18] 	= 6'b000100;
					img [29:24] 	= 6'b000100;
					img [35:30] 	= 6'b011110;
			end

			TWO : 	begin
					img [5:0] 		= 6'b111110;
					img [11:6] 		= 6'b000001;
					img [17:12] 	= 6'b011110;
					img [23:18] 	= 6'b100000;
					img [29:24] 	= 6'b100000;
					img [35:30] 	= 6'b011110;
			end

			THREE : begin
					img [5:0] 		= 6'b111111;
					img [11:6] 		= 6'b000001;
					img [17:12] 	= 6'b111111;
					img [23:18] 	= 6'b000001;
					img [29:24] 	= 6'b000001;
					img [35:30] 	= 6'b111111;
			end

			GAME : begin
				img = 0;
				case (5 - pos_y)
					3'd0: img [5:0] 	= 1 << (5 - pos_x);
					3'd1: img [11:6] 	= 1 << (5 - pos_x);
					3'd2: img [17:12] 	= 1 << (5 - pos_x);
					3'd3: img [23:18] 	= 1 << (5 - pos_x);
					3'd4: img [29:24] 	= 1 << (5 - pos_x);
					3'd5: img [35:30] 	= 1 << (5 - pos_x);
					default: img 		= 36'd0;
				endcase
				end

			DEAD : begin
					img [5:0] 		= 6'b000000;
					img [11:6] 		= 6'b010010;
					img [17:12] 	= 6'b000000;
					img [23:18] 	= 6'b000000;
					img [29:24] 	= 6'b011110;
					img [35:30] 	= 6'b000000;
			end
			default : begin
					img [5:0] 		= 6'b000000;
					img [11:6] 		= 6'b000000;
					img [17:12] 	= 6'b000000;
					img [23:18] 	= 6'b000000;
					img [29:24] 	= 6'b000000;
					img [35:30] 	= 6'b000000;
			end 
		endcase
	end

	// Drive matrix
	led_matrix inst_led_matrix (
		.clk	(clk), 
		.img	(img), 
		.row 	(row), 
		.col 	(col)
	);

	// Generate random starting position for x, y, and direction
	reg [1:0] start_x = 0; 
	reg [1:0] start_y = 0;
	reg [1:0] start_dir = 0;
	wire pulse_random;
	always @(posedge clk) begin
		if (pulse_random) begin
			start_x <= start_x + 1;
			start_dir <= start_dir - 1;
			if (start_x == 2'd2) begin
				start_y <= start_y + 1;
			end
		end
	end

	// For pseudorandom generator
	clk_div_hz #(
		.FREQUENCY(2001)
	) inst_clk_div_hz_1 (
		.clk          (clk),
		.rst          (1'b0),
		.enable       (1'b1),
		.dividedClk   (),
		.dividedPulse (pulse_random)
	);

`ifdef SIMULATION
	// Increase the 1Hz clock speed
	clk_div_hz #(
		.FREQUENCY(1000)
	) inst_clk_div_hz (
		.clk          (clk),
		.rst          (clk_1Hz_rst),
		.enable       (1'b1),
		.dividedClk   (),
		.dividedPulse (pulse_1Hz)
	);

	// pass buttons through without debounce
	assign btn_up_rising = btn_up;
	assign btn_down_rising = btn_down;
	assign btn_right_rising = btn_right;
	assign btn_left_rising = btn_left;

`else
	// 1Hz clock
	clk_div_hz #(
		.FREQUENCY(1)
	) inst_clk_div_hz_0 (
		.clk          (clk),
		.rst          (clk_1Hz_rst),
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

	debounce debounce_down
	(
		.clk            (clk),
		.button         (btn_down),
		.button_db      (),
		.button_rising  (btn_down_rising),
		.button_falling ()
	);
`endif
endmodule


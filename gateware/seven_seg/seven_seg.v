`default_nettype none

module top(
    input clk,
    input [7:0] sw,
    input switch,
    output reg [6:0] seg,
    output reg [1:0] com
	);

	// params / wires
	localparam COM_ANODE = 1;
	wire dividedClk;
	wire [6:0] disp0, disp1;
	wire [3:0] nibbleMS, nibbleLS;

	// mux displays together
	always @(posedge clk) begin
		case (dividedClk)
			0:begin
				seg <= disp1;
				if (COM_ANODE) begin
					com <= 2'b01;
				end else begin
					com <= 2'b10;
				end
			end
			1:begin
				seg <= disp0;
				if (COM_ANODE) begin
					com <= 2'b10;
				end else begin
					com <= 2'b01;
				end
			end
		endcase
	end

	// choose what number to show on display
	display_select inst_display_select (
		.clk 		(clk), 
		.sw 		(sw), 
		.switch 	(switch), 
		.nibbleMS 	(nibbleMS), 
		.nibbleLS 	(nibbleLS)
	);

	// decodes nibble to 7 segment display
	nibble_decode #(
			.COM_ANODE 	(COM_ANODE)
		) nibble_decodeMSD (
			.clk 		(clk), 
		 	.nibblein 	(nibbleMS), 
			.segout 	(disp0)
	);

	nibble_decode #(
			.COM_ANODE 	(COM_ANODE)
		) nibble_decodeLSD (
			.clk 		(clk), 
		 	.nibblein 	(nibbleLS), 
			.segout 	(disp1)
	);
	
	// generate clock for switching displays
	clk_div_hz #(
			.FREQUENCY(100)
		) inst_clk_div_hz (
			.clk        	(clk),
			.rst        	(1'b0),
			.enable     	(1'b1),
			.dividedClk 	(dividedClk),
			.dividedPulse	()
	);

endmodule


`default_nettype none

module led_matrix(
    input clk,
    input [35:0] img,
    output [5:0] row,
    output [5:0] col
);
	wire dividedPulse;
	parameter DIM_X = 6;
	parameter DIM_Y = 6;
	reg [2:0] rowCnt = 0;
	reg [5:0] colOut = 0;

	always @(posedge clk) begin
		if (dividedPulse) begin
			if (rowCnt < DIM_Y - 1) begin
				rowCnt <=  rowCnt + 1;
			end else begin
				rowCnt <= 0;
			end
		end 
	end

	always @(posedge clk) begin
		case (rowCnt)
			3'd0: colOut = img [5:0];
			3'd1: colOut = img [11:6];
			3'd2: colOut = img [17:12];
			3'd3: colOut = img [23:18];
			3'd4: colOut = img [29:24];
			3'd5: colOut = img [35:30];
			default: colOut = 6'b000000;
		endcase
	end

	assign row = 1 << rowCnt;
	assign col = ~colOut;
		
	clk_div_hz #(
			.FREQUENCY(3600)
		) inst_clockDividerHz (
			.clk        	(clk),
			.rst        	(1'b0),
			.enable     	(1'b1),
			.dividedClk 	(),
			.dividedPulse	(dividedPulse)
		);

endmodule
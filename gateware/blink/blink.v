`default_nettype none

module top(
    input clk,
    output nLED
);

	reg [24:0] ctr = 0;

    always @(posedge clk) begin
        ctr <= ctr + 1;
    end

	assign nLED = ctr[23];

endmodule


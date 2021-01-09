`default_nettype none

module nibble_decode #(
    parameter integer COM_ANODE = 1
    )(
    input clk,
    input [3:0] nibblein,
    output reg [6:0] segout
    );

    reg [6:0] seg;

    // invert display for common anode / cathode
    always @(*) begin
        if (COM_ANODE) begin
            segout[6:0] = ~seg[6:0];
        end else begin
            segout[6:0] = seg[6:0];
        end
    end

    // light up required sections for each number
    always @(*) begin
        case (nibblein)
            4'h0: seg = 7'b0111111;
            4'h1: seg = 7'b0000110;
            4'h2: seg = 7'b1011011;
            4'h3: seg = 7'b1001111;
            4'h4: seg = 7'b1100110;
            4'h5: seg = 7'b1101101;
            4'h6: seg = 7'b1111101;
            4'h7: seg = 7'b0000111;
            4'h8: seg = 7'b1111111;
            4'h9: seg = 7'b1100111;
            4'hA: seg = 7'b1110111;
            4'hB: seg = 7'b1111100;
            4'hC: seg = 7'b0111001;
            4'hD: seg = 7'b1011110;
            4'hE: seg = 7'b1111001;
            4'hF: seg = 7'b1110001;
            default: seg = 7'b0000000;
        endcase
        end 
endmodule

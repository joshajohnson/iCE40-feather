`default_nettype none

module display_select(
    input clk,
    input [7:0] sw,
    input switch, 
    output reg [3:0] nibbleMS,
    output reg [3:0] nibbleLS
    );

    reg [7:0] dispNum = 0;

    // change between dec and hex display
    always @(posedge clk) begin
        // if in hex mode, pass switches through
        if (switch) begin
            nibbleMS <= sw[7:4];
            nibbleLS <= sw[3:0]; 
        end else begin
            // if in dec mode, only show last two characters
            if (sw <= 99) begin
                dispNum = sw;
            end else if (sw <= 199) begin
                dispNum = sw - 100;
            end else begin
                dispNum = sw - 200;
            end
            // determine value to display in most significant display
            if ((dispNum >= 7'd90) && (sw <= 99)) begin
                nibbleMS = 4'd9;
            end else if (dispNum >= 8'd80) begin
                nibbleMS = 4'd8;
            end else if (dispNum >= 8'd70) begin
                nibbleMS = 4'd7;
            end else if (dispNum >= 8'd60) begin
                nibbleMS = 4'd6;
            end else if (dispNum >= 8'd50) begin
                nibbleMS = 4'd5;
            end else if (dispNum >= 8'd40) begin
                nibbleMS = 4'd4;
            end else if (dispNum >= 8'd30) begin
                nibbleMS = 4'd3;
            end else if (dispNum >= 8'd20) begin
                nibbleMS = 4'd2;
            end else if (dispNum >= 8'd10) begin
                nibbleMS = 4'd1;
            end else begin
                nibbleMS = 4'd0;
            end 

            // calculate least significant digit
            nibbleLS = dispNum - nibbleMS * 4'd10;
        end
    end
endmodule

module xp9 (
    input [3:0] BCDin, // Slide Switch
    output [3:0] digit, // Enable 4 digits
    output reg [7:0] Seven_Segment // 7 Segments and Dot LEDs
);

always @ (BCDin)
begin
    case (BCDin)
        4'b0000: Seven_Segment = 8'b00000011; // 0
        4'b0001: Seven_Segment = 8'b10011111; // 1
        4'b0010: Seven_Segment = 8'b00100101; // 2
        4'b0011: Seven_Segment = 8'b00001101; // 3
        4'b0100: Seven_Segment = 8'b10011001; // 4
        4'b0101: Seven_Segment = 8'b01001001; // 5
        4'b0110: Seven_Segment = 8'b01000001; // 6
        4'b0111: Seven_Segment = 8'b00011111; // 7
        4'b1000: Seven_Segment = 8'b00000001; // 8
        4'b1001: Seven_Segment = 8'b00001001; // 9
        default: Seven_Segment = 8'b11111111; // Null
    endcase
end

assign digit = 4'b1111; // Assuming all digits are enabled

endmodule

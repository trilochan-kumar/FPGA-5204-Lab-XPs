module xp10 (
    input wire CLK, RST,  // Slide Switch
    output reg [3:0] digit,  // Enable 4 digit
    output reg [7:0] Seven_Segment  // 7 Segments and Dot LEDs
);

reg [17:0] counter;
reg [15:0] digit_count;
reg [3:0] BCDin;
wire clock_out;

// Clock Divider module declaration
Clock_Divider clk_div (
    .clk(CLK),
    .reset(RST),
    .clock_out(clock_out)
);

// Seven segment display patterns
always @ (BCDin) begin
    case (BCDin)
        4'd0: Seven_Segment = 8'b00000011; // 0
        4'd1: Seven_Segment = 8'b10011111; // 1
        4'd2: Seven_Segment = 8'b00100101; // 2
        4'd3: Seven_Segment = 8'b00001101; // 3
        4'd4: Seven_Segment = 8'b10011001; // 4
        4'd5: Seven_Segment = 8'b01001001; // 5
        4'd6: Seven_Segment = 8'b01000001; // 6
        4'd7: Seven_Segment = 8'b00011111; // 7
        4'd8: Seven_Segment = 8'b00000001; // 8
        4'd9: Seven_Segment = 8'b00001001; // 9
        default: Seven_Segment = 8'b11111111; // Null
    endcase
end

// Counter process
always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        counter <= 18'b0;
    end else begin
        counter <= counter + 1;
    end
end

// Digit controller
always @ (posedge CLK) begin
    case (counter[17:16])
        2'b00: begin
            digit <= 4'b0001;
            BCDin <= digit_count[15:12];
        end
        2'b01: begin
            digit <= 4'b0010;
            BCDin <= digit_count[11:8];
        end
        2'b10: begin
            digit <= 4'b0100;
            BCDin <= digit_count[7:4];
        end
        2'b11: begin
            digit <= 4'b1000;
            BCDin <= digit_count[3:0];
        end
        default: digit <= 4'b0000;
    endcase
end

// Counting process
always @ (posedge clock_out or posedge RST) begin
    if (RST) begin
        digit_count <= 16'b0;
    end else begin
        if (digit_count[3:0] < 4'b1001) begin
            digit_count[3:0] <= digit_count[3:0] + 1;
        end else begin
            digit_count[3:0] <= 4'b0000;
            if (digit_count[7:4] < 4'b1001) begin
                digit_count[7:4] <= digit_count[7:4] + 1;
            end else begin
                digit_count[7:4] <= 4'b0000;
                if (digit_count[11:8] < 4'b1001) begin
                    digit_count[11:8] <= digit_count[11:8] + 1;
                end else begin
                    digit_count[11:8] <= 4'b0000;
                    if (digit_count[15:12] < 4'b1001) begin
                        digit_count[15:12] <= digit_count[15:12] + 1;
                    end else begin
                        digit_count[15:12] <= 4'b0000;
                    end
                end
            end
        end
    end
end

endmodule


module lcd (
    input clk,          // Clock input
    output reg lcd_e,   // Enable control
    output reg lcd_rs,  // Data or command control
    output reg [7:0] data // Data line
);

parameter N = 22; // Number of data entries
reg [7:0] datas [1:N]; // Array to store data
integer i = 0; // Counter for timing
integer j = 1; // Index for data selection

always @(posedge clk) begin
    if (i <= 1000000) begin
        i <= i + 1;
        lcd_e <= 1;
        data <= datas[j];
    end else if (i > 1000000 && i < 2000000) begin
        i <= i + 1;
        lcd_e <= 0;
    end else if (i == 2000000) begin
        j <= j + 1;
        i <= 0;
    end

    if (j <= 5) begin
        lcd_rs <= 0; // Command signal
    end else begin
        lcd_rs <= 1; // Data signal
    end

    if (j == 22) begin
        j <= 5; // Repeated display of data
    end
end

initial begin
    // Initialize datas with command and data to display
    datas[1] = 8'h38;
    datas[2] = 8'h0c;
    datas[3] = 8'h06;
    datas[4] = 8'h01;
    datas[5] = 8'hC0;
    datas[6] = 8'h31;
    datas[7] = 8'h32;
    datas[8] = 8'h33;
    datas[9] = 8'h34;
    datas[10] = 8'h35;
    datas[11] = 8'h36;
    datas[12] = 8'h37;
    datas[13] = 8'h38;
    datas[14] = 8'h39;
    datas[15] = 8'h41;
    datas[16] = 8'h42;
    datas[17] = 8'h43;
    datas[18] = 8'h44;
    datas[19] = 8'h45;
    datas[20] = 8'h47;
    datas[21] = 8'h48;
    datas[22] = 8'h49;
end

endmodule

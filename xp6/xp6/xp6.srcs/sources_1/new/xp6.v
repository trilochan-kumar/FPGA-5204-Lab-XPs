module xp6( 
  input wire clock, // Clock signal 
  output reg Buzzer_out // Buzzer output 
); 
parameter ONE_SECOND = 50000000; // One second duration (assuming 50 MHz clock) 
reg [31:0] i; // Counter variable

initial begin
    Buzzer_out = 1'b1;
    i = 32'b0;
end 
 
always @(posedge clock) begin 
  if (i == (2 * ONE_SECOND - 1)) begin 
    i <= 0; // Reset counter after 2 seconds 
    Buzzer_out <= 1'b1; // Buzzer off for 1 second 
  end else if (i == (ONE_SECOND - 1)) begin 
    i <= i + 1; // Increment counter 
    Buzzer_out <= 1'b0; // Buzzer on for 1 second 
  end else begin 
    i <= i + 1; // Increment counter 
    Buzzer_out <= Buzzer_out; // Keep buzzer state unchanged 
  end 
end 
endmodule 
//`timescale 1ns / 1ps

module xp_2a(
  input wire clk,  // Clock signal
  input wire [3:0] switches,  // Four slide switch inputs
  output reg [3:0] leds  // Four LED outputs
  );
  
  always @(posedge clk) begin
    leds <= switches; // Assign switch values to LEDs directly. 
    
   end

endmodule 

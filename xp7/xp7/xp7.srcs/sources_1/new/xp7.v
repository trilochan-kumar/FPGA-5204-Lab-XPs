module ldr_led_control( 
    input wire [11:0] ldr_input,   // Analog input from LDR 
    output reg led_output   // Output to control LED 
); 
 
// Define threshold for light intensity 
parameter LIGHT_THRESHOLD = 12'h025; // Adjust accordingly

initial begin
    led_output = 1'b0;
end
 
// Continuous assignment to control LED based on LDR input 
always @(posedge ldr_input) begin 
    if (ldr_input >= LIGHT_THRESHOLD) begin 
        // Turn on LED if light intensity is above threshold 
        led_output <= 1; 
    end else begin 
        // Turn off LED if light intensity is below threshold 
        led_output <= 0; 
    end 
 
end 
 
endmodule
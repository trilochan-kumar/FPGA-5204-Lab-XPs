module xp_2a(switch, push_button, led);
  input [3:0] switch;  // Four slide switch inputs
  input [1:0] push_button;
  output [3:0] led;  // Four LED outputs
  
  assign led[0] = switch[0] | push_button[0];
  assign led[1] = switch[1] | push_button[1];
  assign led[2] = switch[2];
  assign led[3] = switch[3];
  
endmodule
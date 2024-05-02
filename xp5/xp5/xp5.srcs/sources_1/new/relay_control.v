module relay_control(switch,relay);
    input [1:0] switch;
    output [1:0] relay;
       
    assign relay = ~switch;
    
endmodule
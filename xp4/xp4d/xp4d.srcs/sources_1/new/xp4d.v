module xp4d(clk,t,q,qb);
    input clk,t;
    output reg q;
    output qb;
    
    initial q = 0;
    
    always@(posedge clk)
    begin
        case(t)
            1'b0 : q = q;
            1'b1 : q = ~q;
        endcase
    end
    
    assign qb = ~q;
    
endmodule
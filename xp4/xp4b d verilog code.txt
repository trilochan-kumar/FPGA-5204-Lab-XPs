module xp4b(clk, d, q, qb);
    input clk;
    input d;
    output reg q;
    output qb;
    
    always@(posedge clk)
    begin
        q = d;
    end
    
    assign qb = ~q;
    
endmodule            
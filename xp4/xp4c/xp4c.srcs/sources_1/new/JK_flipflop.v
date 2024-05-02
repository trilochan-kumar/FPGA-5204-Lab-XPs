module JK_flipflop(clk,j,k,q,qb);
    
    input clk;
    input j,k;
    output reg q;
    output qb;
    
    always@(posedge clk)
    begin
        case({j,k})
            2'b00 : q = q;
            2'b01 : q = 0;
            2'b10 : q = 1;
            2'b11 : q = ~q;
        endcase
    end
    
    assign qb = ~q;

endmodule

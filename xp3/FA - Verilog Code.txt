module xp3b(A,B,C,Sum,Carry);
    input A,B,C;
    output Sum,Carry;
    
    assign Sum = A^B^C;
    assign Carry = (A&B) | (C&(A^B));
    
endmodule
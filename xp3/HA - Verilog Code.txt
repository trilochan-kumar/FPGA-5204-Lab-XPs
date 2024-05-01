module xp3a(A,B,Sum,Carry);
    input A,B;
    output Sum, Carry;
    
    assign Sum = A^B;
    assign Carry = A&B;
    
endmodule
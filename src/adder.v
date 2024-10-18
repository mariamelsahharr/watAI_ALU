module four_bit_adder (
    input wire [3:0] A,    // 4-bit input A
    input wire [3:0] B,    // 4-bit input B
    input wire C0,         // Carry input (C0)
    output wire [3:0] S,   // Sum outputs (S1, S2, S3, S4)
    output wire C4         // Carry output (C4)
);

    wire C1, C2, C3;  // Internal carry signals

    // Full adders for each bit
    full_adder fa0 (.A(A[0]), .B(B[0]), .Cin(C0), .Sum(S[0]), .Cout(C1));
    full_adder fa1 (.A(A[1]), .B(B[1]), .Cin(C1), .Sum(S[1]), .Cout(C2));
    full_adder fa2 (.A(A[2]), .B(B[2]), .Cin(C2), .Sum(S[2]), .Cout(C3));
    full_adder fa3 (.A(A[3]), .B(B[3]), .Cin(C3), .Sum(S[3]), .Cout(C4));

endmodule

// Full adder module
module full_adder (
    input wire A, B, Cin,
    output wire Sum, Cout
);
    // Sum and carry-out logic
    assign Sum = A ^ B ^ Cin;
    assign Cout = (A & B) | (A & Cin) | (B & Cin);
endmodule




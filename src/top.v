module top_level_alu (
    input wire [7:0] A,    // 8-bit input A
    input wire [7:0] B,    // 8-bit input B
    input wire CLK,        // Clock signal
    input wire CLR,        // Clear signal
    input wire SU,         // Control signal for subtract or add
    input wire FI,         // Flag input control
    input wire E0,         // Enable output signal
    output wire [7:0] BUS, // Output bus
    output wire CF,        // Carry flag output
    output wire ZF         // Zero flag output
);

    wire [3:0] S1, S2;     // Partial sum outputs for 4-bit adders
    wire C4;               // Carry output from first adder, input to the second adder
    wire [7:0] b_xor;    // Output of XOR operation
    wire [7:0] bus_out;    // Internal bus connection
    

    assign b_xor = {8{SU}}  ^ B;


       // Instantiate first 4-bit adder
    four_bit_adder adder1 (
        .A(A[3:0]),
        .B(b_xor[3:0]),
        .C0(SU),            // Use SU as a carry-in for addition or subtraction
        .S(S1),
        .C4(C4)             // Connect to C0 of the second adder
    );

    // Instantiate second 4-bit adder
    four_bit_adder adder2 (
        .A(A[7:4]),
        .B(b_xor[7:4]),
        .C0(C4),            // Connect C4 from the first adder
        .S(S2),
        .C4(CF)             // Carry out from second adder
    );
    
    // Combine outputs of two adders into one 8-bit bus
    assign BUS = {S2, S1};
    
    assign ZF = ((~(S1[0] | S1 [1])) && (~(S1[2]|S1[3]))) && ((~(S2[0] | S2 [1])) && (~(S2[2] | S2[3])));


    //had a bus module but the direction is always A->B since its connected to vcc, not needed as a module (i have it if we do want it but...)

    // Control output with E0 (Enable output signal)
    assign BUS = (E0) ? bus_out : 8'bz;  // High impedance when E0 is low (disabled)

    // Instantiate the register for flags, storing carry (CF) and zero (ZF)
    ls173_register flag_register (
        .clk(CLK),
        .reset(CLR),
        .D({CF, ZF}),      // CF connected to D0
        .E1(FI),          // E1 tied with E2, both driven by FID
        .E2(FI),
        .OE1(1'b0),        // Output enable tied to ground (active-low)
        .OE2(1'b0),        // Output enable tied to ground (active-low)
   
      .QZ({CF, ZF})
    );

endmodule
`include "adder.v"
`include "dreg.v"
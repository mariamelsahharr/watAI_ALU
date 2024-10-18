module ls173_register (
    input wire clk,           // Clock signal
    input wire reset,         // Reset signal
    input wire [1:0] D,       // 2-bit Data input
    input wire E1, E2,        // Data enable signals
    input wire OE1, OE2,      // Output enable signals
    output reg [1:0] QZ       // 3-state output
);
    reg [1:0] Q;  // Internal register, no longer an output

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 2'b00;  // Reset the register
        end else if (E1 && E2) begin
            Q <= D;  // Load data when both enable signals are high
        end
    end

    always @(*) begin
        if (!OE1 && !OE2) begin
            QZ = Q;  // Output enabled, pass data to QZ
        end else begin
            QZ = 2'bz;  // High impedance (3-state)
        end
    end
endmodule
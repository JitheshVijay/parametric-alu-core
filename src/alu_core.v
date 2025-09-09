module alu_core #(
    parameter WIDTH = 32
)(
    input wire [WIDTH-1:0] a,
    input wire [WIDTH-1:0] b,
    input wire [3:0] op,
    output reg [WIDTH-1:0] result,
    output reg zero,
    output reg overflow
);

    always @(*) begin
        case (op)
            4'b0000: result = a + b;        // ADD
            4'b0001: result = a - b;        // SUB
            4'b0010: result = a ^ b;        // XOR
            4'b0011: result = a | b;        // OR
            4'b0100: result = a & b;        // AND
            default: result = 0;
        endcase
        
        // Zero flag
        zero = (result == 0);
        
        // Overflow flag - only for arithmetic operations
        overflow = ((op == 4'b0000 || op == 4'b0001) &&
                   (a[WIDTH-1] == b[WIDTH-1]) &&
                   (result[WIDTH-1] != a[WIDTH-1]));
    end

endmodule
`timescale 1ns / 1ps

module alu_ctrl(
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output reg [3:0] op
);

    always @(*) begin
        case (funct3)
            // Arithmetic operations (funct3 = 000)
            3'b000: begin
                case (funct7)
                    7'b0000000: op = 4'b0000; // ADD
                    7'b0100000: op = 4'b0001; // SUB
                    default:    op = 4'b0000; // Default to ADD
                endcase
            end
            
            // Logical operations
            3'b100: op = 4'b0010; // XOR
            3'b110: op = 4'b0011; // OR
            3'b111: op = 4'b0100; // AND
            
            // Default case - no operation
            default: op = 4'b0000;
        endcase
    end

endmodule
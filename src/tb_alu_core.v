`timescale 1ns / 1ps

module tb_alu_core;
    reg [31:0] a, b;
    reg [3:0] op;
    wire [31:0] result;
    wire zero, overflow;
    
    alu_core alu_inst (.a(a), .b(b), .op(op), .result(result), .zero(zero), .overflow(overflow));
    
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_alu_core);
        
        // Test zero flag
        a = 5; b = -5; op = 4'b0001; #10;
        if (!zero) $error("Zero flag failed");
        
        // Test overflow: max + 1
        a = 32'h7FFFFFFF; b = 1; op = 4'b0000; #10;
        if (!overflow) $error("Overflow add failed");
        
        // Test overflow: min - 1
        a = 32'h80000000; b = 1; op = 4'b0001; #10;
        if (!overflow) $error("Overflow sub failed");
        
        $display("TEST_PASSED");
        $finish;
    end
    
endmodule
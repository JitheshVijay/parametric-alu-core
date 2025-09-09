`timescale 1ns / 1ps

module tb_alu_integ;
    // Testbench signals
    reg [31:0] a, b;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire [31:0] result;
    wire zero, overflow;
    wire [3:0] op;
    
    // Instantiate control decoder
    alu_ctrl ctrl_inst (
        .funct3(funct3),
        .funct7(funct7),
        .op(op)
    );
    
    // Instantiate ALU core
    alu_core alu_inst (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero),
        .overflow(overflow)
    );
    
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_alu_integ);
        
        $display("=== ALU Integration Testbench ===");
        
        // Test 1: ADD via funct3=000, funct7=0000000
        $display("Test 1: ADD operation");
        a = 32'h00000005;
        b = 32'h00000003;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        if (result !== 32'h00000008) begin
            $error("ADD test failed: expected 8, got %h", result);
        end else begin
            $display("✓ ADD test passed: %h + %h = %h", a, b, result);
        end
        
        // Test 2: SUB via funct3=000, funct7=0100000
        $display("Test 2: SUB operation");
        a = 32'h00000005;
        b = 32'h00000003;
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        #10;
        if (result !== 32'h00000002) begin
            $error("SUB test failed: expected 2, got %h", result);
        end else begin
            $display("✓ SUB test passed: %h - %h = %h", a, b, result);
        end
        
        // Test 3: AND via funct3=111
        $display("Test 3: AND operation");
        a = 32'hF0F0F0F0;
        b = 32'h0F0F0F0F;
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        #10;
        if (result !== 32'h00000000) begin
            $error("AND test failed: expected 0, got %h", result);
        end else begin
            $display("✓ AND test passed: %h & %h = %h", a, b, result);
        end
        
        // Test 4: OR via funct3=110
        $display("Test 4: OR operation");
        a = 32'hF0F0F0F0;
        b = 32'h0F0F0F0F;
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        #10;
        if (result !== 32'hFFFFFFFF) begin
            $error("OR test failed: expected FFFFFFFF, got %h", result);
        end else begin
            $display("✓ OR test passed: %h | %h = %h", a, b, result);
        end
        
        // Test 5: XOR via funct3=100
        $display("Test 5: XOR operation");
        a = 32'hF0F0F0F0;
        b = 32'h0F0F0F0F;
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        #10;
        if (result !== 32'hFFFFFFFF) begin
            $error("XOR test failed: expected FFFFFFFF, got %h", result);
        end else begin
            $display("✓ XOR test passed: %h ^ %h = %h", a, b, result);
        end
        
        // Test 6: Zero flag test
        $display("Test 6: Zero flag test");
        a = 32'h00000005;
        b = 32'hFFFFFFFB; // -5 in two's complement
        funct3 = 3'b000;
        funct7 = 7'b0000000; // ADD
        #10;
        if (!zero) begin
            $error("Zero flag test failed: expected zero=1, got zero=%b", zero);
        end else begin
            $display("✓ Zero flag test passed: %h + %h = %h, zero=%b", a, b, result, zero);
        end
        
        // Test 7: Overflow test
        $display("Test 7: Overflow test");
        a = 32'h7FFFFFFF; // Max positive
        b = 32'h00000001; // +1
        funct3 = 3'b000;
        funct7 = 7'b0000000; // ADD
        #10;
        if (!overflow) begin
            $error("Overflow test failed: expected overflow=1, got overflow=%b", overflow);
        end else begin
            $display("✓ Overflow test passed: %h + %h = %h, overflow=%b", a, b, result, overflow);
        end
        
        $display("=== All Integration Tests Completed ===");
        $display("TEST_PASSED");
        $finish;
    end

endmodule
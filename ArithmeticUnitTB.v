`timescale 1ns / 1ps

module ArithmeticUnit_tb;
    reg [7:0] a, b;
    reg [1:0] opcode;
    reg clk, rst, start;
    wire [1:0] op_select;
    wire [7:0] result;
    wire done;

    // Instanțiere Control Unit
    ControlUnit cu (
        .opcode(opcode),
        .op_select(op_select)
    );

    // Instanțiere ALU
    ArithmeticUnit au (
        .a(a), .b(b),
        .op_select(op_select),
        .clk(clk), .rst(rst), .start(start),
        .result(result), .done(done)
    );

    // Clock generator
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("==== START TEST ====");
        rst = 0; start = 0;
        a = 0; b = 0; opcode = 2'b00;

        #10 rst = 1;

        // Test ADD
        #10 a = 8'd12; b = 8'd5; opcode = 2'b00; start = 1;
        #10 start = 0;
        wait(done);
        $display("ADD: %0d + %0d = %0d", a, b, result);

        // Test SUB
        #10 a = 8'd20; b = 8'd7; opcode = 2'b01; start = 1;
        #10 start = 0;
        wait(done);
        $display("SUB: %0d - %0d = %0d", a, b, result);

        // Test DIV
        #10 a = 8'd40; b = 8'd5; opcode = 2'b10; start = 1;
        #10 start = 0;
        wait(done);
        $display("DIV: %0d / %0d = %0d", a, b, result);

        // Test MUL
        #10 a = 8'd6; b = 8'd7; opcode = 2'b11; start = 1;
        #10 start = 0;
        wait(done);
        $display("MUL: %0d * %0d = %0d", a, b, result);

        $display("==== END TEST ====");
        $stop;
    end
endmodule

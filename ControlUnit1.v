`timescale 1ns / 1ps

//Arithmetic Unit(AU)

module ArithmeticUnit(
    input [7:0] a, b,
    input [1:0] op_select,  // 00 = ADD, 01 = SUB, 10 = DIV, 11 = MUL
    output reg [7:0] result
);
    wire [7:0] sum_result, sub_result, div_result, mul_result;
    wire sum_cout, sum_ovr;
    wire sub_borrow;
    wire div_done;

    // Instanțierea modulelor pentru ADD, SUB, DIV, MUL
    rca8 adder (.x(a), .y(b), .c_in(1'b0), .z(sum_result), .c_out(sum_cout), .ovr(sum_ovr));
    fsc subtractor (.x(a), .y(b), .bin(1'b0), .b(sub_result), .bout(sub_borrow));
    restoring_div divider (.clk(1'b0), .rst(1'b1), .start(1'b1), .inbus1(a), .inbus2(b), .cat(div_result), .rest(), .done(div_done));
    radix4 multiplier (.inbus(a), .clk(1'b0), .outbus(mul_result)); // Instanțiere pentru multiplicare

    always @(*) begin
        case(op_select)
            2'b00: result = sum_result;  // ADD
            2'b01: result = sub_result;  // SUB
            2'b10: result = div_result;  // DIV
            2'b11: result = mul_result;  // MUL
            default: result = 8'd0;
        endcase
    end
endmodule


//Control Unit(CU)

module ControlUnit(
    input [1:0] opcode, // 00 = ADD, 01 = SUB, 10 = DIV
    output reg [1:0] op_select
);
    always @(*) begin
        case(opcode)
            2'b00: op_select = 2'b00; // ADD
            2'b01: op_select = 2'b01; // SUB
            2'b10: op_select = 2'b10; // DIV
            default: op_select = 2'b00;
        endcase
    end
endmodule

//Multiplexer(MUX2to1)

module MUX2to1(
    input [7:0] in0, in1,
    input sel,
    output [7:0] out
);
    assign out = sel ? in1 : in0;
endmodule


//Register(8-bit Register)

module Register8(
    input clk, rst,
    input [7:0] d,
    output reg [7:0] q
);
    always @(posedge clk or negedge rst) begin
        if (!rst) q <= 8'd0;
        else q <= d;
    end
endmodule



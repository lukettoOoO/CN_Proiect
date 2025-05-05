`timescale 1ns / 1ps

// ---------------- FULL ADDER ----------------
module fac (
    input x, y, c_in,
    output z, c_out
);
    assign z = x ^ y ^ c_in;
    assign c_out = (x & y) | (x & c_in) | (y & c_in);
endmodule

// ---------------- SUBTRACTOR ----------------
module fsc(
    input [7:0] x, y,
    input bin,
    output [7:0] b,
    output bout
);
    wire [7:0] borrow;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : sub
            if (i == 0) begin
                assign b[i] = x[i] ^ y[i] ^ bin;
                assign borrow[i] = (~x[i] & y[i]) | ((~x[i] | y[i]) & bin);
            end else begin
                assign b[i] = x[i] ^ y[i] ^ borrow[i-1];
                assign borrow[i] = (~x[i] & y[i]) | ((~x[i] | y[i]) & borrow[i-1]);
            end
        end
    endgenerate
    assign bout = borrow[7];
endmodule

// ---------------- MULTIPLIER ----------------
module radix4 (
    input [7:0] inbus1,
    input [7:0] inbus2,
    input clk,
    output reg [7:0] outbus
);
    always @(posedge clk) begin
        outbus <= inbus1 * inbus2;
    end
endmodule

// ---------------- DIVIDER ----------------
module restoring_div(
    input clk, rst, start,
    input [7:0] inbus1, inbus2,
    output reg [7:0] cat, rest,
    output reg done
);
    reg [7:0] a, q, m;
    reg [3:0] count;
    reg [15:0] tmp;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            a <= 0; q <= 0; m <= 0; count <= 0; done <= 0;
        end else if (start) begin
            a <= 0; q <= inbus1; m <= inbus2; count <= 8; done <= 0;
        end else if (count != 0) begin
            tmp = {a, q};
            tmp = tmp << 1;
            a = tmp[15:8] - m;
            q = tmp[7:0];
            q[0] = ~a[7];
            if (a[7]) a = a + m;
            count = count - 1;
            if (count == 1) begin
                cat <= q;
                rest <= a;
                done <= 1;
            end
        end
    end
endmodule

// ---------------- ARITHMETIC UNIT ----------------
module ArithmeticUnit(
    input [7:0] a, b,
    input [1:0] op_select,
    input clk, rst, start,
    output reg [7:0] result,
    output reg done
);
    wire [7:0] sum_result, sub_result, div_result, mul_result;
    wire div_done;

    rca8 adder (.x(a), .y(b), .c_in(1'b0), .z(sum_result), .c_out(), .ovr());
    fsc subtractor (.x(a), .y(b), .bin(1'b0), .b(sub_result), .bout());
    restoring_div divider (.clk(clk), .rst(rst), .start(start), .inbus1(a), .inbus2(b), .cat(div_result), .rest(), .done(div_done));
    radix4 multiplier (.inbus1(a), .inbus2(b), .clk(clk), .outbus(mul_result));

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            result <= 0;
            done <= 0;
        end else begin
            case(op_select)
                2'b00: begin result <= sum_result; done <= 1; end
                2'b01: begin result <= sub_result; done <= 1; end
                2'b10: begin
                    if (div_done) begin result <= div_result; done <= 1; end
                    else done <= 0;
                end
                2'b11: begin result <= mul_result; done <= 1; end
                default: begin result <= 0; done <= 1; end
            endcase
        end
    end
endmodule

// ---------------- CONTROL UNIT ----------------
module ControlUnit(
    input [1:0] opcode,
    output reg [1:0] op_select
);
    always @(*) begin
        case(opcode)
            2'b00: op_select = 2'b00;
            2'b01: op_select = 2'b01;
            2'b10: op_select = 2'b10;
            2'b11: op_select = 2'b11;
            default: op_select = 2'b00;
        endcase
    end
endmodule

// ---------------- REGISTER ----------------
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

// ---------------- RCA8 (Optional, dacă e cerut) ----------------
module rca8 (
    input [7:0] x, y,
    input c_in,
    output [7:0] z,
    output c_out, ovr
);
    wire [8:0] c;
    assign c[0] = c_in;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            fac f (.x(x[i]), .y(y[i]), .c_in(c[i]), .z(z[i]), .c_out(c[i+1]));
        end
    endgenerate

    assign c_out = c[8];
    assign ovr = c[7] ^ c[8];
endmodule

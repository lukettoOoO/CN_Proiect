`timescale 1ns / 1ps

module top_tb;
    reg [7:0] a, b;       // Intrările pentru a și b
    reg [1:0] opcode;     // Opcode pentru control (00 = ADD, 01 = SUB, 10 = DIV)
    wire [7:0] alu_result; // Rezultatul operației aritmetice
    wire [7:0] mux_out;    // Rezultatul final selectat de MUX
    reg clk, rst;
    wire [1:0] op_select;  // Semnal de selecție pentru operație

    // Instanțierea ControlUnit-ului
    ControlUnit cu (.opcode(opcode), .op_select(op_select));
    
    // Instanțierea ArithmeticUnit-ului
    ArithmeticUnit au (.a(a), .b(b), .op_select(op_select), .result(alu_result));
    
    // Instanțierea MUX-ului pentru selectarea rezultatului final
    MUX2to1 mux (.in0(alu_result), .in1(8'd0), .sel(1'b1), .out(mux_out)); // Se poate schimba selecția în funcție de necesități

    // Instanțierea Register8 pentru stocarea rezultatului final
    Register8 reg_out (.clk(clk), .rst(rst), .d(mux_out), .q(mux_out));

    localparam CLK_PERIOD = 20; // Perioada clk-ului
    always #(CLK_PERIOD/2) clk = ~clk;  // Generarea semnalului de clk

    initial begin
        // Inițializare clk și reset
        clk = 0;
        rst = 0;
        #15 rst = 1;  // Activăm resetul
        @(posedge clk); // Sincronizare cu clk
        
        // Test adunare
        a = 8'd10;  // Setăm valoarea pentru a (de exemplu 10)
        b = 8'd5;   // Setăm valoarea pentru b (de exemplu 5)
        opcode = 2'b00; // Operație ADD
        @(posedge clk);
        #5 $display("%0d + %0d = %0d", a, b, mux_out);

        // Test scădere
        a = 8'd20;  // Setăm valoarea pentru a (de exemplu 20)
        b = 8'd10;  // Setăm valoarea pentru b (de exemplu 10)
        opcode = 2'b01; // Operație SUB
        @(posedge clk);
        #5 $display("%0d - %0d = %0d", a, b, mux_out);

        // Test divizare
        
        a = 8'd40;  // Setăm valoarea pentru a (de exemplu 40)
        b = 8'd8;   // Setăm valoarea pentru b (de exemplu 8)
        opcode = 2'b10; // Operație DIV
        @(posedge clk);
        #5 $display("%0d / %0d = %0d", a, b, mux_out);

        $stop;
    end
endmodule

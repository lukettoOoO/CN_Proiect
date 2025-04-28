module all_operations_tb;

  reg [7:0] a, b;
  reg [1:0] opcode; // Control pentru operație
  wire [7:0] result;  // Rezultatul operației aritmetice
  wire [7:0] mux_out;
  reg clk, rst;
  wire [1:0] op_select;  // Semnal de selecție pentru operație

  // Instanțierea ControlUnit-ului
  ControlUnit cu (.opcode(opcode), .op_select(op_select));
  
  // Instanțierea ArithmeticUnit-ului
  ArithmeticUnit au (.a(a), .b(b), .op_select(op_select), .result(result));
  
  // Instanțierea MUX-ului pentru selectarea rezultatului final
  MUX2to1 mux (.in0(result), .in1(8'd0), .sel(1'b1), .out(mux_out)); 

  // Instanțierea Register8 pentru stocarea rezultatului final
  Register8 reg_out (.clk(clk), .rst(rst), .d(mux_out), .q(mux_out));

  localparam CLK_PERIOD = 20; // Perioada clk
  always #(CLK_PERIOD/2) clk = ~clk;

  initial begin
    clk = 0;
    rst = 0;
    #15 rst = 1;  // Activăm resetul
    @(posedge clk); // Sincronizare cu clk
    
    // Teste pentru ADD, SUB, DIV, MUL
    // Test 1: Adunare
    a = 8'd5; b = 8'd3; opcode = 2'b00;  // ADD
    #10;
    $display("%0d + %0d = %0d", a, b, mux_out);

    // Test 2: Scădere
    a = 8'd8; b = 8'd3; opcode = 2'b01;  // SUB
    #10;
    $display("%0d - %0d = %0d", a, b, mux_out);

    // Test 3: Divizare
    a = 8'd40; b = 8'd8; opcode = 2'b10;  // DIV
    #10;
    $display("%0d / %0d = %0d", a, b, mux_out);

    // Test 4: Multiplicare
    a = 8'd6; b = 8'd7; opcode = 2'b11;  // MUL
    #10;
    $display("%0d * %0d = %0d", a, b, mux_out);

    $stop;
  end

endmodule

module all_operations_tb;

  reg [7:0] a, b;
  reg [1:0] opcode; // Control pentru operatie
  wire [7:0] result;  
  wire [7:0] mux_out;
  wire [7:0] reg_q; // iesire din registru
  reg clk, rst;
  wire [1:0] op_select;  

  // Instantierea ControlUnit-ului
  ControlUnit cu (.opcode(opcode), .op_select(op_select));
  
  // Instantierea ArithmeticUnit-ului
  ArithmeticUnit au (.a(a), .b(b), .op_select(op_select), .result(result));
  
  // Instantierea MUX-ului pentru selectarea rezultatului final
  MUX2to1 mux (.in0(result), .in1(8'd0), .sel(1'b1), .out(mux_out)); 

  // Instantierea Register8 pentru stocarea rezultatului final
  Register8 reg_out (.clk(clk), .rst(rst), .d(mux_out), .q(reg_q));

  localparam CLK_PERIOD = 20;
  always #(CLK_PERIOD/2) clk = ~clk;

  initial begin
    clk = 0;
    rst = 0;
    #15 rst = 1;  
    @(posedge clk); 
    
    // Teste pentru ADD, SUB, DIV, MUL
    // Test 1: Adunare
    a = 8'd5; b = 8'd3; opcode = 2'b00;  
    #10;
    $display("%0d + %0d = %0d", a, b, reg_q);

    // Test 2: Scadere
    a = 8'd8; b = 8'd3; opcode = 2'b01;  
    #10;
    $display("%0d - %0d = %0d", a, b, reg_q);

    // Test 3: Divizare
    a = 8'd40; b = 8'd8; opcode = 2'b10;  
    #10;
    $display("%0d / %0d = %0d", a, b, reg_q);

    // Test 4: Multiplicare
    a = 8'd6; b = 8'd7; opcode = 2'b11;  
    #10;
    $display("%0d * %0d = %0d", a, b, reg_q);

    $stop;
  end

endmodule

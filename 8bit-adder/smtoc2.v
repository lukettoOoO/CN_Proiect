module smtoc2 (
  input [7:0] x, y,
  output reg [7:0] x_c2, y_c2
);

  wire [7:0] x_c1, y_c1;
  wire x_sign, y_sign;
  
  assign x_sign = x[7];
  assign y_sign = y[7];
  
  assign x_c1 = ~x;
  assign y_c1 = ~y;

  always @(*) begin
    if (x_sign) begin
        x_c2 = x_c1 + 1;
    end else begin
        x_c2 = x;
    end
        
    if (y_sign) begin
        y_c2 = y_c1 + 1;
    end else begin
        y_c2 = y;
    end
  end
  
endmodule
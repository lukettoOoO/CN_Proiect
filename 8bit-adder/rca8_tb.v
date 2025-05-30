module rca8_tb;
  reg [7:0] x, y;
  reg c_in;
  wire [7:0] z;
  wire c_out;
  wire ovr;
  
  rca8 inst (
    .x(x),
    .y(y),
    .c_in(c_in),
    .z(z),
    .c_out(c_out),
    .ovr(ovr)
  );
  
  initial begin
    x = 8'b00001111;  //15
    y = 8'b00000001;  //1
    c_in = 0;
    #10;
    
    x = 8'b01111111; //127
    y = 8'b00000001; //1
    c_in = 0;
    #10;

    x = 8'b00101011; //43
    y = 8'b00000000; //0
    c_in = 0;
    #10;

    x = 8'b10000011; //-3
    y = 8'b11111011; //-123
    c_in = 0;
    #10;
    
    x = 8'b10000011; //-3
    y = 8'b00000010; //2
    c_in = 0;
    #10;
    
    x = 8'b00000010; //2
    y = 8'b10000011; //3
    c_in = 0;
    #10;
    
  end
  
endmodule
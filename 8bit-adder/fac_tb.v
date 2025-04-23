module fac_tb;
  
  reg x, y, c_in;
  wire z, c_out;
  
  fac inst (
    .x(x),
    .y(y),
    .c_in(c_in),
    .z(z),
    .c_out(c_out)
  );
  
  integer i;
  initial begin
    {x, y, c_in} = 0;
    for(i = 1; i < 8; i = i + 1)
      #20 {x, y, c_in} = i;
    #20;
  end

endmodule
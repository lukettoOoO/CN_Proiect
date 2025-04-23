module rca8 (
    input [7:0] x, y,
    input c_in,
    output [7:0] z,
    output c_out, ovr
);

  wire [8:0] c;
  wire [7:0] z_sm;
  wire [7:0] x_c2, y_c2, z_c2;
  
  //sm to c2
  smtoc2 smtoc2_inst (
    .x(x), .y(y), .x_c2(x_c2), .y_c2(y_c2)
  );
  
  assign c[0] = c_in;
  
  //adder
  generate
    genvar i;
    for(i = 0; i < 8; i = i + 1) begin : fac_generate
      fac fac_inst (
        .x(x_c2[i]), .y(y_c2[i]), .c_in(c[i]), .z(z_c2[i]), .c_out(c[i+1])
      );
    end
  endgenerate
  
  //carry out
  assign c_out = c[7];
  
  // overflow
  assign ovr = (x_c2[7] == y_c2[7]) && (z_c2[7] != x_c2[7]);
  
  //c2 to sm
  c2tosm c2tosm_inst (
    .x(x),
    .y(y),
    .z(z_c2),
    .sm(z_sm)
  );
  assign z = z_sm;

endmodule
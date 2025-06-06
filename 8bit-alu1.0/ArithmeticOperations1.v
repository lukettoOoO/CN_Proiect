`timescale 1ns / 1ps

// Adder (RCA8) și modul FAC

module fac (
    input x, y, c_in,
    output z, c_out
);
    assign z = x ^ y ^ c_in;
    assign c_out = (x & y) | (x & c_in) | (y & c_in);
endmodule

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
        if (x_sign)
            x_c2 = x_c1 + 1;
        else
            x_c2 = x;
        
        if (y_sign)
            y_c2 = y_c1 + 1;
        else
            y_c2 = y;
    end
endmodule

module c2tosm (
    input [7:0] x, y, z,
    output reg [7:0] sm
);
    always @(*) begin
        if (z[7] == 1 || ((x[7] != y[7]) && z[7] == 0)) begin
            sm = ~z + 1;
            sm[7] = 1;
        end else begin
            sm = z;
        end
    end
endmodule

module rca8 (
    input [7:0] x, y,
    input c_in,
    output [7:0] z,
    output c_out, ovr
);
    wire [8:0] c;
    wire [7:0] z_sm;
    wire [7:0] x_c2, y_c2, z_c2;
    
    smtoc2 smtoc2_inst (.x(x), .y(y), .x_c2(x_c2), .y_c2(y_c2));
    assign c[0] = c_in;
    
    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : fac_generate
            fac fac_inst (.x(x_c2[i]), .y(y_c2[i]), .c_in(c[i]), .z(z_c2[i]), .c_out(c[i+1]));
        end
    endgenerate
    
    assign c_out = c[7];
    assign ovr = (x_c2[7] == y_c2[7]) && (z_c2[7] != x_c2[7]);
    
    c2tosm c2tosm_inst (.x(x), .y(y), .z(z_c2), .sm(z_sm));
    assign z = z_sm;
endmodule

// Subtractor (FSC)

module fsc(
  input [7:0] x, y,
  input bin,
  output [7:0] b,
  output bout
);
  wire [7:0] borrow;
  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : scazator
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

// Divider (Restoring Division)

module define_sign(
input signed [7:0] inbus1,inbus2,
output sign1,sign2,
output [7:0] abs1,abs2
);
assign sign1 = inbus1[7];
assign sign2 = inbus2[7];
assign abs1 = sign1 ? (~inbus1 + 1'b1) : inbus1;
assign abs2 = sign2 ? (~inbus2 + 1'b1) : inbus2;
endmodule

module parallel_adder(
    input [7:0] A,
    input [7:0] B,
    input cin,
    output cout,
    output [7:0] Sum
);
    wire [8:0] carry;
    assign carry[0] = cin;

    fac fac_0 (.x(A[0]), .y(B[0]), .c_in(carry[0]), .z(Sum[0]), .c_out(carry[1]));
    fac fac_1 (.x(A[1]), .y(B[1]), .c_in(carry[1]), .z(Sum[1]), .c_out(carry[2]));
    fac fac_2 (.x(A[2]), .y(B[2]), .c_in(carry[2]), .z(Sum[2]), .c_out(carry[3]));
    fac fac_3 (.x(A[3]), .y(B[3]), .c_in(carry[3]), .z(Sum[3]), .c_out(carry[4]));
    fac fac_4 (.x(A[4]), .y(B[4]), .c_in(carry[4]), .z(Sum[4]), .c_out(carry[5]));
    fac fac_5 (.x(A[5]), .y(B[5]), .c_in(carry[5]), .z(Sum[5]), .c_out(carry[6]));
    fac fac_6 (.x(A[6]), .y(B[6]), .c_in(carry[6]), .z(Sum[6]), .c_out(carry[7]));
    fac fac_7 (.x(A[7]), .y(B[7]), .c_in(carry[7]), .z(Sum[7]), .c_out(carry[8]));
endmodule

module restoring_div(
  input clk, rst, start,
  input [7:0] inbus1, inbus2,
  output [7:0] cat, rest,
  output done
);
  reg busy, busy_d;
  reg [3:0] count;
  reg [7:0] inbus1_reg, inbus2_reg, a, q, shift_a, shift_q;
  wire [7:0] sum;
  wire restore_a;
  wire finish;
  wire q_lsb;

  assign restore_a = sum[7];
  assign q_lsb = !restore_a;
  assign finish = (count == 4'h7);
  assign cat = q;
  assign rest = a;
  assign done = (!busy) && (busy_d);
  
  reg [7:0] complement_reg;
  always @(posedge clk or negedge rst) begin
    if (!rst)
      complement_reg <= 8'h0;
    else if (start)
      complement_reg <= ~inbus2 + 8'b1;
  end
  
  parallel_adder u_parallel_adder(
    .A(shift_a),
    .B(complement_reg),
    .cin(1'b0),
    .Sum(sum),
    .cout()
  );

  always @(posedge clk or negedge rst) begin
    if (!rst)
      busy <= 1'b0;
    else if (start)
      busy <= 1'b1;
    else if (finish)
      busy <= 1'b0;
  end

  always @(posedge clk or negedge rst) begin
    if (!rst)
      busy_d <= 1'b0;
    else
      busy_d <= busy;
  end

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      inbus1_reg <= 8'h0;
      inbus2_reg <= 8'h0;
    end else if (start) begin
      inbus1_reg <= inbus1;
      inbus2_reg <= inbus2;
    end
  end

  always @(posedge clk or negedge rst) begin
    if (!rst)
      count <= 4'h7;
    else if (start)
      count <= 4'h0;
    else if (busy)
      count <= count + 4'h1;
  end

  always @(*) begin
    if (busy)
      {shift_a, shift_q} <= {a, q} << 1;
    else
      {shift_a, shift_q} <= {8'h0, 8'h0};
  end

  always @(posedge clk or negedge rst) begin
    if (!rst)
      {a, q} <= {8'h0, 8'h0};
    else if (start)
      {a, q} <= {8'h0, inbus1};
    else if (busy) begin
      if (restore_a)
        {a, q} <= {shift_a, q[6:0], q_lsb};
      else
        {a, q} <= {sum, q[6:0], q_lsb};
    end
  end
endmodule

// Multiplicator (Radix4)
module radix4 (
    input [7:0] inbus,    
    input clk,            
    input rst,             
    input start,           
    output reg [15:0] outbus,  
    output reg done        
);
    reg [8:0] a;         
    reg [7:0] m;         
    reg [7:0] q;          
    reg q_neg;            
    reg [2:0] count;     

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a <= 9'b0;
            m <= inbus;
            q <= 8'b0;
            count <= 0;
            outbus <= 16'b0;
            done <= 0;
            q_neg <= 0;
        end else if (start) begin
            a <= 9'b0;
            m <= inbus;
            q <= 8'b0;
            count <= 0;
            outbus <= 16'b0;
            done <= 0;
            q_neg <= 0;
        end else if (count < 4) begin
            case ({q[1:0], q_neg})
                3'b001: a <= a + m;
                3'b010: a <= a + m;
                3'b011: a <= a + (m << 1);
                3'b100: a <= a - (m << 1);
                3'b101: a <= a - m;
                3'b110: a <= a - m;
                3'b111: a <= a + m;
                default: ;
            endcase

            {a[8], q[7:1]} <= {a[8], q[7:1], a[8]};
            q_neg <= q[0];
            count <= count + 1;

            if (count == 3) begin
                outbus <= {a[8:0], q};
                done <= 1;
            end
        end
    end
endmodule


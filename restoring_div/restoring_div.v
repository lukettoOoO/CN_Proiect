module restoring_div(
  input clk,rst,start,
  input [7:0] inbus1, inbus2,
  output [7:0] cat, rest,
  output done
);

  reg busy;
  reg busy_d;
  reg [3:0] count;
  reg [7:0] inbus1_reg;
  reg [7:0] inbus2_reg;

  reg [7:0] a;
  reg [7:0] q;
  reg [7:0] shift_a;
  reg [7:0] shift_q;

  wire [7:0] sum;
  wire restore_a;
  wire finish;
  wire q_lsb;

  assign restore_a = sum[7]; // MSB = semnul rezultatului: 1 = negativ restauram
  assign q_lsb = !(restore_a); // daca nu restauram, atunci Q[i] = 1
  assign finish = (count == 4'h7);

  assign cat = q;
  assign rest = a;
  assign done = (!busy) && (busy_d);
  
  reg [7:0] complement_reg;
  always @(posedge clk or negedge rst) begin
    if (!rst)
      complement_reg <= 8'h0;
    else if (start)
      complement_reg <= ~inbus2 + 8'b00000001;
  end
  
  parallel_adder u_parallel_adder(
    .A(shift_a),
    .B(complement_reg),
    .cin(1'b0),
    .Sum(sum),
    .cout()
  );

  // Starea de ocupare
  always @(posedge clk or negedge rst) begin
    if (!rst)
      busy <= 1'b0;
    else if (start)
      busy <= 1'b1;
    else if (finish)
      busy <= 1'b0;
    else
      busy <= busy;
  end

  // Retinere stare anterioara
  always @(posedge clk or negedge rst) begin
    if (!rst)
      busy_d <= 1'b0;
    else
      busy_d <= busy;
  end

  // Retinere date la început
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      inbus1_reg <= 8'h0;
      inbus2_reg <= 8'h0;
    end
    else if (start) begin
      inbus1_reg <= inbus1;
      inbus2_reg <= inbus2;
    end
    else if(busy) begin
      inbus1_reg<=inbus1_reg;
      inbus2_reg<=inbus2_reg;
    end
    else begin
      inbus1_reg<=8'h0;
      inbus2_reg<=8'h0;
    end
end

  // Numaratoare cicluri
  always @(posedge clk or negedge rst) begin
    if (!rst)
      count <= 4'h7;
    else if (start)
      count <= 4'h0;
    else if (busy)
      count <= count + 4'h1;
    else
      count<=count;
  end

  always @(*) begin
    if(busy)
      {shift_a,shift_q}<={a,q}<<1;
    else
      {shift_a,shift_q}<={8'h0,8'h0};
  end


  // Logica principala de divizare
  //In loc de A+M am folosit ce era deja stocat in shift_a care are stocat ce era inainte
  always @(posedge clk or negedge rst) begin
    if (!rst)
      {a, q} <= {8'h0, 8'h0};
    else if (start)
      {a, q} <= {8'h0, inbus1}; // incepem cu rest = 0 si cât = src1
    else if (busy) begin
      if (restore_a)
        {a, q} <= {shift_a, q[6:0], q_lsb}; // restauram acc
      else
        {a, q} <= {sum, q[6:0], q_lsb}; // pastram acc-ul nou (scazut)
    end
    else
      {a,q}<={a,q};
      end

endmodule
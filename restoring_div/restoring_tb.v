module restoring_tb;

  reg clk;
  reg rst;
  reg start;
  reg signed [7:0] inbus1;
  reg signed [7:0] inbus2;
  wire signed [7:0] abs1,abs2;
  wire sign1,sign2;
  wire signed [7:0] cat;
  wire [7:0] rest;
  wire done;
 
 localparam CLK_PERIOD=20;
 localparam CYCLE_HALF=CLK_PERIOD/2;
 
 define_sign u_define_sign(
  .inbus1(inbus1),
  .inbus2(inbus2),
  .abs1(abs1),
  .abs2(abs2),
  .sign1(sign1),
  .sign2(sign2)
 );
 
 
  restoring_div uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .inbus1(abs1),
    .inbus2(abs2),
    .cat(cat),
    .rest(rest),
    .done(done)
  );
  task restoring_division;
    input signed [7:0] s1;
    input signed [7:0] s2;
    reg signed [7:0] real_cat;
    reg signed [7:0] real_rest;
    begin
      start=1'b1;
      inbus1=s1;
      inbus2=s2;
      @(posedge clk);
      
      start=1'b0;
      @(posedge clk);
      
      while(!done) begin
        @(posedge clk);
      end
      real_cat = (sign1 ^ sign2) ? (~cat + 1'b1) : cat;
      real_rest = sign1 ? (~rest + 1'b1) : rest;

  $display("cat: %d, rest: %d", real_cat, real_rest);
  end
endtask

initial begin
  clk=1'b0;
  rst=1'b0;
  #14; rst=1'b1;
end

always #(CYCLE_HALF) clk=~clk;

initial begin
  wait(rst);
  @(posedge clk);
  restoring_division(-49,-3);
  restoring_division(49,-3);
  restoring_division(59,4);
end
endmodule
  
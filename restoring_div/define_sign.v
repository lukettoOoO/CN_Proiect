module define_sign(
input signed [7:0] inbus1,inbus2,
output sign1,sign2,
output [7:0] abs1,abs2
);

assign sign1=inbus1[7];
assign sign2=inbus2[7];
assign abs1=sign1 ? (~inbus1+1'b1) : inbus1;
assign abs2=sign2 ? (~inbus2+1'b1) : inbus2;

endmodule
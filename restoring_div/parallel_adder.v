

module parallel_adder(
    input [7:0] A,
    input [7:0] B,
    input cin,
    output cout,
    output [7:0] Sum
);
  
    wire [8:0] carry; 

    assign carry[0] = cin; 
    
    fac fac_0 (.x(A[0]), .y(B[0]), .ci(carry[0]), .z(Sum[0]), .co(carry[1]));
    fac fac_1 (.x(A[1]), .y(B[1]), .ci(carry[1]), .z(Sum[1]), .co(carry[2]));
    fac fac_2 (.x(A[2]), .y(B[2]), .ci(carry[2]), .z(Sum[2]), .co(carry[3]));
    fac fac_3 (.x(A[3]), .y(B[3]), .ci(carry[3]), .z(Sum[3]), .co(carry[4]));
    fac fac_4 (.x(A[4]), .y(B[4]), .ci(carry[4]), .z(Sum[4]), .co(carry[5]));
    fac fac_5 (.x(A[5]), .y(B[5]), .ci(carry[5]), .z(Sum[5]), .co(carry[6]));
    fac fac_6 (.x(A[6]), .y(B[6]), .ci(carry[6]), .z(Sum[6]), .co(carry[7]));
    fac fac_7 (.x(A[7]), .y(B[7]), .ci(carry[7]), .z(Sum[7]), .co(carry[8]));
    //fac fac_8 (.x(A[8]), .y(B[8]), .ci(carry[8]), .z(Sum[8]), .co(cout)); 

endmodule

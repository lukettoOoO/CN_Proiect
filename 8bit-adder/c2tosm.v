module c2tosm(
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
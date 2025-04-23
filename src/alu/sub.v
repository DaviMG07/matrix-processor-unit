module sub(
  input  [199:0] matrix_a,
  input  [199:0] matrix_b,
  output [199:0] matrix_c
);

genvar i;
generate
  for (i = 0; i < 25; i = i + 1) begin : matrix_sub
    assign matrix_c[i*8 +: 8] = $signed(matrix_a[i*8 +: 8]) - $signed(matrix_b[i*8 +: 8]);
  end
endgenerate

endmodule

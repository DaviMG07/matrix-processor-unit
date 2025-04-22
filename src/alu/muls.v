module muls(
  input  [199:0] matrix_a,
  input  [7:0]   scalar,
  output [199:0] matrix_c
);

genvar i;
generate
  for (i = 0; i < 25; i = i + 1) begin : matrix_muls
    assign matrix_c[i*8 +: 8] = $signed(matrix_a[i*8 +: 8]) * $signed(scalar);
  end
endgenerate

endmodule

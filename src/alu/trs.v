`define at(row, col) (8 * (col + 5*row))

module trs(
  input  [199:0] matrix_a,
  output [199:0] matrix_c
);

genvar i, j;
generate
  for (i = 0; i < 5; i = i + 1) begin : matrix_trs_row
    for (j = 0; j < 5; j = j + 1) begin : matrix_trs_col
      assign matrix_c[`at(i, j)] = matrix_a[`at(j, i)];
    end 
  end
endgenerate

endmodule

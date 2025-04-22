module opp(
  input  [199:0] matrix_a,
  output [199:0] matrix_c
);

muls muls_opp (
  matrix_a,
  -8'd1,
  matrix_c
);

endmodule

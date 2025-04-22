module alu(
  input          clock,
  input          start,
  input  [3:0]   op_code,
  input  [199:0] matrix_a,
  input  [199:0] matrix_b,
  output         done,
  output reg [199:0] matrix_c
);

parameter ADD  = 4'd0,
          SUB  = 4'd1,
          MUL  = 4'd2,
          MULS = 4'd3,
          OPP  = 4'd4,
          TRS  = 4'd5;

wire [199:0] add_m, sub_m, mul_m, muls_m, opp_m, trs_m;
add add_op (
  matrix_a,
  matrix_b,
  add_m
);

sub sub_op (
  matrix_a,
  matrix_b,
  sub_m
);

mul mul_op (
  clock,
  start,
  matrix_a,
  matrix_b,
  mul_m,
  mul_done
);

muls muls_op (
  matrix_a,
  matrix_b[199 +: 8],
  muls_m
);

opp opp_op (
  matrix_a,
  opp_m
);

trs trs_op (
  matrix_a,
  trs_m
);

assign done = (op_code == MUL) ? mul_done : 1;

always @(*) begin
  case (op_code)
    ADD: begin
      matrix_c <= add_m;
    end
    SUB: begin
      matrix_c <= sub_m;
    end
    MUL: begin
      matrix_c <= mul_m;
    end
    MULS: begin
      matrix_c <= muls_m;
    end
    OPP: begin
      matrix_c <= opp_m;
    end
    TRS: begin
      matrix_c <= trs_m;
    end
    default: begin
      matrix_c <= 0;
    end
  default: begin
    

  end
  endcase
end

endmodule

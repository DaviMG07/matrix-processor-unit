module decoder(
  input  [31:0] instruction,
  output [3:0]  op_code,
  output [1:0]  id,
  output [2:0]  row,
  output [2:0]  col,
  output [4:0]  index,
  output [5:0]  address,
  output [15:0] values
);

assign op_code = instruction[31:28];
assign id      = instruction[27:26];
assign row     = instruction[25:23];
assign col     = instruction[22:20];

assign index   = (8 * (col + 5*row));
assign address = id*13 + index;

assign values  = instruction[19:4];

endmodule

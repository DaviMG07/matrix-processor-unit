module memory(
  input   [5:0] address,
  input         clock,
  input  [15:0] data_in,
  input         write_enabled,
  output [15:0] data_out
);

reg [15:0] words [63:0];

assign data_out = words[address];

always @(posedge clock) begin
  if (write_enabled) 
    words[address] <= data_in;
end

endmodule

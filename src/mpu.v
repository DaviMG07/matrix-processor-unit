module mpu(
  input         clock,
  input  [31:0] instruction_in,
  input         receive,
  output [15:0] data_out,
  output        send
);

reg [31:0] instruction;

buffer_in bi_instance (
  clock,
  bi_start,
  bi_id,
  bi_index,
  bi_value,
  matrix_a,
  matrix_b,
  bi_done
);

alu alu_instance (
  clock,
  alu_start,
  op_code,
  matrix_a,
  matrix_b,
  matrix_c,
  alu_done
);

buffer_out bo_instance (
  clock,
  bo_start,
  bo_index,
  bo_matrix,
  bo_value,
  bo_done
);

control_unit control_instance (
  clock,
  instruction,
  bi_done,
  bi_id,
  bi_index,
  bi_start,
  bo_done,
  bo_index,
  bo_start,
  alu_start,
  op_code,
  alu_done,
  mem_start,
  mem_address,
  mem_write_enabled,
  mem_done
);

mmu mmu_instance (
  clock,
  mem_start,
  mem_address,
  mem_data_in,
  mem_write_enabled,
  mem_data_out,
  mem_done
);

always @(posedge receive) begin
  instruction <= instruction_in;
end

endmodule

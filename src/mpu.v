
module mpu(
  input         clock,
  input  [31:0] instruction_in,
  input         receive,
  output [15:0] data_out,
  output        send
);

  // Instruction buffer
  reg [31:0] instruction;

  // Matrices A and B are written here, matrix_c is driven by the ALU
  reg  [199:0] matrix_a, matrix_b;
  wire [199:0] matrix_c;

  // Control signals from control_unit and mmu done
  wire alu_start;
  wire mem_start;
  wire mem_write_enabled;
  wire alu_dumping;
  wire mem_done;

  // Buses between modules
  wire [3:0]  op_code;
  wire [5:0]  mem_address;
  wire [15:0] instruction_data;
  wire [15:0] mem_data_in;
  wire [15:0] mem_data_out;

  // Intermediate buffer for dumping from matrix_c
  reg [15:0] dumping_data;

  // Buffer ID and index from control unit
  wire [1:0] id;
  wire [4:0] index;

  // ALU done signal
  wire alu_done;

  // ALU instance: drives matrix_c when done
  alu alu_instance (
    .clock(clock),
    .start(alu_start),
    .op_code(op_code),
    .matrix_a(matrix_a),
    .matrix_b(matrix_b),
    .matrix_c(matrix_c),
    .done(alu_done)
  );

  // Control unit: generates control signals, op_code, buffer selection
  control_unit control_instance (
    .clock(clock),
    .instruction(instruction),
    .alu_done(alu_done),
    .mem_done(mem_done),
    .alu_start(alu_start),
    .op_code(op_code),
    .mem_address(mem_address),
    .mem_data_in(instruction_data),
    .mem_write_enabled(mem_write_enabled),
    .mem_start(mem_start),
    .buffer_id(id),
    .buffer_index(index),
    .alu_dumping(alu_dumping)
  );

  // MMU: handles memory reads/writes
  mmu mmu_instance (
    .clock(clock),
    .start(mem_start),
    .address(mem_address),
    .data_in(mem_data_in),
    .write_enabled(mem_write_enabled),
    .data_out(mem_data_out),
    .done(mem_done)
  );

  // Select between ALU dumping data and instruction data for memory writes
  assign mem_data_in = alu_dumping ? dumping_data : instruction_data;

  // Load new instruction on receive
  always @(posedge receive) begin
    instruction <= instruction_in;
  end

  // Update matrices and dumping_data based on buffer ID and index
  always @(*) begin
    case (id)
      2'd0: begin
        if (index == 191)
          matrix_a[index +: 8]  = mem_data_out[15:8];
        else
          matrix_a[index +: 16] = mem_data_out;
      end
      2'd1: begin
        if (index == 191)
          matrix_b[index +: 8]  = mem_data_out[15:8];
        else
          matrix_b[index +: 16] = mem_data_out;
      end
      2'd2: begin
        if (index == 191) begin
          dumping_data[15:8] = matrix_c[index +: 8];
          dumping_data[7:0]  = 0;
        end else begin
          dumping_data = matrix_c[index +: 16];
        end
      end
      default: dumping_data = 16'b0;
    endcase
  end

endmodule


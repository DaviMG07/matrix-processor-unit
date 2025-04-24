`timescale 1ns/1ps

module alu_tb;

  reg         clock;
  reg         start;
  reg  [3:0]  op_code;
  reg  [199:0] matrix_a;
  reg  [199:0] matrix_b;
  wire        done;
  wire [199:0] matrix_c;

  integer     i, row, col, base;
  reg signed [1:0] elem;

  alu dut (
    .clock    (clock),
    .start    (start),
    .op_code  (op_code),
    .matrix_a (matrix_a),
    .matrix_b (matrix_b),
    .done     (done),
    .matrix_c (matrix_c)
  );

  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  initial begin
    $dumpfile("alu_tb.vcd");
    $dumpvars(0, alu_tb);
  end

  task print_matrix;
    input [199:0] mat;
    begin
      for (row = 0; row < 10; row = row + 1) begin
        for (col = 0; col < 10; col = col + 1) begin
          base = 2 * (row*10 + col);
          elem = $signed(mat[base +: 2]);
          $write("%0d\t", elem);
        end
        $write("\n");
      end
    end
  endtask

  initial begin
    start    = 0;
    op_code  = 0;
    matrix_a = 200'h0;
    matrix_b = 200'h0;
    for (i = 0; i < 10; i = i + 1) begin
      matrix_a[2*(i*10) +: 20] = {10{ $signed(i[1:0]) }};
      matrix_b[2*(i*10) +: 20] = {10{ $signed(i[1:0]) }};
    end

    repeat (6) begin
      @(negedge clock);
      op_code = op_code + 1;
      start   = 1;
      @(posedge clock);
      start   = 0;

      wait (done);

      $display("\n=== OPCODE %0d @ %0t ===", op_code, $time);
      $display("matrix_a:");
      print_matrix(matrix_a);
      $display("matrix_b:");
      print_matrix(matrix_b);
      $display("matrix_c (result):");
      print_matrix(matrix_c);
      $display("-------------------------------\n");

      #20;
    end

    $display("** Simulation complete @ %0t **", $time);
    $finish;
  end

endmodule


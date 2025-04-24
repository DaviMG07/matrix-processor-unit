`timescale 1ns/1ps

module mpu_tb;

  reg         clock;
  reg  [31:0] instruction_in;
  reg         receive;
  wire [15:0] data_out;
  wire        send;

  mpu dut (
    .clock         (clock),
    .instruction_in(instruction_in),
    .receive       (receive),
    .data_out      (data_out),
    .send          (send)
  );

  initial begin
    clock = 1'b0;
    forever #5 clock = ~clock;
  end

  always @(posedge clock) begin
    $display("Time=%0t | receive=%b | instr_in=%h | data_out=%h | send=%b",
             $time, receive, instruction_in, data_out, send);
  end

  initial begin
    receive       = 1'b1;
    instruction_in = 32'h0000_0000;

    repeat (5) @(posedge clock);

    instruction_in = 32'b0110_01_001001_0000101000001001_0000;
    @(posedge clock) receive = 1'b1;
    @(posedge clock) receive = 1'b0;

    repeat (20) @(posedge clock);

    instruction_in = 32'b0111_01_001001_0000000000000000_0000;
    @(posedge clock) receive = 1'b1;
    @(posedge clock) receive = 1'b0;

    repeat (50) @(posedge clock);
    $display("** Simulation completed at time %0t **", $time);
    $finish;
  end

endmodule


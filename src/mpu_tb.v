`timescale 1ns/1ps

module mpu_tb;

  // Testbench signals
  reg         clock;
  reg  [31:0] instruction_in;
  reg         receive;
  wire [15:0] data_out;
  wire        send;

  // Instantiate the MPU DUT
  mpu dut (
    .clock         (clock),
    .instruction_in(instruction_in),
    .receive       (receive),
    .data_out      (data_out),
    .send          (send)
  );

  // Clock generation: 100 MHz clock (10 ns period)
  initial begin
    clock = 1'b0;
    forever #5 clock = ~clock;
  end

  // Monitor outputs at each clock edge
  always @(posedge clock) begin
    $display("Time=%0t | receive=%b | instr_in=%h | data_out=%h | send=%b",
             $time, receive, instruction_in, data_out, send);
  end

  // Stimulus sequence
  initial begin
    // Initialize inputs
    receive       = 1'b1;
    instruction_in = 32'h0000_0000;

    // Wait a few cycles for stability
    repeat (5) @(posedge clock);

    // Example transaction 1: load an instruction
    instruction_in = 32'b0110_01_001001_0000101000001001_0000;
    @(posedge clock) receive = 1'b1;
    @(posedge clock) receive = 1'b0;

    // Allow DUT to process
    repeat (20) @(posedge clock);

    // Example transaction 2: another instruction
    instruction_in = 32'b0111_01_001001_0000000000000000_0000;
    @(posedge clock) receive = 1'b1;
    @(posedge clock) receive = 1'b0;

    // Wait and then finish
    repeat (50) @(posedge clock);
    $display("** Simulation completed at time %0t **", $time);
    $finish;
  end

endmodule


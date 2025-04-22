module mmu(
  input             clock,
  input             start,
  input      [5:0]  address,
  input      [15:0] data_in,
  input             write_enabled,
  output     [15:0] data_out,
  output reg        done
);

reg [1:0] count;

memory mem (
  address,
  clock,
  data_in,
  write_enabled,
  data_out
);

always @(posedge clock) begin
  if (start) begin
    count <= 0;
    done  <= 0;
  end else begin 
    if (count == 3) begin 
      done <= 1;
    end else begin 
      count <= count + 1;
      done  <= 0;
    end
  end
end

endmodule

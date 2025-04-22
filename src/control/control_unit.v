module control_unit(
  input             clock,
  input      [31:0] instruction,
  input             alu_done,
  input             mem_done,
  output reg        alu_start,
  output     [3:0]  op_code,
  output     [5:0]  mem_address,
  output     [15:0] mem_data_in,
  output reg        mem_write_enabled,
  output reg        mem_start,
  output     [1:0]  buffer_id,
  output     [4:0]  buffer_index,
  output reg        alu_dumping
);

reg  [2:0] stage;
wire [1:0] id;
wire [2:0] row, col;
wire [5:0] address;
wire [15:0] values;
wire [4:0] index;
reg  [4:0] index_count;
reg  [1:0] id_count;

reg alu_loaded, alu_loading, alu_dumped;

assign buffer_id    = alu_loading ? id_count : 2'd2;
assign buffer_index = index_count;
assign mem_address  = (alu_dumping | alu_loading) ? (buffer_id*13) + buffer_index : address;
assign mem_data_in = values;

decoder decoder_instance (
  instruction,
  op_code,
  id,
  row,
  col,
  index,
  address,
  values
);

parameter FETCH   = 3'd0,
          DECODE  = 3'd1,
          EXECUTE = 3'd2,
          WRITE   = 3'd3,
          MEMORY  = 3'd4,

          LOAD    = 4'd6,
          STORE   = 4'd7;

always @(posedge clock) begin

    case (stage)
      FETCH: begin
        if (instruction) stage <= DECODE;
      end 
      DECODE: begin 
        if (op_code == LOAD | op_code == STORE) stage <= MEMORY;
        else stage <= EXECUTE;
      end 
      EXECUTE: begin 
        if (!alu_loaded) begin
          alu_loading <= 1;
          if (index_count < 25) begin
            if (mem_done) begin
              index_count       <= index_count + 2;
              mem_write_enabled <= 0;
              mem_start         <= 0;
            end else begin
              mem_write_enabled <= 1;
              mem_start         <= 1;
            end 
          end else begin
            if (id_count < 2) begin 
              if (mem_done) begin
                id_count          <= id_count + 1;
                index_count       <= 0;
                mem_start         <= 0;
                mem_write_enabled <= 0;
              end else begin
                mem_write_enabled <= 1;
                mem_start         <= 1;
              end 
            end else begin 
              alu_loaded <= 1;
            end
          end
        end else begin 
          alu_loading <= 0;
          if (!alu_done) begin
            alu_start <= 1;
          end else begin 
            alu_loaded <= 0;
            stage      <= WRITE;
          end
        end
      end
      WRITE: begin 
        id_count <= 2'd2;
        if (!alu_dumped) begin 
          alu_dumping <= 1;
          if (index_count < 25) begin
            if (mem_done) begin
              index_count <= index_count + 2;
              mem_start   <= 0;
            end else begin
              mem_start <= 1;
            end
          end else begin 
            alu_dumped <= 1;
          end
        end else begin 
          alu_dumping <= 0;
          alu_dumped  <= 0;
          stage       <= FETCH;
        end
      end
      MEMORY: begin 
        if (mem_done) begin 
          stage             <= FETCH;
          mem_start         <= 0;
          mem_write_enabled <= 0;
        end else begin
          mem_start         <= 1;
          mem_write_enabled <= op_code == STORE;
        end 
      end

    default: begin
      stage <= FETCH;
    end
    endcase

end

endmodule

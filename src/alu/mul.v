`define at(row, col) (8 * (col + 5*row))

module mul(
    input              clock,  
    input              start,
    input      [199:0] matrix_a,
    input      [199:0] matrix_b,
    output reg [199:0] matrix_r,
    output             done
);

    reg [2:0] row;

    always @(posedge clock) begin
        if (start) begin
            row <= 0;
        end else begin
            matrix_r[`at(row, 0) +: 8] <= 
                  $signed(matrix_a[`at(row, 0) +: 8]) * $signed(matrix_b[`at(0, 0) +: 8])
                + $signed(matrix_a[`at(row, 1) +: 8]) * $signed(matrix_b[`at(1, 0) +: 8])
                + $signed(matrix_a[`at(row, 2) +: 8]) * $signed(matrix_b[`at(2, 0) +: 8])
                + $signed(matrix_a[`at(row, 3) +: 8]) * $signed(matrix_b[`at(3, 0) +: 8])
                + $signed(matrix_a[`at(row, 4) +: 8]) * $signed(matrix_b[`at(4, 0) +: 8]);

            matrix_r[`at(row, 1) +: 8] <= 
                  $signed(matrix_a[`at(row, 0) +: 8]) * $signed(matrix_b[`at(0, 1) +: 8])
                + $signed(matrix_a[`at(row, 1) +: 8]) * $signed(matrix_b[`at(1, 1) +: 8])
                + $signed(matrix_a[`at(row, 2) +: 8]) * $signed(matrix_b[`at(2, 1) +: 8])
                + $signed(matrix_a[`at(row, 3) +: 8]) * $signed(matrix_b[`at(3, 1) +: 8])
                + $signed(matrix_a[`at(row, 4) +: 8]) * $signed(matrix_b[`at(4, 1) +: 8]);

            matrix_r[`at(row, 2) +: 8] <= 
                  $signed(matrix_a[`at(row, 0) +: 8]) * $signed(matrix_b[`at(0, 2) +: 8])
                + $signed(matrix_a[`at(row, 1) +: 8]) * $signed(matrix_b[`at(1, 2) +: 8])
                + $signed(matrix_a[`at(row, 2) +: 8]) * $signed(matrix_b[`at(2, 2) +: 8])
                + $signed(matrix_a[`at(row, 3) +: 8]) * $signed(matrix_b[`at(3, 2) +: 8])
                + $signed(matrix_a[`at(row, 4) +: 8]) * $signed(matrix_b[`at(4, 2) +: 8]);

            matrix_r[`at(row, 3) +: 8] <= 
                  $signed(matrix_a[`at(row, 0) +: 8]) * $signed(matrix_b[`at(0, 3) +: 8])
                + $signed(matrix_a[`at(row, 1) +: 8]) * $signed(matrix_b[`at(1, 3) +: 8])
                + $signed(matrix_a[`at(row, 2) +: 8]) * $signed(matrix_b[`at(2, 3) +: 8])
                + $signed(matrix_a[`at(row, 3) +: 8]) * $signed(matrix_b[`at(3, 3) +: 8])
                + $signed(matrix_a[`at(row, 4) +: 8]) * $signed(matrix_b[`at(4, 3) +: 8]);

            matrix_r[`at(row, 4) +: 8] <= 
                  $signed(matrix_a[`at(row, 0) +: 8]) * $signed(matrix_b[`at(0, 4) +: 8])
                + $signed(matrix_a[`at(row, 1) +: 8]) * $signed(matrix_b[`at(1, 4) +: 8])
                + $signed(matrix_a[`at(row, 2) +: 8]) * $signed(matrix_b[`at(2, 4) +: 8])
                + $signed(matrix_a[`at(row, 3) +: 8]) * $signed(matrix_b[`at(3, 4) +: 8])
                + $signed(matrix_a[`at(row, 4) +: 8]) * $signed(matrix_b[`at(4, 4) +: 8]);

            if (row == 4)
                row <= 0;
            else
                row <= row + 1;
        end
    end

endmodule


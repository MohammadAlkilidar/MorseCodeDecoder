// CountTo10: Counts 10 input pulses and generates a single output pulse (1s if input is 100ms).

module CountTo10 (
    input wire clk,
    input wire rst,
    output reg timeout
);

    reg [3:0] count;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            count <= 0;
            timeout <= 0;
        end else if (count == 4'd9) begin
            count <= 0;
            timeout <= 1;
        end else begin
            count <= count + 1;
            timeout <= 0;
        end
    end

endmodule

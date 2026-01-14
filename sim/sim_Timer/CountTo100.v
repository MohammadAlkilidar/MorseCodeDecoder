// CountTo100: Counts 100 input pulses and generates a single output pulse (100ms if input is 1ms).

module CountTo100 (
    input wire clk,
    input wire rst,
    output reg timeout
);

    reg [6:0] count;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            count <= 0;
            timeout <= 0;
        end else if (count == 7'd99) begin
            count <= 0;
            timeout <= 1;
        end else begin
            count <= count + 1;
            timeout <= 0;
        end
    end

endmodule

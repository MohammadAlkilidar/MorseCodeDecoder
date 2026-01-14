//Divides 50 MHz clock to 25MHz

module ClockDivider25MHz (
    input wire clk_in,     // 50 MHz input
    input wire rst,        // Active-low reset
    output reg clk_out     // 25 MHz output
);

    always @(posedge clk_in or negedge rst) begin
        if (!rst)
            clk_out <= 0;
        else
            clk_out <= ~clk_out; // toggle every 20ns → 25 MHz
    end

endmodule

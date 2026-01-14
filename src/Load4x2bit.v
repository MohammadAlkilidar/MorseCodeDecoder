// Load4x2bit: Sequentially loads 4 x 2-bit inputs into an 8-bit output when enabled, then asserts ready for 1 cycle after final input.

module Load4x2bit (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire load,
    input wire [1:0] in,
    output reg [7:0] out,
    output reg ready
);

    reg [1:0] buffer [0:3];
    reg [1:0] count;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            count <= 0;
            out <= 8'd0;
            ready <= 0;
        end else begin
            ready <= 0;

            if (enable && load) begin
                buffer[count] <= in;

                if (count == 2'd3) begin
                    out <= {buffer[0], buffer[1], buffer[2], in};
                    count <= 0;
                    ready <= 1;
                end else begin
                    count <= count + 1;
                end
            end
        end
    end

endmodule

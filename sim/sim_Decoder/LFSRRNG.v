// LFSRNG: Continuously runs 5-bit LFSR; outputs 0–9 when enabled.

module LFSRNG (
    input wire clk,
    input wire rst,
    input wire enable,
    output reg [3:0] rand
);

    reg [4:0] LFSR;
    wire feedback = LFSR[4];

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            LFSR <= 5'b11111;
            rand <= 0;
        end else begin
            // LFSR always runs
            LFSR[0] <= feedback;
            LFSR[1] <= LFSR[0];
            LFSR[2] <= LFSR[1] ^ feedback;
            LFSR[3] <= LFSR[2];
            LFSR[4] <= LFSR[3];

            // Output rand only when enabled
            if (enable && LFSR < 5'd30)
                rand <= LFSR % 10;
        end
    end

endmodule

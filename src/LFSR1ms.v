//LFSR1ms: Pseudo-random LFSR timer that asserts timeout at a custom value per mode.

module LFSR1ms (
    input wire clock,
    input wire rst,
    input wire enable,
    input wire [1:0] mode,
    input wire ReconfigTimer,
    output reg timeout
);

    reg [16:0] LFSR;
    reg [16:0] TimeoutNumber;
    wire feedback = LFSR[16];

    always @(posedge clock or negedge rst) begin
        if (!rst) begin
            LFSR <= 17'h1FFFF;
            timeout <= 0;
        end else begin
            if (ReconfigTimer && !enable) begin
                case (mode)
                    2'b00: TimeoutNumber <= 17'd24988;
                    2'b01: TimeoutNumber <= 17'd98941;
                    2'b11: TimeoutNumber <= 17'd94171;
                    default: TimeoutNumber <= 17'd98941;
                endcase
            end

            if (enable) begin
                if (LFSR == TimeoutNumber) begin
                    LFSR <= 17'h1FFFF;
                    timeout <= 1;
                end else begin
                    LFSR[0]  <= feedback;
                    LFSR[1]  <= LFSR[0];
                    LFSR[2]  <= LFSR[1] ^ feedback;
                    LFSR[3]  <= LFSR[2] ^ feedback;
                    LFSR[4]  <= LFSR[3];
                    LFSR[5]  <= LFSR[4] ^ feedback;
                    LFSR[6]  <= LFSR[5];
                    LFSR[7]  <= LFSR[6];
                    LFSR[8]  <= LFSR[7];
                    LFSR[9]  <= LFSR[8];
                    LFSR[10] <= LFSR[9];
                    LFSR[11] <= LFSR[10];
                    LFSR[12] <= LFSR[11];
                    LFSR[13] <= LFSR[12];
                    LFSR[14] <= LFSR[13];
                    LFSR[15] <= LFSR[14];
		    LFSR[16] <= LFSR[15];
                    timeout <= 0;
                end
            end else begin
                timeout <= 0;
            end
        end
    end

endmodule

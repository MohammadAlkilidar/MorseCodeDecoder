// SevenSegmentDisplay: Converts 4-bit binary input to hexadecimal and outputs to a 7-segment display.

module SevenSegmentDisplay(digits, segment);
    input [3:0] digits;
    output reg [6:0] segment;

    always @(digits) begin
        case (digits)
            4'b0000: segment = 7'b1000000; // 0
            4'b0001: segment = 7'b1111001; // 1
            4'b0010: segment = 7'b0100100; // 2
            4'b0011: segment = 7'b0110000; // 3
            4'b0100: segment = 7'b0011001; // 4
            4'b0101: segment = 7'b0010010; // 5
            4'b0110: segment = 7'b0000010; // 6
            4'b0111: segment = 7'b1111000; // 7
            4'b1000: segment = 7'b0000000; // 8
            4'b1001: segment = 7'b0011000; // 9
            4'b1010: segment = 7'b0001000; // A
            4'b1011: segment = 7'b0000011; // B (Fixed)
            4'b1100: segment = 7'b1000110; // C
            4'b1101: segment = 7'b0100001; // D (Fixed)
            4'b1110: segment = 7'b0000110; // E
            4'b1111: segment = 7'b0001110; // F
            default: segment = 7'b1111111; // Default case (all segments off)
        endcase
    end
endmodule
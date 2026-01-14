// MorseDecoder: Converts 4 Morse symbols (2-bit each: 0=gap, 1=dot, 3=dash) to ASCII A–Z

module MorseDecoder (
    input  wire [7:0] MorseInput,     // Packed {b0, b1, b2, b3}
    output reg  [7:0] ASCIIOutput     // ASCII letter
);

    always @(*) begin
        case (MorseInput)
            8'b01110000: ASCIIOutput = 8'd65; // A: .-
            8'b11010101: ASCIIOutput = 8'd66; // B: -...
            8'b11011101: ASCIIOutput = 8'd67; // C: -.-.
            8'b11010100: ASCIIOutput = 8'd68; // D: -..
            8'b01000000: ASCIIOutput = 8'd69; // E: .
            8'b01011101: ASCIIOutput = 8'd70; // F: ..-.
            8'b11110100: ASCIIOutput = 8'd71; // G: --.
            8'b01010101: ASCIIOutput = 8'd72; // H: ....
            8'b01010000: ASCIIOutput = 8'd73; // I: ..
            8'b01111111: ASCIIOutput = 8'd74; // J: .---
            8'b11011100: ASCIIOutput = 8'd75; // K: -.-
            8'b01110101: ASCIIOutput = 8'd76; // L: .-..
            8'b11110000: ASCIIOutput = 8'd77; // M: --
            8'b11010000: ASCIIOutput = 8'd78; // N: -.
            8'b11111100: ASCIIOutput = 8'd79; // O: ---
            8'b01111101: ASCIIOutput = 8'd80; // P: .--.
            8'b11110111: ASCIIOutput = 8'd81; // Q: --.-
            8'b01110100: ASCIIOutput = 8'd82; // R: .-.
            8'b01010100: ASCIIOutput = 8'd83; // S: ...
            8'b11000000: ASCIIOutput = 8'd84; // T: -
            8'b01011100: ASCIIOutput = 8'd85; // U: ..-
            8'b01010111: ASCIIOutput = 8'd86; // V: ...-
            8'b01111100: ASCIIOutput = 8'd87; // W: .--
            8'b11010111: ASCIIOutput = 8'd88; // X: -..-
            8'b11011111: ASCIIOutput = 8'd89; // Y: -.--
            8'b11110101: ASCIIOutput = 8'd90; // Z: --..

            default:     ASCIIOutput = 8'd63; // '?' for unknown
        endcase
    end

endmodule
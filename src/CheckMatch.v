//CheckMatch: Compares input ASCII letters to ROM word letters; resets on error, increments points after 5 matches.

module CheckMatch (
    input  wire       clk,
    input  wire       rst,
    input  wire       LetterEnter,
    input  wire [7:0] ASCIIOutput,
    input  wire [1:0] mode,
    input  wire       timeout,
    input  wire       Button,
    input  wire [4:0] rand,
    output reg        Match,
    output reg  [4:0] letterLEDs,
    output reg  [3:0] Points,
    output reg  [3:0] HighScore
);

    parameter LETTER = 0, VERIFY = 1;
    reg [1:0] State;
    reg [2:0] letterIndex;
    reg       load_compare;

    wire [7:0] expected_letter;
    wire [6:0] address = rand * 8 + letterIndex;

    ROM_WORDS rom_inst (
        .address(address),
        .clock(clk),
        .q(expected_letter)
    );

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            State        <= LETTER;
            letterIndex  <= 0;
            Match        <= 0;
            letterLEDs   <= 5'b00000;
            load_compare <= 0;
            Points       <= 0;
        end else begin
            if ((mode == 2'b11 && timeout && Button) || (mode == 2'b01 && timeout && Button)) begin
                State        <= LETTER;
                letterIndex  <= 0;
                Points       <= 0;
                Match        <= 0;
                letterLEDs   <= 5'b00000;
                load_compare <= 0;
            end else begin
                Match <= 0;

                case (State)
                    LETTER: begin
                        if (LetterEnter)
                            load_compare <= 1;
                        else if (load_compare) begin
                            if (ASCIIOutput == expected_letter) begin
                                letterLEDs[letterIndex] <= 1;
                                letterIndex <= letterIndex + 1;
                                if (letterIndex == 3'd4)
                                    State <= VERIFY;
                            end else begin
                                letterIndex  <= 0;
                                letterLEDs   <= 5'b00000;
                            end
                            load_compare <= 0;
                        end
                    end

                    VERIFY: begin
                        Match        <= 1;
                        Points       <= Points + 1;
                        letterIndex  <= 0;
                        letterLEDs   <= 5'b00000;
                        State        <= LETTER;
                    end

                    default: State <= LETTER;
                endcase
            end
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst)
            HighScore <= 0;
        else if (Points > HighScore)
            HighScore <= Points;
    end

endmodule

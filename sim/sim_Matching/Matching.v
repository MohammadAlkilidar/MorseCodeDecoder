module Matching (
    input wire clk,
    input wire rst,
    input wire PlayerBtn,
    input wire [7:0] ASCIIInput,
    input wire [1:0] mode,
    input wire timeout,

    output wire [4:0] letterLEDs,
    output wire [6:0] PointsSeg,
    output wire [6:0] HighScoreSeg
);

    wire DebouncedPlayerBtn;
    wire [3:0] Points, HighScore;
    wire [3:0] dummy_out;
    wire Match;

    ButtonShaper uBtn (
        .B_in(PlayerBtn),
        .B_out(DebouncedPlayerBtn),
        .clk(clk),
        .rst(rst)
    );

    LoadRegister dummy (
        .D_in(4'd0),
        .D_out(dummy_out),
        .clk(clk),
        .rst(rst),
        .Load(DebouncedPlayerBtn)
    );

    CheckMatch match_logic (
        .clk(clk),
        .rst(rst),
        .LetterEnter(DebouncedPlayerBtn),
        .ASCIIOutput(ASCIIInput),
        .mode(mode),
        .timeout(timeout),
        .Button(DebouncedPlayerBtn),
        .rand(5'd0),  // fixed word index
        .Match(Match),
        .letterLEDs(letterLEDs),
        .Points(Points),
        .HighScore(HighScore)
    );

    SevenSegmentDisplay seg_pts (
        .digits(Points),
        .segment(PointsSeg)
    );

    SevenSegmentDisplay seg_hi (
        .digits(HighScore),
        .segment(HighScoreSeg)
    );

endmodule

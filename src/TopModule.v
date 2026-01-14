// TopModule: Full system integration for a password-protected Morse code word game.

module TopModule(
    input wire clk,
    input wire rst,

    input wire [3:0] PassSwitches,
    input wire PassBtn,
    input wire PlayerBtn,
    input wire ModeBtn,

    output wire [6:0] PointsSeg,
	 output wire [6:0] HighScoreSeg,
    output wire [6:0] tens_segment,
    output wire [6:0] ones_segment,

    output wire InLED,
    output wire OutLED,

    output wire LED0,
    output wire LED1,

    output wire hsync,
    output wire vsync,
    output wire [3:0] red,
    output wire [3:0] green,
    output wire [3:0] blue,

    output wire [4:0] LetterLEDs
);

    wire DebouncedPassBtn, DebouncedPlayerBtn, DebouncedModeBtn;
    wire LoggedIn, ReconfigTimer, enable, timeout_1sec;
    wire BorrowUp_Ones, NoBorrowDown_Ones, NoBorrowDown_Tens;
    wire [3:0] countTens, countOnes;
    wire CheckPassword, clk25, GameTimeout;
    wire [2:0] MatchedID;
    wire [1:0] mode;
    wire [3:0] Level, Points, HighScore;
    wire [7:0] MorsePacked, DecodedLetter;
    wire MorseReady;
    wire [4:0] letterLEDs_id, letterLEDs_pw, letterLEDs_check;
	 wire [4:0] rand;
	 wire Match;

    assign GameTimeout = ~NoBorrowDown_Tens && ~NoBorrowDown_Ones;
    assign InLED = LoggedIn;
    assign OutLED = ~LoggedIn;
    assign LED0 = mode[0];
    assign LED1 = mode[1];
    assign LetterLEDs = (LoggedIn) ? letterLEDs_check : (CheckPassword ? letterLEDs_pw : letterLEDs_id);

    ButtonShaper PassLoadBtn (.B_in(PassBtn), .B_out(DebouncedPassBtn), .clk(clk), .rst(rst));
    ButtonShaper PlayerLoadBtn (.B_in(PlayerBtn), .B_out(DebouncedPlayerBtn), .clk(clk), .rst(rst));
    ButtonShaper ModeLoadBtn (.B_in(ModeBtn), .B_out(DebouncedModeBtn), .clk(clk), .rst(rst));

    Identification uID (
        .clk(clk), .rst(rst), .PassBtn(DebouncedPassBtn), .InputID(PassSwitches),
        .mode(mode), .timeout(GameTimeout), .CheckPassword(CheckPassword),
        .MatchedID(MatchedID), .letterLEDs(letterLEDs_id)
    );

    Password uPassword (
        .clk(clk), .rst(rst), .PassBtn(DebouncedPassBtn), .InputPassword(PassSwitches),
        .MatchedID(MatchedID), .CheckPassword(CheckPassword), .mode(mode),
        .timeout(GameTimeout), .LoggedIn(LoggedIn), .letterLEDs(letterLEDs_pw)
    );

    GameController uGameCtrl (
        .clk(clk), .rst(rst), .PassEnter(DebouncedPassBtn), .LoggedIn(LoggedIn),
        .Timeout(GameTimeout), .mode(mode), .ReconfigTimer(ReconfigTimer), .enable(enable)
    );

    OneSecTimer uOneSecTimer (.clk(clk), .rst(rst), .enable(enable), .mode(mode), .ReconfigTimer(ReconfigTimer), .timeout(timeout_1sec));

    digitTimer Ones (
        .clk(clk), .rst(rst), .reconfig(ReconfigTimer), .enable(enable),
        .BorrowDown(timeout_1sec), .NoBorrowUp(NoBorrowDown_Tens),
        .BorrowUp(BorrowUp_Ones), .NoBorrowDown(NoBorrowDown_Ones),
        .Digit(countOnes)
    );

    digitTimer Tens (
        .clk(clk), .rst(rst), .reconfig(ReconfigTimer), .enable(enable),
        .BorrowDown(BorrowUp_Ones), .NoBorrowUp(1'b1),
        .BorrowUp(), .NoBorrowDown(NoBorrowDown_Tens),
        .Digit(countTens)
    );

    SevenSegmentDisplay uTensDisplay (.digits(countTens), .segment(tens_segment));
    SevenSegmentDisplay uOnesDisplay (.digits(countOnes), .segment(ones_segment));
    SevenSegmentDisplay PointsDisplay (.digits(Points), .segment(PointsSeg));
	 SevenSegmentDisplay HighScoreDisplay (.digits(HighScore), .segment(HighScoreSeg));

    ClockDivider25MHz uClkDiv (.clk_in(clk), .rst(rst), .clk_out(clk25));

    VGATextRenderer uVGA (
        .clk(clk25), .rst(rst), .LoggedIn(LoggedIn), .CheckPassword(CheckPassword),
        .enable(enable), .rand(rand), .GameTimeout(GameTimeout), .Points(Points),
        .hsync(hsync), .vsync(vsync), .red(red), .green(green), .blue(blue)
    );

    ModeRotator uModeRotator (
        .clk(clk), .rst(rst), .button(DebouncedModeBtn), .mode(mode)
    );

    Load4x2bit uLoad4x2bit (
        .clk(clk), .rst(rst), .enable(enable), .load(DebouncedPlayerBtn),
        .in(mode), .out(MorsePacked), .ready(MorseReady)
    );

    MorseDecoder uMorseDecoder (
        .MorseInput(MorsePacked), .ASCIIOutput(DecodedLetter)
    );

    CheckMatch uCheckMatch (
        .clk(clk), .rst(rst), .LetterEnter(MorseReady), .ASCIIOutput(DecodedLetter),
        .mode(mode), .timeout(GameTimeout), .Button(DebouncedPassBtn), .rand(rand),
        .Match(Match), .letterLEDs(letterLEDs_check), .Points(Points),
		  .HighScore(HighScore)
    );
	 
	 LFSRNG uLFSRNG(
	     .clk(clk), .rst(rst), .enable(Match), .rand(rand)
	 );

endmodule


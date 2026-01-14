module Timer (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire reconfig,
    input wire [1:0] mode,
    output wire timeout_1sec,
    output wire [6:0] ones_segment,
    output wire [6:0] tens_segment
);

    wire BorrowUp_Ones, NoBorrowDown_Ones, NoBorrowDown_Tens;
    wire [3:0] countOnes, countTens;

    // 1-second pulse generator
    OneSecTimer uOneSecTimer (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .timeout(timeout_1sec)
    );

    // Ones digit countdown timer
    digitTimer Ones (
        .clk(clk),
        .rst(rst),
        .reconfig(reconfig),
        .enable(enable),
        .BorrowDown(timeout_1sec),
        .NoBorrowUp(NoBorrowDown_Tens),
        .BorrowUp(BorrowUp_Ones),
        .NoBorrowDown(NoBorrowDown_Ones),
        .Digit(countOnes)
    );

    // Tens digit countdown timer
    digitTimer Tens (
        .clk(clk),
        .rst(rst),
        .reconfig(reconfig),
        .enable(enable),
        .BorrowDown(BorrowUp_Ones),
        .NoBorrowUp(1'b1),
        .BorrowUp(), // unused
        .NoBorrowDown(NoBorrowDown_Tens),
        .Digit(countTens)
    );

    // 7-segment displays
    SevenSegmentDisplay uTensDisplay (
        .digits(countTens),
        .segment(tens_segment)
    );

    SevenSegmentDisplay uOnesDisplay (
        .digits(countOnes),
        .segment(ones_segment)
    );

endmodule

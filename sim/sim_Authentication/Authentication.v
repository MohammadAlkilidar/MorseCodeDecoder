module Authentication (
    input wire clk,
    input wire rst,
    input wire [3:0] PassSwitches,
    input wire PassBtn,
    input wire [1:0] mode,
    input wire timeout,

    output wire LoggedIn,
    output wire CheckPassword,
    output wire [2:0] MatchedID,
    output wire [4:0] letterLEDs_id,
    output wire [4:0] letterLEDs_pw
);

    wire DebouncedPassBtn;

    ButtonShaper debouncer (
        .B_in(PassBtn),
        .B_out(DebouncedPassBtn),
        .clk(clk),
        .rst(rst)
    );

    wire [3:0] dummy_output;

    LoadRegister dummy_register (
        .D_in(PassSwitches),
        .D_out(dummy_output),
        .clk(clk),
        .rst(rst),
        .Load(DebouncedPassBtn)
    );

    Identification ident (
        .clk(clk),
        .rst(rst),
        .PassBtn(DebouncedPassBtn),
        .InputID(PassSwitches),
        .mode(mode),
        .timeout(timeout),
        .CheckPassword(CheckPassword),
        .MatchedID(MatchedID),
        .letterLEDs(letterLEDs_id)
    );

    Password passw (
        .clk(clk),
        .rst(rst),
        .PassBtn(DebouncedPassBtn),
        .InputPassword(PassSwitches),
        .MatchedID(MatchedID),
        .CheckPassword(CheckPassword),
        .mode(mode),
        .timeout(timeout),
        .LoggedIn(LoggedIn),
        .letterLEDs(letterLEDs_pw)
    );

endmodule


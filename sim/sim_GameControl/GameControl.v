module GameControl (
    input wire clk,
    input wire rst,
    input wire PassBtn,
    input wire LoggedIn,
    input wire Timeout,
    input wire [1:0] mode,

    output wire ReconfigTimer,
    output wire enable
);

    wire DebouncedPassBtn;
    wire [3:0] dummy_out;

    ButtonShaper shaper (
        .B_in(PassBtn),
        .B_out(DebouncedPassBtn),
        .clk(clk),
        .rst(rst)
    );

    LoadRegister dummy (
        .D_in(4'd0),
        .D_out(dummy_out),
        .clk(clk),
        .rst(rst),
        .Load(DebouncedPassBtn)
    );

    GameController ctrl (
        .clk(clk),
        .rst(rst),
        .PassEnter(DebouncedPassBtn),
        .LoggedIn(LoggedIn),
        .Timeout(Timeout),
        .mode(mode),
        .ReconfigTimer(ReconfigTimer),
        .enable(enable)
    );

endmodule

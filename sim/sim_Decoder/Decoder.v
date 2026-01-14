module Decoder (
    input wire clk,
    input wire rst,
    input wire PlayerBtn,
    input wire ModeBtn,
    output wire [1:0] mode,
    output wire [3:0] rand,
    output wire [7:0] MorsePacked,
    output wire MorseReady,
    output wire [7:0] DecodedLetter
);

    wire DebouncedPlayerBtn, DebouncedModeBtn;

    ButtonShaper uBtnPlayer (
        .B_in(PlayerBtn),
        .B_out(DebouncedPlayerBtn),
        .clk(clk),
        .rst(rst)
    );

    ButtonShaper uBtnMode (
        .B_in(ModeBtn),
        .B_out(DebouncedModeBtn),
        .clk(clk),
        .rst(rst)
    );

    ModeRotator mode_ctrl (
        .clk(clk),
        .rst(rst),
        .button(DebouncedModeBtn),
        .mode(mode)
    );

    LFSRNG rng (
        .clk(clk),
        .rst(rst),
        .enable(1'b1),
        .rand(rand)
    );

    Load4x2bit morse_input (
        .clk(clk),
        .rst(rst),
        .enable(1'b1),
        .load(DebouncedPlayerBtn),
        .in(mode),
        .out(MorsePacked),
        .ready(MorseReady)
    );

    MorseDecoder decoder (
        .MorseInput(MorsePacked),
        .ASCIIOutput(DecodedLetter)
    );

endmodule

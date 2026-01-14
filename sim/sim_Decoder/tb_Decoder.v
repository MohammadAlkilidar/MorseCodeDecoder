`timescale 1ns / 1ps

module tb_Decoder;

    reg clk = 0;
    reg rst = 0;
    reg PlayerBtn = 0;
    reg ModeBtn = 0;

    wire [1:0] mode;
    wire [3:0] rand;
    wire [7:0] MorsePacked;
    wire MorseReady;
    wire [7:0] DecodedLetter;

    Decoder dut (
        .clk(clk),
        .rst(rst),
        .PlayerBtn(PlayerBtn),
        .ModeBtn(ModeBtn),
        .mode(mode),
        .rand(rand),
        .MorsePacked(MorsePacked),
        .MorseReady(MorseReady),
        .DecodedLetter(DecodedLetter)
    );

    always #5 clk = ~clk;

    task press_player;
        begin
            PlayerBtn = 1;
            #20;
            PlayerBtn = 0;
            #80;
        end
    endtask

    task press_mode; // cycles through 00 -> 01 -> 11
        begin
            ModeBtn = 1;
            #20;
            ModeBtn = 0;
            #100;
        end
    endtask

    initial begin
        rst = 0;
        #30 rst = 1;

        // Set mode to dot (01)
        press_mode(); // mode = 01

        // Send 4 symbols using the same mode (simulate one Morse letter)
        press_player(); // . 
        press_player(); // . 
        press_player(); // . 
        press_player(); // .  → should decode S or similar

        #200;

        // Cycle mode to dash and input more
        press_mode(); // mode = 11

        press_player();
        press_player();
        press_player();
        press_player(); // all dashes

        #200;

        $stop;
    end

endmodule

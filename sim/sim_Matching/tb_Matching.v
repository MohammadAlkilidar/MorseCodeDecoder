`timescale 1ns / 1ps

module tb_Matching;

    reg clk = 0;
    reg rst = 0;
    reg PlayerBtn = 0;
    reg timeout = 0;
    reg [7:0] ASCIIInput = 8'd65; // 'A'
    reg [1:0] mode = 2'b00;

    wire [4:0] letterLEDs;
    wire [6:0] PointsSeg;
    wire [6:0] HighScoreSeg;

    Matching dut (
        .clk(clk),
        .rst(rst),
        .PlayerBtn(PlayerBtn),
        .ASCIIInput(ASCIIInput),
        .mode(mode),
        .timeout(timeout),
        .letterLEDs(letterLEDs),
        .PointsSeg(PointsSeg),
        .HighScoreSeg(HighScoreSeg)
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

    initial begin
        rst = 0;
        #30 rst = 1;

        // Score one correct word (HELLO = 72, 69, 76, 76, 79)
        ASCIIInput = 8'd72; press_player();
        ASCIIInput = 8'd69; press_player();
        ASCIIInput = 8'd76; press_player();
        ASCIIInput = 8'd76; press_player();
        ASCIIInput = 8'd79; press_player();

        #200;

        // New word, score again
        ASCIIInput = 8'd72; press_player();
        ASCIIInput = 8'd69; press_player();
        ASCIIInput = 8'd76; press_player();
        ASCIIInput = 8'd76; press_player();
        ASCIIInput = 8'd79; press_player();

        #200;

        // Trigger mismatch
        ASCIIInput = 8'd88; press_player(); // X (wrong)

        #300;

        $stop;
    end

endmodule

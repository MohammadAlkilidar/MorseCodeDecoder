`timescale 1ns / 1ps

module tb_Timer;

    reg clk = 0;
    reg rst = 0;
    reg enable = 0;
    reg reconfig = 0;
    reg [1:0] mode = 2'b00;

    wire timeout_1sec;
    wire [6:0] ones_segment;
    wire [6:0] tens_segment;

    Timer dut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .reconfig(reconfig),
        .mode(mode),
        .timeout_1sec(timeout_1sec),
        .ones_segment(ones_segment),
        .tens_segment(tens_segment)
    );

    always #5 clk = ~clk;

    initial begin
        rst = 0;
        enable = 0;
        reconfig = 0;
        mode = 2'b00;

        #50 rst = 1;

        // Load initial timer value
        reconfig = 1;
        #20 reconfig = 0;

        // Start timer
        enable = 1;

        // Let it count for a while
        #2000000;

        $stop;
    end

endmodule

`timescale 1ns / 1ps

module tb_GameControl;

    reg clk = 0;
    reg rst = 0;
    reg PassBtn = 0;
    reg LoggedIn = 0;
    reg Timeout = 0;
    reg [1:0] mode = 2'b00;

    wire ReconfigTimer;
    wire enable;

    GameControl dut (
        .clk(clk),
        .rst(rst),
        .PassBtn(PassBtn),
        .LoggedIn(LoggedIn),
        .Timeout(Timeout),
        .mode(mode),
        .ReconfigTimer(ReconfigTimer),
        .enable(enable)
    );

    always #5 clk = ~clk;

    task press_button;
        begin
            PassBtn = 1;
            #20;
            PassBtn = 0;
            #80;
        end
    endtask

    initial begin
        // Reset
        rst = 0;
        #30 rst = 1;

        // Step 1: simulate login
        LoggedIn = 1;
        press_button(); // move to RECONFIG

        // Step 2: mode = 00, press to go to GAMEPLAY
        mode = 2'b00;
        press_button();

        // Step 3: timeout occurs during gameplay
        #500;
        Timeout = 1;
        #50 Timeout = 0;

        // Step 4: press in mode 01 (restart)
        mode = 2'b01;
        press_button();

        // Step 5: mode 11 logout during timeout
        Timeout = 1;
        mode = 2'b11;
        press_button();

        #200;

        $stop;
    end

endmodule

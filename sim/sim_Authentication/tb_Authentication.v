`timescale 1ns / 1ps

module tb_Authentication;

    reg clk = 0;
    reg rst = 0;
    reg [3:0] PassSwitches;
    reg PassBtn;
    reg [1:0] mode;
    reg timeout;

    wire LoggedIn, CheckPassword;
    wire [2:0] MatchedID;
    wire [4:0] letterLEDs_id, letterLEDs_pw;

    Authentication dut (
        .clk(clk),
        .rst(rst),
        .PassSwitches(PassSwitches),
        .PassBtn(PassBtn),
        .mode(mode),
        .timeout(timeout),
        .LoggedIn(LoggedIn),
        .CheckPassword(CheckPassword),
        .MatchedID(MatchedID),
        .letterLEDs_id(letterLEDs_id),
        .letterLEDs_pw(letterLEDs_pw)
    );

    // 100MHz clock
    always #5 clk = ~clk;

    // Task: simulate one full button press with debounce clearance
    task press_button;
        begin
            PassBtn = 1;
            #20;           // Hold press longer
            PassBtn = 0;
            #80;           // Wait before next input
        end
    endtask

    initial begin
        // Reset and idle
        rst = 0;
        PassSwitches = 4'd0;
        PassBtn = 0;
        mode = 2'b00;
        timeout = 0;

        #50;
        rst = 1;

        // === ID ENTRY (mode 00) ===
        PassSwitches = 4'd9; press_button();   // ID[0]
        PassSwitches = 4'd9; press_button();   // ID[1]
        PassSwitches = 4'd9; press_button();   // ID[2]
        PassSwitches = 4'd9; press_button();   // ID[3]
        PassSwitches = 4'd9; press_button();   // ID[4]
        PassSwitches = 4'd9; press_button();   // ID[5]

        #200;

        // === PASSWORD ENTRY (mode 01) ===
        mode = 2'b01;
        PassSwitches = 4'd9; press_button();   // PW[0]
        PassSwitches = 4'd9; press_button();   // PW[1]
        PassSwitches = 4'd9; press_button();   // PW[2]
        PassSwitches = 4'd9; press_button();   // PW[3]
        PassSwitches = 4'd9; press_button();   // PW[4]
        PassSwitches = 4'd9; press_button();   // PW[5]

        #500;

        $stop;
    end

endmodule

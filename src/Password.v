// Password: Verifies a 6-digit password from ROM using the matched user ID.
// Resets immediately on wrong digit. Allows manual reset in mode 3 during timeout.

module Password (
    input wire clk,
    input wire rst,
    input wire CheckPassword,
    input wire PassBtn,
    input wire [3:0] InputPassword,
    input wire [2:0] MatchedID,
    input wire [1:0] mode,
    input wire timeout,
    output reg LoggedIn,
	 output reg [4:0] letterLEDs
);

    parameter Digit = 0, VERIFY = 1;
    reg [1:0] State;

    reg [2:0] counter;
    reg SFSG;
    reg load_compare;

    wire [5:0] ROM_address = MatchedID * 8 + counter;
    wire [3:0] DigitPassword;

    ROM_PSWD rom_inst (
        .address(ROM_address),
        .clock(clk),
        .q(DigitPassword)
    );

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            State <= Digit;
            counter <= 0;
            SFSG <= 1;
            LoggedIn <= 0;
            load_compare <= 0;
				letterLEDs <= 5'b00000;
        end else begin
            load_compare <= 0;

            if (mode == 2'b11 && timeout && PassBtn) begin
                State <= Digit;
                counter <= 0;
                SFSG <= 1;
                LoggedIn <= 0;
					 letterLEDs <= 5'b00000;
            end else begin
                case (State)
                    Digit: begin
                        if (CheckPassword && !LoggedIn) begin
                            if (PassBtn)
                                load_compare <= 1;
                            else if (load_compare) begin
                                if ((SFSG & (InputPassword == DigitPassword)) == 0) begin
                                    SFSG <= 1;
                                    counter <= 0;
												letterLEDs <= 5'b00000;
                                end else begin
                                    SFSG <= 1;
												letterLEDs[counter] <= 1;
                                    counter <= counter + 1;
                                    if (counter == 3'd5)
                                        State <= VERIFY;
                                end
                            end
                        end
                    end

                    VERIFY: begin
                        LoggedIn <= SFSG;
                        State <= Digit;
								letterLEDs <= 5'b00000;
                    end

                    default: State <= Digit;
                endcase
            end
        end
    end

endmodule

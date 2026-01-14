// Identification: Matches a 6-digit input ID against 5 stored ROM IDs and outputs matched index.

module Identification (
    input  wire        clk,
    input  wire        rst,
    input  wire        PassBtn,
    input  wire [3:0]  InputID,
    input  wire [1:0]  mode,
    input  wire        timeout,
    output reg         CheckPassword,
    output reg  [2:0]  MatchedID,
	 output reg [4:0] letterLEDs
);

    parameter ID = 0, VERIFY = 1;
    reg [1:0] State;

    reg [1:0] counter;
    reg [4:0] MatchSuccess;
    reg       load_compare;

    wire [3:0] DigitID_0, DigitID_1, DigitID_2, DigitID_3, DigitID_4;

    ROM_ID ID0 (.address(counter),        .clock(clk), .q(DigitID_0));
    ROM_ID ID1 (.address(counter + 8),    .clock(clk), .q(DigitID_1));
    ROM_ID ID2 (.address(counter + 16),   .clock(clk), .q(DigitID_2));
    ROM_ID ID3 (.address(counter + 24),   .clock(clk), .q(DigitID_3));
    ROM_ID ID4 (.address(counter + 32),   .clock(clk), .q(DigitID_4));

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            State         <= ID;
            counter       <= 0;
            MatchSuccess  <= 5'b11111;
            CheckPassword <= 0;
            load_compare  <= 0;
            MatchedID     <= 3'd7;
				letterLEDs <= 5'b00000;
        end else begin
            if (mode == 2'b11 && timeout && PassBtn) begin
                State         <= ID;
                counter       <= 0;
                MatchSuccess  <= 5'b11111;
                CheckPassword <= 0;
                load_compare  <= 0;
                MatchedID     <= 3'd7;
					 letterLEDs <= 5'b00000;
            end else begin
                CheckPassword <= 0;
                load_compare  <= 0;

                case (State)
                    ID: begin
                        if (PassBtn && !CheckPassword)
                            load_compare <= 1;
                        else if (load_compare) begin
                            // Update MatchSuccess flags
                            MatchSuccess[0] <= MatchSuccess[0] & (InputID == DigitID_0);
                            MatchSuccess[1] <= MatchSuccess[1] & (InputID == DigitID_1);
                            MatchSuccess[2] <= MatchSuccess[2] & (InputID == DigitID_2);
                            MatchSuccess[3] <= MatchSuccess[3] & (InputID == DigitID_3);
                            MatchSuccess[4] <= MatchSuccess[4] & (InputID == DigitID_4);

                            // Check for early rejection
                            if (((MatchSuccess & {
                                (InputID == DigitID_4),
                                (InputID == DigitID_3),
                                (InputID == DigitID_2),
                                (InputID == DigitID_1),
                                (InputID == DigitID_0)
                            }) == 5'b00000)) begin
                                State         <= ID;
                                counter       <= 0;
                                MatchSuccess  <= 5'b11111;
                                CheckPassword <= 0;
                                load_compare  <= 0;
                                MatchedID     <= 3'd7;
										  letterLEDs <= 5'b00000;
                            end else begin
									     letterLEDs[counter] <= 1;
                                counter <= counter + 1;
                                if (counter == 2'd3)
                                    State <= VERIFY;
                            end
                        end
                    end

                    VERIFY: begin
                        if (MatchSuccess == 5'b00000) begin
                            State         <= ID;
                            counter       <= 0;
                            MatchSuccess  <= 5'b11111;
                            CheckPassword <= 0;
                            load_compare  <= 0;
                            MatchedID     <= 3'd7;
                        end else begin
                            CheckPassword <= 1;
                            if      (MatchSuccess[0]) MatchedID <= 3'd0;
                            else if (MatchSuccess[1]) MatchedID <= 3'd1;
                            else if (MatchSuccess[2]) MatchedID <= 3'd2;
                            else if (MatchSuccess[3]) MatchedID <= 3'd3;
                            else if (MatchSuccess[4]) MatchedID <= 3'd4;
                        end
								letterLEDs <= 5'b00000;
                    end

                    default: State <= ID;
                endcase
            end
        end
    end

endmodule

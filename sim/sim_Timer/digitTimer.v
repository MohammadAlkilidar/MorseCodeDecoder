// digitTimer: Single digit countdown timer with rollover and borrow signaling.
// Rolls from 0 to 9 and asserts BorrowUp. Reconfig sets digit to 9. 

module digitTimer (
    input wire clk,
    input wire rst,
    input wire reconfig,
    input wire enable,
    input wire BorrowDown,
    input wire NoBorrowUp,
    output reg BorrowUp,
    output reg NoBorrowDown,
    output reg [3:0] Digit
);

    reg BorrowDown_prev;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            Digit <= 4'd0;
            BorrowUp <= 0;
            NoBorrowDown <= 1;
            BorrowDown_prev <= 0;
        end else begin
            BorrowDown_prev <= BorrowDown;

            if (reconfig) begin
                Digit <= 4'd9;
                NoBorrowDown <= 1;
            end else if (enable && BorrowDown && !BorrowDown_prev) begin
                if (Digit == 0) begin
                    Digit <= 4'd9;
                    BorrowUp <= 1;
                    NoBorrowDown <= 1;
                end else begin
                    Digit <= Digit - 1;
                    BorrowUp <= 0;
                    NoBorrowDown <= (Digit - 1 != 0);
                end
            end else begin
                BorrowUp <= 0;
            end
        end
    end

endmodule

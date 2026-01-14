// Rotates between 2'b00, 2'b01, and 2'b11 on each button press

module ModeRotator (
    input wire clk,
    input wire rst,
    input wire button,
    output reg [1:0] mode
);

    reg prev_button;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            mode <= 2'b00;
            prev_button <= 0;
        end else begin
            prev_button <= button;

            if (button && !prev_button) begin  // rising edge
                case (mode)
                    2'b00: mode <= 2'b01;
                    2'b01: mode <= 2'b11;
                    2'b11: mode <= 2'b00;
                    default: mode <= 2'b00;
                endcase
            end
        end
    end

endmodule

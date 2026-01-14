// ButtonShaper: Debounces button inputs to ensure clean, stable signals for the system.

module ButtonShaper (
    input wire B_in,
    output reg B_out,
    input wire clk,
    input wire rst
);

    reg [2:0] State, NextState;

    parameter INIT = 0, PULSE = 1, WAIT = 2;

    always @(*) begin
        case (State)
            INIT: begin
                B_out = 0;
                NextState = (B_in == 0) ? PULSE : INIT;
            end
            PULSE: begin
                B_out = 1;
                NextState = WAIT;
            end
            WAIT: begin
                B_out = 0;
                NextState = (B_in == 1) ? INIT : WAIT;
            end
            default: begin
                B_out = 0;
                NextState = INIT;
            end
        endcase
    end

    always @(posedge clk) begin
        if (!rst)
            State <= INIT;
        else
            State <= NextState;
    end

endmodule

// LoadRegister: Loads and stores a 4-bit value from switches when a button is pressed, only if logged in.

module LoadRegister (
    input wire [3:0] D_in,
    output reg [3:0] D_out,
    input wire clk,
    input wire rst,
    input wire Load
);

    always @(posedge clk) begin
        if (!rst)
            D_out <= 4'b0000;
        else if (Load)
            D_out <= D_in;
    end

endmodule

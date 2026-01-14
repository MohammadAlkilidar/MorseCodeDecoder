// OneSecTimer: Generates a 1Hz (1-second) pulse using three cascaded counters.

module OneSecTimer (
    input wire clk,
    input wire rst,
    input wire enable,
	 input wire [1:0] mode,
	 input wire ReconfigTimer,
    output wire timeout
);

    wire timeout_1ms, timeout_100ms;

    LFSR1ms u1ms (
        .clock(clk),
        .rst(rst),
        .enable(enable),
		  .mode(mode),
		  .ReconfigTimer(ReconfigTimer),
        .timeout(timeout_1ms)
    );

    CountTo100 u100 (
        .clk(timeout_1ms),
        .rst(rst),
        .timeout(timeout_100ms)
    );

    CountTo10 u10 (
        .clk(timeout_100ms),
        .rst(rst),
        .timeout(timeout)
    );

endmodule

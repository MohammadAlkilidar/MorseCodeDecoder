//Controls the main game phases by transitioning between idle, timer reset, gameplay, timeout, and restart states based on user login and timer signals.

module GameController (
    input wire clk,
    input wire rst,              
    input wire PassEnter,       
    input wire LoggedIn,         
    input wire Timeout,         
    input wire [1:0] mode,       
    output reg ReconfigTimer,    
    output reg enable          
);

    parameter IDLE = 0, PASSED = 1, RECONFIG = 2, GAMEPLAY = 3, GAMEOVER = 4;
    reg [2:0] State;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            State <= IDLE;
            ReconfigTimer <= 0;
            enable <= 0;
        end else begin
            if (PassEnter && mode == 2'b11 && Timeout) begin
                State <= IDLE;
                ReconfigTimer <= 1;
                enable <= 0;
            end else begin
                ReconfigTimer <= 0;
                enable <= 0;

                case (State)
                    IDLE: begin
                        if (LoggedIn)
                            State <= PASSED;
                    end

                    PASSED: State <= RECONFIG;

                    RECONFIG: begin
                        ReconfigTimer <= 1;
                        if (PassEnter && (mode == 2'b00 || mode == 2'b01 || mode == 2'b11))
                            State <= GAMEPLAY;
                    end

                    GAMEPLAY: begin
                        enable <= 1;
                        if (Timeout)
                            State <= GAMEOVER;
                    end

                    GAMEOVER: begin
                        enable <= 0;
                        if (PassEnter && mode == 2'b01 && Timeout)
                            State <= RECONFIG;
                    end

                    default: State <= IDLE;
                endcase
            end
        end
    end

endmodule

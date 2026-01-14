//VGATextRenderer: Displays text on VGA screen based on game state and selected level, with centered text.

module VGATextRenderer (
    input wire clk,             
    input wire rst,
    input wire LoggedIn,
    input wire CheckPassword,
    input wire enable,
    input wire [4:0] rand,    
    input wire GameTimeout,     
    input wire [3:0] Points,     
    output wire hsync,
    output wire vsync,
    output wire [3:0] red,
    output wire [3:0] green,
    output wire [3:0] blue
);

    parameter H_VISIBLE = 640;
    parameter H_TOTAL   = 800;
    parameter H_SYNC    = 96;
    parameter H_BP      = 48;
    parameter H_FP      = 16;

    parameter V_VISIBLE = 480;
    parameter V_TOTAL   = 525;
    parameter V_SYNC    = 2;
    parameter V_BP      = 33;
    parameter V_FP      = 10;

    reg [9:0] hcount = 0;
    reg [9:0] vcount = 0;

    wire visible = (hcount < H_VISIBLE) && (vcount < V_VISIBLE);
    assign hsync = ~(hcount >= (H_VISIBLE + H_FP) && hcount < (H_VISIBLE + H_FP + H_SYNC));
    assign vsync = ~(vcount >= (V_VISIBLE + V_FP) && vcount < (V_VISIBLE + V_FP + V_SYNC));

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            hcount <= 0;
            vcount <= 0;
        end else begin
            if (hcount == H_TOTAL - 1) begin
                hcount <= 0;
                if (vcount == V_TOTAL - 1)
                    vcount <= 0;
                else
                    vcount <= vcount + 1;
            end else begin
                hcount <= hcount + 1;
            end
        end
    end

    wire [6:0] char_col = hcount[9:3];
    wire [5:0] char_row = vcount[8:3];
    wire [2:0] pixel_x  = hcount[2:0];
    wire [2:0] pixel_y  = vcount[2:0];

    reg [7:0] message [0:47];
    reg [4:0] msg_len;
    reg [5:0] msg_row;
    integer i;

    always @(*) begin
        for (i = 0; i < 48; i = i + 1)
            message[i] = 8'd32;

        if (GameTimeout) begin
            message[0]  = "Y"; message[1]  = "O"; message[2]  = "U"; message[3]  = " ";
            message[4]  = "S"; message[5]  = "C"; message[6]  = "O"; message[7]  = "R";
            message[8]  = "E"; message[9]  = "D"; message[10] = " ";
            message[11] = Points + 8'd48;
            message[12] = " "; message[13] = "P"; message[14] = "O"; message[15] = "I";
            message[16] = "N"; message[17] = "T"; message[18] = "S";
           
            message[24] = "R"; message[25] = "E"; message[26] = "S"; message[27] = "T";
            message[28] = "A"; message[29] = "R"; message[30] = "T"; message[31] = " ";
            message[32] = "O"; message[33] = "R"; message[34] = " ";
            message[35] = "L"; message[36] = "O"; message[37] = "G"; message[38] = " ";
            message[39] = "O"; message[40] = "U"; message[41] = "T";

            msg_len = 20;
            msg_row = (char_row == 28) ? 28 : 30;

        end else if (!LoggedIn && !CheckPassword) begin
            message[0] = "E"; message[1] = "N"; message[2] = "T"; message[3] = "E";
            message[4] = "R"; message[5] = " "; message[6] = "I"; message[7] = "D";
            msg_len = 8;
            msg_row = 30;

        end else if (!LoggedIn && CheckPassword) begin
            message[0] = "E"; message[1] = "N"; message[2] = "T"; message[3] = "E";
            message[4] = "R"; message[5] = " "; message[6] = "P"; message[7] = "A";
            message[8] = "S"; message[9] = "S"; message[10] = "W"; message[11] = "O";
            message[12] = "R"; message[13] = "D";
            msg_len = 14;
            msg_row = 30;

        end else if (enable) begin
            case (rand)
                4'd0: begin message[0]="H"; message[1]="E"; message[2]="L"; message[3]="L"; message[4]="O"; end
                4'd1: begin message[0]="W"; message[1]="O"; message[2]="R"; message[3]="L"; message[4]="D"; end
                4'd2: begin message[0]="D"; message[1]="E"; message[2]="B"; message[3]="U"; message[4]="G"; end
                4'd3: begin message[0]="S"; message[1]="H"; message[2]="I"; message[3]="F"; message[4]="T"; end
                4'd4: begin message[0]="L"; message[1]="O"; message[2]="G"; message[3]="I"; message[4]="C"; end
                4'd5: begin message[0]="C"; message[1]="L"; message[2]="O"; message[3]="C"; message[4]="K"; end
                4'd6: begin message[0]="S"; message[1]="T"; message[2]="A"; message[3]="R"; message[4]="T"; end
                4'd7: begin message[0]="R"; message[1]="E"; message[2]="S"; message[3]="E"; message[4]="T"; end
                4'd8: begin message[0]="B"; message[1]="O"; message[2]="A"; message[3]="R"; message[4]="D"; end
                4'd9: begin message[0]="S"; message[1]="T"; message[2]="A"; message[3]="T"; message[4]="E"; end
                default: begin message[0]="E"; message[1]="R"; message[2]="R"; message[3]="4"; message[4]="!"; end
            endcase
            msg_len = 5;
            msg_row = 30;

        end else begin
            for (i = 0; i < 48; i = i + 1)
                message[i] = 8'd32;

            if (char_row == 28) begin
                message[0]  = "S"; message[1]  = "E"; message[2]  = "L"; message[3]  = "E";
                message[4]  = "C"; message[5]  = "T"; message[6]  = " "; message[7]  = "D";
                message[8]  = "I"; message[9]  = "F"; message[10] = "F"; message[11] = "I";
                message[12] = "C"; message[13] = "U"; message[14] = "L"; message[15] = "T";
                message[16] = "Y";
                msg_len = 17;
                msg_row = 28;
            end else if (char_row == 30) begin
                message[0] = "1"; message[1] = " "; message[2] = "2"; message[3] = " "; message[4] = "3";
                msg_len = 5;
                msg_row = 30;
            end else begin
                msg_len = 0;
                msg_row = 0;
            end
        end
    end

    wire [6:0] start_col = (80 - msg_len) >> 1;
    wire [6:0] char_index = char_col - start_col;

    reg [7:0] char_code;
    always @(*) begin
        if (GameTimeout) begin
            if (char_row == 28 && char_index < 20)
                char_code = message[char_index];
            else if (char_row == 30 && char_index < 18)
                char_code = message[char_index + 24]; 
            else
                char_code = 8'd32;
        end else if (char_row == msg_row && char_index < msg_len) begin
            char_code = message[char_index];
        end else begin
            char_code = 8'd32;
        end
    end

    wire [7:0] font_row;
    FontROM font (
        .char_code(char_code),
        .row(pixel_y),
        .pixels(font_row)
    );

    wire pixel_on = visible && font_row[7 - pixel_x];
    assign red   = pixel_on ? 4'hF : 4'h0;
    assign green = pixel_on ? 4'hF : 4'h0;
    assign blue  = pixel_on ? 4'hF : 4'h0;

endmodule

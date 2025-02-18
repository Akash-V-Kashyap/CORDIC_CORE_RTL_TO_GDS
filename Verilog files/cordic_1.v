module cordic_pipeline #(parameter WIDTH = 16, STAGES = 16) (
    input clk,
    input reset,
    input signed [WIDTH-1:0] x_in,
    input signed [WIDTH-1:0] y_in,
    input signed [WIDTH-1:0] angle_in,
    output signed [WIDTH-1:0] x_out,
    output signed [WIDTH-1:0] y_out
);
    // Lookup table for arctangent values (scaled by 2^WIDTH)
    wire signed [WIDTH-1:0] atan_table [0:STAGES-1];
    assign atan_table[0]  = 16'sd12868;  // atan(2^0) * 2^15
    assign atan_table[1]  = 16'sd7596;   // atan(2^-1) * 2^15
    assign atan_table[2]  = 16'sd4015;   // atan(2^-2) * 2^15
    assign atan_table[3]  = 16'sd2037;   // atan(2^-3) * 2^15
    assign atan_table[4]  = 16'sd1021;   // atan(2^-4) * 2^15
    assign atan_table[5]  = 16'sd511;    // atan(2^-5) * 2^15
    assign atan_table[6]  = 16'sd256;    // atan(2^-6) * 2^15
    assign atan_table[7]  = 16'sd128;    // atan(2^-7) * 2^15
    assign atan_table[8]  = 16'sd64;     // atan(2^-8) * 2^15
    assign atan_table[9]  = 16'sd32;     // atan(2^-9) * 2^15
    assign atan_table[10] = 16'sd16;     // atan(2^-10) * 2^15
    assign atan_table[11] = 16'sd8;      // atan(2^-11) * 2^15
    assign atan_table[12] = 16'sd4;      // atan(2^-12) * 2^15
    assign atan_table[13] = 16'sd2;      // atan(2^-13) * 2^15
    assign atan_table[14] = 16'sd1;      // atan(2^-14) * 2^15
    assign atan_table[15] = 16'sd0;      // atan(2^-15) * 2^15

    // Pipeline registers
    reg signed [WIDTH-1:0] x [0:STAGES];
    reg signed [WIDTH-1:0] y [0:STAGES];
    reg signed [WIDTH-1:0] z [0:STAGES];

    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i <= STAGES; i = i + 1) begin
                x[i] <= 0;
                y[i] <= 0;
                z[i] <= 0;
            end
        end else begin
            // Stage 0 input
            x[0] <= x_in;
            y[0] <= y_in;
            z[0] <= angle_in;

            // Pipeline stages
            for (i = 0; i < STAGES; i = i + 1) begin
                if (z[i] >= 0) begin
                    x[i+1] <= x[i] - (y[i] >>> i);
                    y[i+1] <= y[i] + (x[i] >>> i);
                    z[i+1] <= z[i] - atan_table[i];
                end else begin
                    x[i+1] <= x[i] + (y[i] >>> i);
                    y[i+1] <= y[i] - (x[i] >>> i);
                    z[i+1] <= z[i] + atan_table[i];
                end
            end
        end
    end

    // Outputs
    assign x_out = x[STAGES];
    assign y_out = y[STAGES];

endmodule

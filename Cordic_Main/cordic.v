module cordic_pipeline(
    input wire clk,
    input wire rst,
    input wire signed [15:0] x_in,    // Input X value
    input wire signed [15:0] y_in,    // Input Y value
    input wire signed [15:0] theta_in,// Input angle
    output wire signed [15:0] x_out,  // Output X value (cos)
    output wire signed [15:0] y_out   // Output Y value (sin)
);
    
    // Number of iterations
    parameter ITERATIONS = 16;

    // Array to store intermediate X, Y, and Z values for each stage
    reg signed [15:0] x [0:ITERATIONS-1];
    reg signed [15:0] y [0:ITERATIONS-1];
    reg signed [15:0] z [0:ITERATIONS-1];

    // Arctan values in U(8,8) fixed-point format
    wire signed [15:0] arctan_table [0:15];
    assign arctan_table[0]  = 16'd11520;  // atan(2^0) ≈ 45 degrees
    assign arctan_table[1]  = 16'd6800;   // atan(2^-1) ≈ 26.565 degrees
    assign arctan_table[2]  = 16'd3552;   // atan(2^-2) ≈ 14.036 degrees
    assign arctan_table[3]  = 16'd1804;   // atan(2^-3) ≈ 7.125 degrees
    assign arctan_table[4]  = 16'd906;    // atan(2^-4) ≈ 3.576 degrees
    assign arctan_table[5]  = 16'd455;    // atan(2^-5) ≈ 1.790 degrees
    assign arctan_table[6]  = 16'd227;    // atan(2^-6) ≈ 0.895 degrees
    assign arctan_table[7]  = 16'd114;    // atan(2^-7) ≈ 0.448 degrees
    assign arctan_table[8]  = 16'd57;     // atan(2^-8) ≈ 0.224 degrees
    assign arctan_table[9]  = 16'd28;     // atan(2^-9) ≈ 0.112 degrees
    assign arctan_table[10] = 16'd14;     // atan(2^-10) ≈ 0.056 degrees
    assign arctan_table[11] = 16'd7;      // atan(2^-11) ≈ 0.028 degrees
    assign arctan_table[12] = 16'd4;      // atan(2^-12) ≈ 0.014 degrees
    assign arctan_table[13] = 16'd2;      // atan(2^-13) ≈ 0.007 degrees
    assign arctan_table[14] = 16'd1;      // atan(2^-14) ≈ 0.004 degrees
    assign arctan_table[15] = 16'd0;      // atan(2^-15) ≈ 0.002 degrees

    // Pipelined CORDIC process
    genvar i;
    generate
        for (i = 0; i < ITERATIONS; i = i + 1) begin : cordic_stage
            always @(posedge clk or posedge rst) begin
                if (rst) begin
                    x[i] <= 0;
                    y[i] <= 0;
                    z[i] <= 0;
                end else if (i == 0) begin
                    // Initialize at the first stage
                    x[i] <= x_in;
                    y[i] <= y_in;
                    z[i] <= theta_in;
                end else begin
                    // CORDIC rotate based on sign of z
                    if (z[i-1] < 0) begin
                        x[i] <= x[i-1] + (y[i-1] >>> i);
                        y[i] <= y[i-1] - (x[i-1] >>> i);
                        z[i] <= z[i-1] + arctan_table[i-1];
                    end else begin
                        x[i] <= x[i-1] - (y[i-1] >>> i);
                        y[i] <= y[i-1] + (x[i-1] >>> i);
                        z[i] <= z[i-1] - arctan_table[i-1];
                    end
                end
            end
        end
    endgenerate

    // Output the final values
    assign x_out = x[ITERATIONS-1];
    assign y_out = y[ITERATIONS-1];

endmodule

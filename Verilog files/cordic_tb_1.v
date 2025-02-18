 module tb_cordic_pipeline;

    reg clk;
    reg reset;
    reg signed [15:0] x_in;
    reg signed [15:0] y_in;
    reg signed [15:0] angle_in;
    wire signed [15:0] x_out;
    wire signed [15:0] y_out;

    // Instantiate the CORDIC pipeline
    cordic_pipeline #(16, 16) uut (
        .clk(clk),
        .reset(reset),
        .x_in(x_in),
        .y_in(y_in),
        .angle_in(angle_in),
        .x_out(x_out),
        .y_out(y_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        x_in = 0;
        y_in = 0;
        angle_in = 0;

        // Apply reset
        #10;
        reset = 0;

        // Test multiple angles
        $display("Testing CORDIC for various angles:");
        $display("Angle (degrees) | X_out (Cosine) | Y_out (Sine)");

// Helper function to scale output
       function real fixed_to_real;
            input signed [15:0] value;
            fixed_to_real = value / 32768.0;  // Q15 scaling: Divide by 2^15
        endfunction
       
        // Test case 1: 0 degrees
        #10;
        x_in = 16'sd19896;  // Pre-scaled value of 0.607 * 2^15
        y_in = 0;
        angle_in = 16'sd0;  // 0 degrees in Q15 format
        #160;  // Wait for pipeline completion
        $display("       0        | %0.6f         | %0.6f", fixed_to_real(x_out), fixed_to_real(y_out));

        // Test case 2: 45 degrees
        #10;
        x_in = 16'sd19896;  // Pre-scaled value of 0.607 * 2^15
        y_in = 0;
        angle_in = 16'sd12868;  // 45 degrees in Q15 format (?/4 radians)
        #160;
        $display("      45        | %0.6f         | %0.6f", fixed_to_real(x_out), fixed_to_real(y_out));

        // Test case 3: 90 degrees
        #10;
        x_in = 16'sd19896;  // Pre-scaled value of 0.607 * 2^15
        y_in = 0;
        angle_in = 16'sd25735;  // 90 degrees in Q15 format (?/2 radians)
        #160;
        $display("      90        | %0.6f         | %0.6f", fixed_to_real(x_out), fixed_to_real(y_out));

        // Test case 4: -45 degrees
        #10;
        x_in = 16'sd19896;  // Pre-scaled value of 0.607 * 2^15
        y_in = 0;
        angle_in = -16'sd12868;  // -45 degrees in Q15 format (-?/4 radians)
        #160;
        $display("     -45        | %0.6f         | %0.6f", fixed_to_real(x_out), fixed_to_real(y_out));

        // Test case 5: 135 degrees
        #10;
        x_in = 16'sd19896;  // Pre-scaled value of 0.607 * 2^15
        y_in = 0;
        angle_in = 16'sd38603;  // 135 degrees in Q15 format (3?/4 radians)
        #160;
        $display("     135        | %0.6f         | %0.6f", fixed_to_real(x_out), fixed_to_real(y_out));

        // Test case 6: 180 degrees
        #10;
        x_in = 16'sd19896;  // Pre-scaled value of 0.607 * 2^15
        y_in = 0;
        angle_in = 16'sd51471;  // 180 degrees in Q15 format (? radians)
        #160;
        $display("     180        | %0.6f         | %0.6f", fixed_to_real(x_out), fixed_to_real(y_out));

        // Test case 7: -90 degrees
        #10;
        x_in = 16'sd19896;  // Pre-scaled value of 0.607 * 2^15
        y_in = 0;
        angle_in = -16'sd25735;  // -90 degrees in Q15 format (-?/2 radians)
        #160;
        $display("     -90        | %0.6f         | %0.6f", fixed_to_real(x_out), fixed_to_real(y_out));

        // End simulation
        $stop;
    end

endmodule


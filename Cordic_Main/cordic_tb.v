module tb_cordic_pipeline;

    // Testbench signals
    reg clk;
    reg rst;
    reg signed [15:0] x_in;
    reg signed [15:0] y_in;
    reg signed [15:0] theta_in;
    wire signed [15:0] x_out;
    wire signed [15:0] y_out;

    // Instantiate the CORDIC module
    cordic_pipeline cordic_inst (
        .clk(clk),
        .rst(rst),
        .x_in(x_in),
        .y_in(y_in),
        .theta_in(theta_in),
        .x_out(x_out),
        .y_out(y_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Clock period of 10ns
    end

    // Reset and input stimulus
    initial begin
        // Apply reset
        rst = 1;
        #10;
        rst = 0;

        // Test case 1: Zero angle (theta = 0)
        x_in = 16'd32768;  // Input vector magnitude in fixed-point (1.0 in Q(1,15) format)
        y_in = 16'd0;      // Zero y component
        theta_in = 16'd0;  // Theta = 0 degrees in U(8,8)
        #100;

        // Test case 2: 45 degrees
        x_in = 16'd32768;
        y_in = 16'd0;
        theta_in = 16'd11520;  // Theta = 45 degrees in U(8,8)
        #100;

        // Test case 3: 90 degrees
        x_in = 16'd32768;
        y_in = 16'd0;
        theta_in = 16'd23040;  // Theta = 90 degrees in U(8,8)
        #100;

        // Test case 4: -45 degrees
        x_in = 16'd32768;
        y_in = 16'd0;
        theta_in = -16'd11520;  // Theta = -45 degrees in U(8,8)
        #100;

        // Test case 5: 180 degrees
        x_in = 16'd32768;
        y_in = 16'd0;
        theta_in = 16'd46080;  // Theta = 180 degrees in U(8,8)
        #100;

        // Test case 6: Custom angle (e.g., 30 degrees)
        x_in = 16'd32768;
        y_in = 16'd0;
        theta_in = 16'd7680;  // Theta = 30 degrees in U(8,8)
        #100;

        // Finish simulation
        $stop;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | X_in: %0d | Y_in: %0d | Theta_in: %0d | X_out: %0d | Y_out: %0d",$time, x_in, y_in, theta_in, x_out, y_out);
    end

endmodule

`timescale 1ns/1ps

module tb_streamed_led;
    reg clk;
    reg rstn;
    reg mode;
    wire [7:0] led;

    parameter CLK_PERIOD = 100; // 10 MHz
    parameter MODE_CHANGE_PERIOD = 10e5; // 10 seconds
    integer mode_counter;

    // Instantiate the module
    streamed_led u1(
        .clk(clk),
        .rstn(rstn),
        .mode(mode),
        .led(led)
    );

    // Clock generator
    always
    begin
        #CLK_PERIOD clk = ~clk;
    end

    // Mode change
    always @(posedge clk)
    begin
        if (mode_counter >= MODE_CHANGE_PERIOD/CLK_PERIOD)
        begin
            mode = ~mode;
            mode_counter = 0;
        end
        else
            mode_counter = mode_counter + 1;
    end

    // Test procedure
    initial
    begin
        // Initialization
        clk = 0;
        rstn = 0;
        mode = 0;
        mode_counter = 0;
        
        #CLK_PERIOD;
        rstn = 1;

        // Keep the testbench running
        #1e12;
        
        // End of test
        $stop;
    end
endmodule

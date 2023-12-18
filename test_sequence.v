`timescale 1ns/1ps

module tb_sequence;
    reg clk;
    reg rstn;
    reg A;
    reg B;
    wire flag;

    parameter CLK_PERIOD = 10; // 10 MHz
    parameter KEY_PERIOD = 200; // 1 ms

    // Instantiate the module
    sequence u1(
        .clk(clk),
        .rstn(rstn),
        .A(A),
        .B(B),
        .flag(flag)
    );

    // Clock generator
    always
    begin
        #CLK_PERIOD clk = ~clk;
    end

    // Test procedure
    initial
    begin
        // Initialization
        clk = 0;
        rstn = 0;
        A = 0;
        B = 0;
        
        #CLK_PERIOD;
        rstn = 1;

        // Input sequence ABBAA
        #KEY_PERIOD A = 1; B = 0;
        #KEY_PERIOD A = 0; B = 1;
        #KEY_PERIOD;
        #KEY_PERIOD A = 1; B = 0;
        #KEY_PERIOD;
        #KEY_PERIOD;
        A = 0; B = 0;

        // Input sequence ABBABBAA
        #KEY_PERIOD A = 1; B = 0;
        #KEY_PERIOD A = 0; B = 1;
        #KEY_PERIOD;
        #KEY_PERIOD A = 1; B = 0;
        #KEY_PERIOD A = 0; B = 1;
        #KEY_PERIOD;
        #KEY_PERIOD A = 1; B = 0;
        #KEY_PERIOD;
        #KEY_PERIOD;
        A = 0; B = 0;

        // Input sequence ABBBB
        #KEY_PERIOD A = 1; B = 0;
        #KEY_PERIOD A = 0; B = 1;
        #KEY_PERIOD;
        #KEY_PERIOD;
        #KEY_PERIOD;
        A = 0; B = 0;

        // Keep the testbench running
        #1e12;
        
        // End of test
        $stop;
    end
endmodule


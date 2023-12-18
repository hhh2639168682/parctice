`timescale 1ns/1ns
module testbench();
    reg clk_a,clk_b,rst_n;
    wire data_req,data_ack;
    wire [3:0]data;
    
initial begin
    clk_a = 1;
    clk_b = 1;
    rst_n = 0;
    //$dumpfile("out.vcd");
   // $dumpvars(0,testbench);
#30    
    rst_n = 1;    
#5000 $stop;
end

//always #15 clk_a = ~clk_a;
//always #10 clk_b = ~clk_b;
always #10 clk_a = ~clk_a;
always #20 clk_b = ~clk_b;

data_driver dut_1
(     .clk_a(clk_a),
    .rst_n(rst_n),
    .data(data),
    .data_ack(data_ack),
    .data_req(data_req)
);

data_receiver dut_2
(     .clk_b(clk_b),
    .rst_n(rst_n),
    .data(data),
    .data_ack(data_ack),
    .data_req(data_req)
);
endmodule

`timescale 1ns/1ns
module width_8to16_tb;

  // 定义时钟和复位信号
  reg clk;
  reg rst_n;

  // 定义输入信号
  reg valid_in;
  reg [7:0] data_in;

  // 定义输出信号
  wire valid_out;
  wire [15:0] data_out;

  // 实例化 width_8to16 模块
  width_8to16 dut (
    .clk(clk),
    .rst_n(rst_n),
    .valid_in(valid_in),
    .data_in(data_in),
    .valid_out(valid_out),
    .data_out(data_out)
  );

  // 定义时钟
  always #5 clk = ~clk;

  // 初始化时钟和复位信号
  initial begin
    clk = 0;
    rst_n = 0;
    #10 rst_n = 1;
  end

  // 生成输入数据
  initial begin
    valid_in = 0;
    data_in = 0;
    
    // 模拟输入数据 0x45
    #15 valid_in = 1;
    data_in = 8'h45;

    // 模拟输入数据 0xAB
    #10 valid_in = 1;
    data_in = 8'hAB;

    // 模拟输入数据 0xF2
    #10 valid_in = 1;
    data_in = 8'hF2;

    // 等待输出稳定
    #10;
    valid_in = '0;
    
    // 检查输出数据
    $display("Output data_out = %h", data_out);
    
    // 模拟输入数据 0x38
    #10 valid_in = 1;
    data_in = 8'h38;

    // 等待输出稳定
    #10;
     valid_in = 0;
    // 检查输出数据
    $display("Output data_out = %h", data_out);
    
    // 模拟输入数据 0x00
    //#10 valid_in = 1;
    //data_in = 8'h00;

    // 等待输出稳定
    #10;

    // 检查输出数据
    $display("Output data_out = %h", data_out);
    
    // 模拟数据无效
    #10 valid_in = 0;
    data_in = 8'h00;

    // 等待输出稳定
    #10;

    // 检查输出数据
    $display("Output data_out = %h", data_out);

    // 结束仿真
    #10 $stop;
  end

endmodule
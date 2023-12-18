`timescale 1ns/1ns
module asy_fifo_tb;
    parameter width = 8;
    parameter depth = 16;

    reg wr_clk, rd_clk;
    reg wr_rstn, rd_rstn;
    reg wr_inc, rd_inc;
    reg [width - 1:0] wr_data;

    wire fifo_full, fifo_empty;
    wire [width - 1:0] rd_data;

    //实例化
    asyn_fifo #(.WIDTH(width), .DEPTH(depth)) myfifo (
        .wclk(wr_clk),
        .rclk(rd_clk),
        .wrstn(wr_rstn),
        .rrstn(rd_rstn),
        .winc(wr_inc),
        .rinc(rd_inc),
        .wdata(wr_data),
        .rdata(rd_data),
        .wfull(fifo_full),
        .rempty(fifo_empty)
    );

    //时钟
    initial begin
        rd_clk = 0;
        forever #25 rd_clk = ~rd_clk;
    end

    initial begin
        wr_clk = 0;
        forever #30 wr_clk = ~wr_clk;
    end

    // //波形显示
    // initial begin
    //     $fsdbDumpfile("wave.fsdb");
    //     $fsdbDumpvars(0, myfifo);
    //     $fsdbDumpon();
    // end

    //赋值
    initial begin
        wr_inc = 0;
        rd_inc = 0;
        wr_rstn = 1;
        rd_rstn = 1;

        #10;
        wr_rstn = 0;
        rd_rstn = 0;

        #20;
        wr_rstn = 1;
        rd_rstn = 1;

        @(negedge wr_clk)
        wr_data = {$random}%30;
        wr_inc = 1;

        repeat(7) begin
            @(negedge wr_clk)
            wr_data = {$random}%30;
        end

        @(negedge wr_clk)
        wr_inc = 0;

        @(negedge rd_clk)
        rd_inc = 1;

        repeat(7) begin
            @(negedge rd_clk);
        end

        @(negedge rd_clk)
        rd_inc = 0;

        #150;

        @(negedge wr_clk)
        wr_inc = 1;
        wr_data = {$random}%30;

        repeat(15) begin
            @(negedge wr_clk)
            wr_data = {$random}%30;
        end

        @(negedge wr_clk)
        wr_inc = 0;

        #50;
        $finish;
    end

endmodule

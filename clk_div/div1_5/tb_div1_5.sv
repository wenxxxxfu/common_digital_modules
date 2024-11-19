`timescale 1ns / 1ps
module tb_div1_5();
    reg clk_in;
    reg rst_n;
    wire clk_out;

    initial begin
        clk_in = 0;
        rst_n = 0;
        #100
        rst_n = 1;
        #500
        $finish;
    end

    always #5 clk_in = ~clk_in;

    div1_5 u0(
        .clk_in(clk_in),
        .rst_n(rst_n),
        .clk_out(clk_out)
        );

    initial	begin
        $fsdbDumpfile("tb.fsdb");//这个是产生名为tb.fsdb的文件
        $fsdbDumpvars;
    end


endmodule
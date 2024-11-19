`timescale 1ns / 1ps
`include "../div3/div3.sv"
module div1_5(
    input  logic clk_in,
    input  logic rst_n,
    output logic clk_out
);

    logic clk_in_div3, clk_temp;

    assign clk_temp = clk_in_div3 ? clk_in : ~clk_in;

    div3 u_div3(.clk_in(clk_in), .rst_n(rst_n), .clk_out(clk_in_div3));

    always_ff @(posedge clk_temp or negedge rst_n)begin
        if(~rst_n)
            clk_out <= 1'b0;
        else begin
            clk_out <= ~clk_out;
            end
        end
endmodule




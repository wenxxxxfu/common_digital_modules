`timescale 1ns / 1ps

module div4_5(
    input  logic clk_in,
    input  logic rst_n,
    output logic clk_out
);

    logic [8:0] shift_count;
    logic inv_count1, inv_count5, inv_count6 ;


    always_ff @(posedge clk_in or negedge rst_n)begin
        if(~rst_n) begin
            shift_count <= 9'b0_0000_0001;
        end else begin
            shift_count <= {shift_count[7:0], shift_count[8]};
            end
        end

    always_ff @(negedge clk_in or negedge rst_n)begin
        if(~rst_n) begin
            inv_count1 <= 'b0;
            inv_count5 <= 'b0;
            inv_count6 <= 'b0;
        end else begin
            inv_count1 <= shift_count[0];
            inv_count5 <= shift_count[4];
            inv_count6 <= shift_count[5];
            end
        end

    assign clk_out = shift_count[0] | shift_count[1] | inv_count1 | shift_count[5] | inv_count5 | inv_count6;
endmodule




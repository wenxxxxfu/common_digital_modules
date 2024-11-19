`timescale 1ns / 1ps
module div3 (
    input  logic clk_in,
    input  logic rst_n,
    output logic clk_out
    
);

    logic [1:0] count;
    logic tff1, tff2;
    always_ff @( posedge clk_in or negedge rst_n) begin 
        if (!rst_n) begin
            count <= 'b0;
        end else begin
           count <= count<2 ? count + 'b1:'b0; 
        end    
    end

    always_ff @( posedge clk_in or negedge rst_n) begin 
        if (!rst_n) begin
            tff1 <= 'b0;
        end else if (count==0) begin
           tff1 <= ~tff1; 
        end
    end

    always_ff @( negedge clk_in or negedge rst_n) begin 
        if (!rst_n) begin
            tff2<= 'b0; 
        end else if (count==2) begin
           tff2 <= ~tff2;  
        end
    end

    assign clk_out = tff1 ^ tff2;

endmodule
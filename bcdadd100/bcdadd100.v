module top_module( 
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum 
);
  
    wire [100:0] out; // 101 bits for carry signals
    genvar i; 

    // Generate BCD adders
    generate
        for (i = 0; i < 100; i = i + 1) begin : bcd_adder
            bcd_fadd u_add (
                .a(a[(i+1)*4-1:i*4]), // Corrected slicing
                .b(b[(i+1)*4-1:i*4]), // Corrected slicing
                .cin(out[i]),         // Carry in from previous stage
                .cout(out[i+1]),     // Carry out to next stage
                .sum(sum[(i+1)*4-1:i*4]) // Corrected slicing
            );
        end
    endgenerate

    assign out[0] = cin; // Initialize the first carry input
    assign cout = out[100]; // Connect cout to the last carry output

endmodule

Create a 4-bit wide, 256-to-1 multiplexer. The 256 4-bit inputs are all packed into a single 1024-bit input vector. sel=0 should select bits in[3:0], sel=1 selects bits in[7:4], sel=2 selects bits in[11:8], etc.

Expected solution length: Around 1–5 lines.

Module Declaration
```key
module top_module( 
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out );
```

!!!warning, the following code is wrong:
```key
module top_module( 
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out );
    assign out = in[sel*4+3:sel*4];
endmodule
```
Error (10734): Verilog HDL error at top_module.v(5): sel is not a constant File: xxx/xxx/xxx/xxx.v Line: 5

This is to say: although A[a] such a single inside a can not be constant; But in vector A[a:b], a and b must be constants
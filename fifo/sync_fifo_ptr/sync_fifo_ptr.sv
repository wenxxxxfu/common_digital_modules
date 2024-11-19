
`timescale 1ns/1ns	//时间单位/精度

module	sync_fifo_ptr
#(
    parameter   DATA_WIDTH = 'd8  ,							//FIFO位宽
    parameter   DATA_DEPTH = 'd16 							//FIFO深度
)
(
    input                                   clk		    ,       //系统时钟
    input                                   rst_n	    ,       //低电平有效的复位信号
    input   [DATA_WIDTH-1:0]                data_in	    ,       //写入的数据
    input                                   rd_en	    ,       //读使能信号，高电平有效
    input                                   wr_en	    ,       //写使能信号，高电平有效
															
    output  reg [DATA_WIDTH-1:0]            data_out    ,       //输出的数据
    output                                  empty	    ,       //空标志，高电平表示当前FIFO已被写满
    output                                  full            //满标志，高电平表示当前FIFO已被读空
 

);

    //reg define
    reg [DATA_WIDTH - 1 : 0] fifo_ram   [DATA_DEPTH - 1 : 0]        ;  //用二维数组实现RAM	
    reg [$clog2(DATA_DEPTH)   : 0]    wr_ptr, rd_ptr	            ;  //地址指针，位宽多一位
    reg [$clog2(DATA_DEPTH) -1: 0]    wr_ptr_true, rd_ptr_true	    ;  //地址指针，位宽多一位
    reg wr_ptr_msb, rd_ptr_msb	; //地址指针，位宽多一位

    assign {wr_ptr_msb, wr_ptr_true} = wr_ptr;
    assign {rd_ptr_msb, rd_ptr_true} = rd_ptr;

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            wr_ptr      <= 'b0;
        end else if(wr_en && !full) begin
            fifo_ram[wr_ptr_true] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end
    end

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            rd_ptr      <= 'b0;
        end else if(rd_en && !empty) begin
            data_out <= fifo_ram[rd_ptr_true];
            rd_ptr <= rd_ptr + 1;
        end 
    end

    assign full = (wr_ptr_true == rd_ptr_true) && ( wr_ptr_msb !=  rd_ptr_msb);
    assign empty = (wr_ptr == rd_ptr) ;
endmodule
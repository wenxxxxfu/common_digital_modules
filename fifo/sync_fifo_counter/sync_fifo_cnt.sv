
`timescale 1ns/1ns	//时间单位/精度
//计数器法实现同步FIFO
module	sync_fifo_cnt
#(
    parameter   DATA_WIDTH = 'd8                    ,       //FIFO位宽
    parameter   DATA_DEPTH = 'd16                           //FIFO深度
)
(
    input                                   clk     ,       //系统时钟
    input                                   rst_n   ,       //低电平有效的复位信号
    input   [DATA_WIDTH-1:0]                data_in ,       //写入的数据
    input                                   rd_en   ,       //读使能信号，高电平有效
    input                                   wr_en   ,       //写使能信号，高电平有效
															
    output  reg [DATA_WIDTH-1:0]            data_out,       //输出的数据
    output                                  empty   ,       //空标志，高电平表示当前FIFO已被写满
    output                                  full    ,       //满标志，高电平表示当前FIFO已被读空
    output  reg [$clog2(DATA_DEPTH) : 0]    fifo_cnt        //$clog2是以2为底取对数	

);

    //reg define
    reg [DATA_WIDTH - 1 : 0] fifo_ram [DATA_DEPTH - 1 : 0];	//用二维数组实现RAM	
    reg [$clog2(DATA_DEPTH) - 1 : 0]    wr_addr, rd_addr  ;

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            wr_addr <= 'b0;
        end else if(wr_en & !full) begin
            fifo_ram[wr_addr] <= data_in;
            wr_addr <= wr_addr + 1;
        end 
    end

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n)begin  
            rd_addr <= 'b0;
        end else if(rd_en & !empty ) begin
            data_out <= fifo_ram[rd_addr];
            rd_addr  <= rd_addr + 1;
        end 
    end

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            fifo_cnt <= 'b0;
        end else if(wr_en & !full & !rd_en) begin
            fifo_cnt <= fifo_cnt + 1;
        end else if(rd_en & !empty & !wr_en) begin
            fifo_cnt <= fifo_cnt - 1;
        end else if(rd_en & wr_en) begin;
            fifo_cnt <= fifo_cnt;
        end 
    end

    assign full = fifo_cnt == DATA_DEPTH;
    assign empty = fifo_cnt == 0;
endmodule
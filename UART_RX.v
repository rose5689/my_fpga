

module UART_RX(
	input        clk	,
	input        rst_n    ,
	input        RX         ,
	
	output reg [7:0] DATA    ,
	output reg       valid
    );
//将输入的rx进行二级缓存
reg rx_reg0 ;	
reg rx_reg1 ;

wire rx_nedge;//监测rx_reg1的下降沿	

	
always@(posedge clk or negedge rst_n)
    if(rst_n == 1'b0)
	begin
		rx_reg0   <=1'b1;
	    rx_reg1   <=1'b1;
	end
	else
	begin
	    rx_reg0   <=RX      ;
		rx_reg1   <=rx_reg0 ;
	end

assign rx_nedge=(!rx_reg0&rx_reg1)?1:0;
//设计一个使能信号，指示当前正在进行数据的接收
reg  rx_en;
always@(posedge clk or negedge rst_n)
    if(rst_n == 1'b0)
		rx_en<=0;
	else if(rx_nedge==1)
		rx_en<=1;
	else if(valid==1)
		rx_en<=0;
	else
		rx_en<=rx_en;
		
//设计一个计数器，计数每个bit需要的时钟周期数
localparam CLK_FREQENCE=50_000_000;
localparam BPS=115200;
localparam DELAY=CLK_FREQENCE/BPS;

reg [31:0] cnt_bps;
always@(posedge clk or negedge rst_n)
    if(rst_n == 1'b0)
		cnt_bps<=0;
	else if(rx_en==1)begin
		if(cnt_bps==DELAY-1)
			cnt_bps<=0;
		else 
			cnt_bps<=cnt_bps+1;
	end
	else
		cnt_bps<=0;
//////设计一个计数器，计数目前接收的是哪个bit///////////////////////////////
reg [31:0] cnt_bit;
always@(posedge clk or negedge rst_n)
    if(rst_n == 1'b0)
		cnt_bit<=0;
	else if(rx_en==1)begin
		if((cnt_bps==DELAY-1)&&(cnt_bit==9))
			cnt_bit<=0;
		else if(cnt_bps==DELAY-1)
			cnt_bit<=cnt_bit+1;	
	end
	else
		cnt_bit<=0;
//根据计数器定位需要采样的值	
reg [7:0] rx_data_req;
always@(posedge clk or negedge rst_n)
    if(rst_n == 1'b0)
		rx_data_req<=0;
	else if(cnt_bit>0&&cnt_bit<9&&cnt_bps==DELAY/2-1)begin
		rx_data_req[cnt_bit-1]<=rx_reg1;
	end
	else
		rx_data_req<=rx_data_req;
//对最后一个数据做一个统一的输出
always@(posedge clk or negedge rst_n)
    if(rst_n == 1'b0)begin
		DATA<=0;
		valid<=0;
	end
	else if(cnt_bit==9&&cnt_bps==DELAY/2-1)begin
	    DATA <=rx_data_req;
	    valid <=1;
	end
	else begin
		valid<=0;
		
	end
endmodule

 



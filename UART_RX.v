

module UART_RX(
	input        clk	,
	input        rst_n    ,
	input        RX         ,
	
	output reg [7:0] DATA    ,
	output reg       valid
    );
//�������rx���ж�������
reg rx_reg0 ;	
reg rx_reg1 ;

wire rx_nedge;//���rx_reg1���½���	

	
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
//���һ��ʹ���źţ�ָʾ��ǰ���ڽ������ݵĽ���
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
		
//���һ��������������ÿ��bit��Ҫ��ʱ��������
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
//////���һ��������������Ŀǰ���յ����ĸ�bit///////////////////////////////
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
//���ݼ�������λ��Ҫ������ֵ	
reg [7:0] rx_data_req;
always@(posedge clk or negedge rst_n)
    if(rst_n == 1'b0)
		rx_data_req<=0;
	else if(cnt_bit>0&&cnt_bit<9&&cnt_bps==DELAY/2-1)begin
		rx_data_req[cnt_bit-1]<=rx_reg1;
	end
	else
		rx_data_req<=rx_data_req;
//�����һ��������һ��ͳһ�����
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

 



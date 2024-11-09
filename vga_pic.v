module vga_pic(
    input wire          vga_clk     , //输入工作时钟,频率25MHz
    input wire          sys_clk     , //输入RAM写时钟,频率50MHz
    input wire          sys_rst_n   , //输入复位信号,低电平有效
    input wire [7:0]    pi_data     , //输入RAM写数据
    input wire          pi_flag     , //输入RAM写使能
    input wire [9:0]    pix_x       , //输入有效显示区域像素点X轴坐标
    input wire [9:0]    pix_y       , //输入有效显示区域像素点Y轴坐标
    output wire [7:0]   pix_data_out,  //输出VGA显示图像数据
	output				o_pic_valid,
	output [7:0]		o_pic_data
);

parameter H_VALID = 10'd640 , //行有效数据
          V_VALID = 10'd480 ; //场有效数据

parameter H_PIC   = 10'd172   , //图片长度
          W_PIC   = 10'd172   , //图片宽度
          PIC_SIZE= 15'd29584 ; //图片像素个数

parameter RED   = 8'b1110_0000 , //红色
          GREEN = 8'b0001_1100 , //绿色
          BLUE  = 8'b0000_0011 , //蓝色
          BLACK = 8'b0000_0000 , //黑色
          WHITE = 8'b1111_1111 ; //白色


wire        rd_en    ; //RAM读使能
wire [7:0]  pic_data ; //自RAM读出的图片数据

reg [14:0]  wr_addr   ; //ram写地址
reg [14:0]  rd_addr   ; //ram读地址
reg         pic_valid ; //图片数据有效信号
reg [7:0]   pix_data  ; //背景色彩信息


//wr_addr:ram写地址
always@(posedge sys_clk or negedge sys_rst_n)begin
    if(sys_rst_n == 1'b0)
        wr_addr <= 16'd0;
    else if((wr_addr == (PIC_SIZE - 1'b1)) && (pi_flag == 1'b1))
        wr_addr <= 16'd0;
    else if(pi_flag == 1'b1)
        wr_addr <= wr_addr + 1'b1;
end

//rd_addr:ram读地址
always@(posedge vga_clk or negedge sys_rst_n)begin
    if(sys_rst_n == 1'b0)
        rd_addr <= 16'd0;
    else if(rd_addr == (PIC_SIZE - 1'b1))
        rd_addr <= 16'd0;
    else if(rd_en == 1'b1)
        rd_addr <= rd_addr + 1'b1;
    else
        rd_addr <= rd_addr;
end

//rd_en:RAM读使能
assign rd_en = (((pix_x >= (((H_VALID - H_PIC)/2) - 1'b1)) && (pix_x < (((H_VALID - H_PIC)/2) + H_PIC -1)))
                &&((pix_y >= ((V_VALID - W_PIC)/2)) && ((pix_y < (((V_VALID - W_PIC)/2) + W_PIC)))));

//pic_valid:图片数据有效信号
always@(posedge vga_clk or negedge sys_rst_n)begin
    if(sys_rst_n == 1'b0)
        pic_valid <= 1'b1;
    else
        pic_valid <= rd_en;
end

assign o_pic_valid = pic_valid;
assign o_pic_data = pic_data;

//pix_data_out:输出VGA显示图像数据
assign pix_data_out = (pic_valid == 1'b1) ? pic_data : pix_data;

//根据当前像素点坐标指定当前像素点颜色数据，在屏幕上显示彩条
always@(posedge vga_clk or negedge sys_rst_n)begin
        if(sys_rst_n == 1'b0)
        pix_data <= 8'd0;
    else if((pix_x >= 0) && (pix_x < (H_VALID/10)*1))
        pix_data <= RED;
    else if((pix_x >= (H_VALID/10)*1) && (pix_x < (H_VALID/10)*2))
        pix_data <= GREEN;
    else if((pix_x >= (H_VALID/10)*2) && (pix_x < (H_VALID/10)*3))
        pix_data <= BLUE;
    else if((pix_x >= (H_VALID/10)*3) && (pix_x < (H_VALID/10)*4))
        pix_data <= BLACK;
    else if((pix_x >= (H_VALID/10)*4) && (pix_x < (H_VALID/10)*5))
        pix_data <= WHITE;
    else if((pix_x >= (H_VALID/10)*5) && (pix_x < (H_VALID/10)*6))
        pix_data <= RED;
    else if((pix_x >= (H_VALID/10)*6) && (pix_x < (H_VALID/10)*7))
        pix_data <= GREEN;
    else if((pix_x >= (H_VALID/10)*7) && (pix_x < (H_VALID/10)*8))
        pix_data <= BLUE;
    else if((pix_x >= (H_VALID/10)*8) && (pix_x < (H_VALID/10)*9))
        pix_data <= BLACK;
    else if((pix_x >= (H_VALID/10)*9) && (pix_x < H_VALID))
        pix_data <= WHITE;
    else
        pix_data <= BLACK;
end

 
/*  ram_pic ram_pic_inst (
  .clka(sys_clk),    // input wire clka            输入RAM写时钟,50MHz,1bi
  .wea(pi_flag),      // input wire [0 : 0] wea    输入RAM写使能,1bit     
  .addra(wr_addr),  // input wire [3 : 0] addra    输入RAM写地址,15bit    
  .dina(pi_data),    // input wire [7 : 0] dina    输入写入RAM的图片数据,8bit 
  .clkb(vga_clk),    // input wire clkb            输入RAM读时钟,25MHz,1bi
  .addrb(rd_addr),  // input wire [3 : 0] addrb    输入RAM读地址,15bit    
  .doutb(pic_data)  // output wire [7 : 0] doutb   输出读取RAM的图片数据,8bit 
); */
ram_pic ram_pic_inst (
  .clka(sys_clk),    // input wire clka
  .wea(pi_flag),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [15 : 0] addra
  .dina(pi_data),    // input wire [15 : 0] dina
  .clkb(vga_clk),    // input wire clkb
  //.enb(enb),      // input wire enb
  .addrb(rd_addr),  // input wire [15 : 0] addrb
  .doutb(pic_data)  // output wire [15 : 0] doutb
);
 endmodule
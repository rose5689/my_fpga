module vga_pic(
    input wire          vga_clk     , //���빤��ʱ��,Ƶ��25MHz
    input wire          sys_clk     , //����RAMдʱ��,Ƶ��50MHz
    input wire          sys_rst_n   , //���븴λ�ź�,�͵�ƽ��Ч
    input wire [7:0]    pi_data     , //����RAMд����
    input wire          pi_flag     , //����RAMдʹ��
    input wire [9:0]    pix_x       , //������Ч��ʾ�������ص�X������
    input wire [9:0]    pix_y       , //������Ч��ʾ�������ص�Y������
    output wire [7:0]   pix_data_out,  //���VGA��ʾͼ������
	output				o_pic_valid,
	output [7:0]		o_pic_data
);

parameter H_VALID = 10'd640 , //����Ч����
          V_VALID = 10'd480 ; //����Ч����

parameter H_PIC   = 10'd172   , //ͼƬ����
          W_PIC   = 10'd172   , //ͼƬ���
          PIC_SIZE= 15'd29584 ; //ͼƬ���ظ���

parameter RED   = 8'b1110_0000 , //��ɫ
          GREEN = 8'b0001_1100 , //��ɫ
          BLUE  = 8'b0000_0011 , //��ɫ
          BLACK = 8'b0000_0000 , //��ɫ
          WHITE = 8'b1111_1111 ; //��ɫ


wire        rd_en    ; //RAM��ʹ��
wire [7:0]  pic_data ; //��RAM������ͼƬ����

reg [14:0]  wr_addr   ; //ramд��ַ
reg [14:0]  rd_addr   ; //ram����ַ
reg         pic_valid ; //ͼƬ������Ч�ź�
reg [7:0]   pix_data  ; //����ɫ����Ϣ


//wr_addr:ramд��ַ
always@(posedge sys_clk or negedge sys_rst_n)begin
    if(sys_rst_n == 1'b0)
        wr_addr <= 16'd0;
    else if((wr_addr == (PIC_SIZE - 1'b1)) && (pi_flag == 1'b1))
        wr_addr <= 16'd0;
    else if(pi_flag == 1'b1)
        wr_addr <= wr_addr + 1'b1;
end

//rd_addr:ram����ַ
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

//rd_en:RAM��ʹ��
assign rd_en = (((pix_x >= (((H_VALID - H_PIC)/2) - 1'b1)) && (pix_x < (((H_VALID - H_PIC)/2) + H_PIC -1)))
                &&((pix_y >= ((V_VALID - W_PIC)/2)) && ((pix_y < (((V_VALID - W_PIC)/2) + W_PIC)))));

//pic_valid:ͼƬ������Ч�ź�
always@(posedge vga_clk or negedge sys_rst_n)begin
    if(sys_rst_n == 1'b0)
        pic_valid <= 1'b1;
    else
        pic_valid <= rd_en;
end

assign o_pic_valid = pic_valid;
assign o_pic_data = pic_data;

//pix_data_out:���VGA��ʾͼ������
assign pix_data_out = (pic_valid == 1'b1) ? pic_data : pix_data;

//���ݵ�ǰ���ص�����ָ����ǰ���ص���ɫ���ݣ�����Ļ����ʾ����
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
  .clka(sys_clk),    // input wire clka            ����RAMдʱ��,50MHz,1bi
  .wea(pi_flag),      // input wire [0 : 0] wea    ����RAMдʹ��,1bit     
  .addra(wr_addr),  // input wire [3 : 0] addra    ����RAMд��ַ,15bit    
  .dina(pi_data),    // input wire [7 : 0] dina    ����д��RAM��ͼƬ����,8bit 
  .clkb(vga_clk),    // input wire clkb            ����RAM��ʱ��,25MHz,1bi
  .addrb(rd_addr),  // input wire [3 : 0] addrb    ����RAM����ַ,15bit    
  .doutb(pic_data)  // output wire [7 : 0] doutb   �����ȡRAM��ͼƬ����,8bit 
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
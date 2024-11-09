module vga_ctrl(
    input  wire         vga_clk     , //���빤��ʱ��,Ƶ��25MHz
    input  wire         sys_rst_n   , //���븴λ�ź�,�͵�ƽ��Ч
    input  wire [7:0]  pix_data    , //�������ص�ɫ����Ϣ
    output wire [9:0]   pix_x       , //�����Ч��ʾ�������ص�X������
    output wire [9:0]   pix_y       , //�����Ч��ʾ�������ص�Y������
    output wire         hsync       , //�����ͬ���ź�
    output wire         vsync       , //�����ͬ���ź�
    output wire         rgb_valid   , //VGA��Ч��ʾ����
    output wire [23:0]  rgb           //������ص�ɫ����Ϣ

 );


 //parameter define
 parameter H_SYNC  = 10'd96     , //��ͬ��
           H_BACK  = 10'd40     , //��ʱ�����
           H_LEFT  = 10'd8      , //��ʱ����߿�
           H_VALID = 10'd640    , //����Ч����
           H_RIGHT = 10'd8      , //��ʱ���ұ߿�
           H_FRONT = 10'd8      , //��ʱ��ǰ��
           H_TOTAL = 10'd800    ; //��ɨ������

 parameter V_SYNC   = 10'd2     , //��ͬ��
           V_BACK   = 10'd25    , //��ʱ�����
           V_TOP    = 10'd8     , //��ʱ���ϱ߿�
           V_VALID  = 10'd480   , //����Ч����
           V_BOTTOM = 10'd8     , //��ʱ���±߿�
           V_FRONT  = 10'd2     , //��ʱ��ǰ��
           V_TOTAL  = 10'd525   ; //��ɨ������


 wire pix_data_req ; //���ص�ɫ����Ϣ�����ź�

 reg [9:0] cnt_h ; //��ͬ���źż�����
 reg [9:0] cnt_v ; //��ͬ���źż�����

 //cnt_h:��ͬ���źż�����
 always@(posedge vga_clk or negedge sys_rst_n)begin
    if(sys_rst_n == 1'b0)
        cnt_h <= 10'd0 ;
    else if(cnt_h == H_TOTAL - 1'd1)
        cnt_h <= 10'd0 ;
    else
        cnt_h <= cnt_h + 1'd1 ;
 end

 //hsync:��ͬ���ź�
 assign hsync = (cnt_h <= H_SYNC - 1'd1) ? 1'b1 : 1'b0 ;

 //cnt_v:��ͬ���źż�����
 always@(posedge vga_clk or negedge sys_rst_n)begin
    if(sys_rst_n == 1'b0)
        cnt_v <= 10'd0 ;
    else if((cnt_v == V_TOTAL - 1'd1) && (cnt_h == H_TOTAL-1'd1))
        cnt_v <= 10'd0 ;
    else if(cnt_h == H_TOTAL - 1'd1)
        cnt_v <= cnt_v + 1'd1 ;
    else
        cnt_v <= cnt_v ;
 end

 //vsync:��ͬ���ź�
 assign vsync = (cnt_v <= V_SYNC - 1'd1) ? 1'b1 : 1'b0 ;

 //rgb_valid:VGA��Ч��ʾ����
 assign rgb_valid = (((cnt_h >= H_SYNC + H_BACK + H_LEFT) && (cnt_h < H_SYNC + H_BACK + H_LEFT + H_VALID))
                   &&((cnt_v >= V_SYNC + V_BACK + V_TOP) && (cnt_v < V_SYNC + V_BACK + V_TOP + V_VALID))) ? 1'b1 : 1'b0;

 //pix_data_req:���ص�ɫ����Ϣ�����ź�,��ǰrgb_valid�ź�һ��ʱ������
 assign pix_data_req = (((cnt_h >= H_SYNC + H_BACK + H_LEFT - 1'b1) && (cnt_h<H_SYNC + H_BACK + H_LEFT + H_VALID - 1'b1))
                      &&((cnt_v >= V_SYNC + V_BACK + V_TOP) && (cnt_v < V_SYNC + V_BACK + V_TOP + V_VALID))) ? 1'b1 : 1'b0;

 //pix_x,pix_y:VGA��Ч��ʾ�������ص�����
 assign pix_x = (pix_data_req == 1'b1) ? (cnt_h - (H_SYNC + H_BACK + H_LEFT - 1'b1)) : 10'h3ff;
 assign pix_y = (pix_data_req == 1'b1) ? (cnt_v - (V_SYNC + V_BACK + V_TOP)) : 10'h3ff;

 //rgb:������ص�ɫ����Ϣ
 assign rgb = (rgb_valid == 1'b1) ? {pix_data[7:5],5'b0,pix_data[4:2],5'b0,pix_data[1:0],6'b0} : 23'b0 ;

 endmodule
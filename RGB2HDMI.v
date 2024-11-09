`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/09 11:14:22
// Design Name: 
// Module Name: RGB2HDMI
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RGB2HDMI(
input               pclk        ,//ʱ��
input               pclk5       ,//ʱ��
input               rst_n       ,//��λ
input      [23:0]   RGBDATA     ,//��Ƶ����
input               Hsync       ,//��Ƶ����
input               Vsync       ,//��Ƶ����
input               DE          ,//��Ƶ����
output              TMDS_clk_p  ,//HDMI�ӿ�
output              TMDS_clk_n  ,//HDMI�ӿ�
output  [2:0]       TMDS_data_p ,//HDMI�ӿ�
output  [2:0]       TMDS_data_n  //HDMI�ӿ�
    );
//------------�첽��λ��ͬ���ͷ�------------//
reg rst_n_reg;
always@(posedge pclk)begin
    if(!rst_n)
        rst_n_reg <= 0;
    else
        rst_n_reg <= 1;
end
//-------------------RGB����-----------------//
//RGB����
wire [9:0]        data_o_R,data_o_G,data_o_B;
Encoder  EncoderDATAR(
.pclk            (pclk),//����ʱ��
.rst_n           (rst_n_reg),//��λ�ź�
.data_i          (RGBDATA[23:16]),//��������
.ctrl            (2'd0),//���ݿ���ģ�� ��Blue ������ ctrl[0] == Hsync ctrl[1] == Vsync ��
.DE              (DE),//������Ч
.data_o          (data_o_R)//8bit��10bit��ת�����
    );
Encoder  EncoderDATAG(
.pclk            (pclk),//����ʱ��
.rst_n           (rst_n_reg),//��λ�ź�
.data_i          (RGBDATA[15:8]),//��������
.ctrl            (2'd0),//���ݿ���ģ�� ��Blue ������ ctrl[0] == Hsync ctrl[1] == Vsync ��
.DE              (DE),//������Ч
.data_o          (data_o_G)//8bit��10bit��ת�����
    );
Encoder  EncoderDATAB(
.pclk            (pclk),//����ʱ��
.rst_n           (rst_n_reg),//��λ�ź�
.data_i          (RGBDATA[7:0]),//��������
.ctrl            ({Vsync,Hsync}),//���ݿ���ģ�� ��Blue ������ ctrl[0] == Hsync ctrl[1] == Vsync ��
.DE              (DE),//������Ч
.data_o          (data_o_B)//8bit��10bit��ת�����
    );
//-------------------��ת��----------------------------//
wire [2:0] data_o;//RGB��������
wire data_time;
serila10bit1bit serila10bit1bit_R(
.pclk         (pclk),//ʱ��
.pclk5        (pclk5),//5��ʱ��
.rst_n        (rst_n_reg),//��λ
.data_i       (data_o_R),//10bit����
.data_o       (data_o[2])//�������
    );
serila10bit1bit serila10bit1bit_G(
.pclk         (pclk),//ʱ��
.pclk5        (pclk5),//5��ʱ��
.rst_n        (rst_n_reg),//��λ
.data_i       (data_o_G),//10bit����
.data_o       (data_o[1])//�������
    );
serila10bit1bit serila10bit1bit_B(
.pclk         (pclk),//ʱ��
.pclk5        (pclk5),//5��ʱ��
.rst_n        (rst_n_reg),//��λ
.data_i       (data_o_B),//10bit����
.data_o       (data_o[0])//�������
    );
serila10bit1bit TIME(
.pclk         (pclk),//ʱ��
.pclk5        (pclk5),//5��ʱ��
.rst_n        (rst_n_reg),//��λ
.data_i       (10'b1111100000),//10bit����
.data_o       (data_time)//�������
    );
//--------------------------ת��Ϊ����źŴ���-----------------------//
   OBUFDS #(
      .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
      .SLEW("SLOW")           // Specify the output slew rate
   ) OBUFDS_TIME (
      .O(TMDS_clk_p),     // Diff_p output (connect directly to top-level port)
      .OB(TMDS_clk_n),   // Diff_n output (connect directly to top-level port)
      .I(data_time)      // Buffer input
   );
      OBUFDS #(
      .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
      .SLEW("SLOW")           // Specify the output slew rate
   ) OBUFDS_DATAR (
      .O(TMDS_data_p[2]),     // Diff_p output (connect directly to top-level port)
      .OB(TMDS_data_n[2]),   // Diff_n output (connect directly to top-level port)
      .I(data_o[2])      // Buffer input
   );
         OBUFDS #(
      .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
      .SLEW("SLOW")           // Specify the output slew rate
   ) OBUFDS_DATAG (
      .O(TMDS_data_p[1]),     // Diff_p output (connect directly to top-level port)
      .OB(TMDS_data_n[1]),   // Diff_n output (connect directly to top-level port)
      .I(data_o[1])      // Buffer input
   );
         OBUFDS #(
      .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
      .SLEW("SLOW")           // Specify the output slew rate
   ) OBUFDS_DATAB (
      .O(TMDS_data_p[0]),     // Diff_p output (connect directly to top-level port)
      .OB(TMDS_data_n[0]),   // Diff_n output (connect directly to top-level port)
      .I(data_o[0])      // Buffer input
   );
endmodule

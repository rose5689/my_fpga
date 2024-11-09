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
input               pclk        ,//时钟
input               pclk5       ,//时钟
input               rst_n       ,//复位
input      [23:0]   RGBDATA     ,//视频数据
input               Hsync       ,//视频数据
input               Vsync       ,//视频数据
input               DE          ,//视频数据
output              TMDS_clk_p  ,//HDMI接口
output              TMDS_clk_n  ,//HDMI接口
output  [2:0]       TMDS_data_p ,//HDMI接口
output  [2:0]       TMDS_data_n  //HDMI接口
    );
//------------异步复位，同步释放------------//
reg rst_n_reg;
always@(posedge pclk)begin
    if(!rst_n)
        rst_n_reg <= 0;
    else
        rst_n_reg <= 1;
end
//-------------------RGB编码-----------------//
//RGB编码
wire [9:0]        data_o_R,data_o_G,data_o_B;
Encoder  EncoderDATAR(
.pclk            (pclk),//像素时钟
.rst_n           (rst_n_reg),//复位信号
.data_i          (RGBDATA[23:16]),//像素数据
.ctrl            (2'd0),//数据控制模块 （Blue 分量下 ctrl[0] == Hsync ctrl[1] == Vsync ）
.DE              (DE),//数据有效
.data_o          (data_o_R)//8bit到10bit的转化结果
    );
Encoder  EncoderDATAG(
.pclk            (pclk),//像素时钟
.rst_n           (rst_n_reg),//复位信号
.data_i          (RGBDATA[15:8]),//像素数据
.ctrl            (2'd0),//数据控制模块 （Blue 分量下 ctrl[0] == Hsync ctrl[1] == Vsync ）
.DE              (DE),//数据有效
.data_o          (data_o_G)//8bit到10bit的转化结果
    );
Encoder  EncoderDATAB(
.pclk            (pclk),//像素时钟
.rst_n           (rst_n_reg),//复位信号
.data_i          (RGBDATA[7:0]),//像素数据
.ctrl            ({Vsync,Hsync}),//数据控制模块 （Blue 分量下 ctrl[0] == Hsync ctrl[1] == Vsync ）
.DE              (DE),//数据有效
.data_o          (data_o_B)//8bit到10bit的转化结果
    );
//-------------------并转串----------------------------//
wire [2:0] data_o;//RGB串行数据
wire data_time;
serila10bit1bit serila10bit1bit_R(
.pclk         (pclk),//时钟
.pclk5        (pclk5),//5倍时钟
.rst_n        (rst_n_reg),//复位
.data_i       (data_o_R),//10bit数据
.data_o       (data_o[2])//数据输出
    );
serila10bit1bit serila10bit1bit_G(
.pclk         (pclk),//时钟
.pclk5        (pclk5),//5倍时钟
.rst_n        (rst_n_reg),//复位
.data_i       (data_o_G),//10bit数据
.data_o       (data_o[1])//数据输出
    );
serila10bit1bit serila10bit1bit_B(
.pclk         (pclk),//时钟
.pclk5        (pclk5),//5倍时钟
.rst_n        (rst_n_reg),//复位
.data_i       (data_o_B),//10bit数据
.data_o       (data_o[0])//数据输出
    );
serila10bit1bit TIME(
.pclk         (pclk),//时钟
.pclk5        (pclk5),//5倍时钟
.rst_n        (rst_n_reg),//复位
.data_i       (10'b1111100000),//10bit数据
.data_o       (data_time)//数据输出
    );
//--------------------------转化为差分信号传输-----------------------//
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

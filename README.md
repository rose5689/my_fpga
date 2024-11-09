# 基于fpga的vga图像显示

环境：vivdo 2018.3   主控：xc7z020clg400-2

功能 通过上位机 将16进制的图片数据通过串口调试工具发送到FPGA ，FPGA将数据处理后发送到显示器


vga_uart_pic.m   该文件为matlab函数文件，其功能是将.bmp文件转化成16进制的数据文件，文件格式为txt
所有.v文件为各个功能模块的代码，将其添加到vivado工程当中还需要调用pll ip核生成  25M 50M 125M 的时钟
还要调用一个简单双端口ram  例子化到vga_pic.v文件中 

将硬件电路搭建完成后，将matalab生成的数据文件通过串口传输助手发送到fpga即可看到显示器上的成像

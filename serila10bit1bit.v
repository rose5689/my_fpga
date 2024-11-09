`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/09 10:56:23
// Design Name: 
// Module Name: serila10bit1bit
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


module serila10bit1bit(
input pclk          ,//时钟
input pclk5         ,//5倍时钟
input rst_n         ,//复位
input [9:0] data_i  ,//10bit数据
output data_o        //数据输出
    );
//---------------------//
wire shift0,shift1;
OSERDESE2 #(
      .DATA_RATE_OQ("DDR"),   // DDR, SDR
      .DATA_RATE_TQ("SDR"),   // DDR, BUF, SDR
      .DATA_WIDTH(10),         // Parallel data width (2-8,10,14)
      .INIT_OQ(1'b0),         // Initial value of OQ output (1'b0,1'b1)
      .INIT_TQ(1'b0),         // Initial value of TQ output (1'b0,1'b1)
      .SERDES_MODE("MASTER"), // MASTER, SLAVE
      .SRVAL_OQ(1'b0),        // OQ output value when SR is used (1'b0,1'b1)
      .SRVAL_TQ(1'b0),        // TQ output value when SR is used (1'b0,1'b1)
      .TBYTE_CTL("FALSE"),    // Enable tristate byte operation (FALSE, TRUE)
      .TBYTE_SRC("FALSE"),    // Tristate byte source (FALSE, TRUE)
      .TRISTATE_WIDTH(1)      // 3-state converter width (1,4)
   )
   master_1 (
      .OQ(data_o),              //单bit输出
      .TQ(TQ),               // 1-bit output: 3-state control
      .CLK(pclk5),             // 1-bit input: High speed clock
      .CLKDIV(pclk),       // 1-bit input: Divided clock
      // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
      .D1(data_i[0]), //10bit数据
      .D2(data_i[1]), //10bit数据
      .D3(data_i[2]), //10bit数据
      .D4(data_i[3]), //10bit数据
      .D5(data_i[4]), //10bit数据
      .D6(data_i[5]), //10bit数据
      .D7(data_i[6]), //10bit数据
      .D8(data_i[7]), //10bit数据
      .OCE(1'b1),             // 1-bit input: Output data clock enable
      .RST(~rst_n),             // 1-bit input: Reset
      .SHIFTIN1(shift0),
      .SHIFTIN2(shift1),
      // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
      .T1(1'b0),
      .T2(1'b0),
      .T3(1'b0),
      .T4(1'b0),
      .TBYTEIN(1'b0),     // 1-bit input: Byte group tristate
      .TCE(1'b0)              // 1-bit input: 3-state clock enable
   );
   OSERDESE2 #(
      .DATA_RATE_OQ("DDR"),   // DDR, SDR
      .DATA_RATE_TQ("SDR"),   // DDR, BUF, SDR
      .DATA_WIDTH(10),         // Parallel data width (2-8,10,14)
      .INIT_OQ(1'b0),         // Initial value of OQ output (1'b0,1'b1)
      .INIT_TQ(1'b0),         // Initial value of TQ output (1'b0,1'b1)
      .SERDES_MODE("SLAVE"), // MASTER, SLAVE
      .SRVAL_OQ(1'b0),        // OQ output value when SR is used (1'b0,1'b1)
      .SRVAL_TQ(1'b0),        // TQ output value when SR is used (1'b0,1'b1)
      .TBYTE_CTL("FALSE"),    // Enable tristate byte operation (FALSE, TRUE)
      .TBYTE_SRC("FALSE"),    // Tristate byte source (FALSE, TRUE)
      .TRISTATE_WIDTH(1)      // 3-state converter width (1,4)
   )
   slave_1 (
      // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
      .SHIFTOUT1(shift0),
      .SHIFTOUT2(shift1),
      .CLK(pclk5),             // 1-bit input: High speed clock
      .CLKDIV(pclk),       // 1-bit input: Divided clock
      // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
      .D1(1'b0), 
      .D2(1'b0), 
      .D3(data_i[8]), //10bit数据
      .D4(data_i[9]), //10bit数据
      .D5(1'b0), 
      .D6(1'b0), 
      .D7(1'b0), 
      .D8(1'b0), 
      .OCE(1'b1),             // 1-bit input: Output data clock enable
      .RST(~rst_n),             // 1-bit input: Reset
      // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
      .T1(1'b0),
      .T2(1'b0),
      .T3(1'b0),
      .T4(1'b0),
      .TBYTEIN(1'b0),     // 1-bit input: Byte group tristate
      .TCE(1'b0)              // 1-bit input: 3-state clock enable
   );
endmodule

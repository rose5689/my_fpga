//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Sat Nov  9 19:22:24 2024
//Host        : TB-14R76800H running 64-bit major release  (build 9200)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=8,numReposBlks=8,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=4,numPkgbdBlks=0,bdsource=USER,da_clkrst_cnt=4,synth_mode=OOC_per_BD}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (RX_0,
    TMDS_clk_n_0,
    TMDS_clk_p_0,
    TMDS_data_n_0,
    TMDS_data_p_0,
    clk_in1_0,
    hdmi_en,
    resetn_0);
  input RX_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.TMDS_CLK_N_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.TMDS_CLK_N_0, CLK_DOMAIN design_1_RGB2HDMI_0_0_TMDS_clk_n, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) output TMDS_clk_n_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.TMDS_CLK_P_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.TMDS_CLK_P_0, CLK_DOMAIN design_1_RGB2HDMI_0_0_TMDS_clk_p, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) output TMDS_clk_p_0;
  output [2:0]TMDS_data_n_0;
  output [2:0]TMDS_data_p_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_IN1_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_IN1_0, CLK_DOMAIN design_1_clk_in1_0, FREQ_HZ 50000000, INSERT_VIP 0, PHASE 0.000" *) input clk_in1_0;
  output [0:0]hdmi_en;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESETN_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESETN_0, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input resetn_0;

  wire RGB2HDMI_0_TMDS_clk_n;
  wire RGB2HDMI_0_TMDS_clk_p;
  wire [2:0]RGB2HDMI_0_TMDS_data_n;
  wire [2:0]RGB2HDMI_0_TMDS_data_p;
  wire RX_0_1;
  wire [7:0]UART_RX_0_DATA;
  wire UART_RX_0_valid;
  wire clk_in1_0_1;
  wire clk_wiz_0_clk_125;
  wire clk_wiz_0_clk_25;
  wire clk_wiz_0_clk_50;
  wire clk_wiz_0_locked;
  wire resetn_0_1;
  wire [0:0]util_vector_logic_0_Res;
  wire vga_ctrl_0_hsync;
  wire [9:0]vga_ctrl_0_pix_x;
  wire [9:0]vga_ctrl_0_pix_y;
  wire [23:0]vga_ctrl_0_rgb;
  wire vga_ctrl_0_rgb_valid;
  wire vga_ctrl_0_vsync;
  wire [7:0]vga_pic_0_o_pic_data;
  wire vga_pic_0_o_pic_valid;
  wire [7:0]vga_pic_0_pix_data_out;
  wire [0:0]xlconstant_0_dout;

  assign RX_0_1 = RX_0;
  assign TMDS_clk_n_0 = RGB2HDMI_0_TMDS_clk_n;
  assign TMDS_clk_p_0 = RGB2HDMI_0_TMDS_clk_p;
  assign TMDS_data_n_0[2:0] = RGB2HDMI_0_TMDS_data_n;
  assign TMDS_data_p_0[2:0] = RGB2HDMI_0_TMDS_data_p;
  assign clk_in1_0_1 = clk_in1_0;
  assign hdmi_en[0] = xlconstant_0_dout;
  assign resetn_0_1 = resetn_0;
  design_1_RGB2HDMI_0_0 RGB2HDMI_0
       (.DE(vga_ctrl_0_rgb_valid),
        .Hsync(vga_ctrl_0_hsync),
        .RGBDATA(vga_ctrl_0_rgb),
        .TMDS_clk_n(RGB2HDMI_0_TMDS_clk_n),
        .TMDS_clk_p(RGB2HDMI_0_TMDS_clk_p),
        .TMDS_data_n(RGB2HDMI_0_TMDS_data_n),
        .TMDS_data_p(RGB2HDMI_0_TMDS_data_p),
        .Vsync(vga_ctrl_0_vsync),
        .pclk(clk_wiz_0_clk_25),
        .pclk5(clk_wiz_0_clk_125),
        .rst_n(util_vector_logic_0_Res));
  design_1_UART_RX_0_0 UART_RX_0
       (.DATA(UART_RX_0_DATA),
        .RX(RX_0_1),
        .clk(clk_wiz_0_clk_50),
        .rst_n(util_vector_logic_0_Res),
        .valid(UART_RX_0_valid));
  design_1_clk_wiz_0_0 clk_wiz_0
       (.clk_125(clk_wiz_0_clk_125),
        .clk_25(clk_wiz_0_clk_25),
        .clk_50(clk_wiz_0_clk_50),
        .clk_in1(clk_in1_0_1),
        .locked(clk_wiz_0_locked),
        .resetn(resetn_0_1));
  design_1_ila_0_0 ila_0
       (.clk(clk_wiz_0_clk_25),
        .probe0(vga_pic_0_o_pic_data),
        .probe1(vga_pic_0_o_pic_valid));
  design_1_util_vector_logic_0_0 util_vector_logic_0
       (.Op1(resetn_0_1),
        .Op2(clk_wiz_0_locked),
        .Res(util_vector_logic_0_Res));
  design_1_vga_ctrl_0_0 vga_ctrl_0
       (.hsync(vga_ctrl_0_hsync),
        .pix_data(vga_pic_0_pix_data_out),
        .pix_x(vga_ctrl_0_pix_x),
        .pix_y(vga_ctrl_0_pix_y),
        .rgb(vga_ctrl_0_rgb),
        .rgb_valid(vga_ctrl_0_rgb_valid),
        .sys_rst_n(util_vector_logic_0_Res),
        .vga_clk(clk_wiz_0_clk_25),
        .vsync(vga_ctrl_0_vsync));
  design_1_vga_pic_0_1 vga_pic_0
       (.o_pic_data(vga_pic_0_o_pic_data),
        .o_pic_valid(vga_pic_0_o_pic_valid),
        .pi_data(UART_RX_0_DATA),
        .pi_flag(UART_RX_0_valid),
        .pix_data_out(vga_pic_0_pix_data_out),
        .pix_x(vga_ctrl_0_pix_x),
        .pix_y(vga_ctrl_0_pix_y),
        .sys_clk(clk_wiz_0_clk_50),
        .sys_rst_n(util_vector_logic_0_Res),
        .vga_clk(clk_wiz_0_clk_25));
  design_1_xlconstant_0_0 xlconstant_0
       (.dout(xlconstant_0_dout));
endmodule

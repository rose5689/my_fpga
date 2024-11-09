`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SNX ?1¤7?1¤7?1¤7?1¤7
// Engineer: ?1¤7?1¤7?1¤7?1¤7?1¤7?1¤7
// 
// Create Date: 2023/02/09 09:26:39
// Design Name: HDMI            ?1¤7?1¤7?0?5 8bit-->10bit?1¤7?1¤7?1¤7?1¤7
// Module Name: Encoder
// Project Name: Encoder
// Target Devices: 
// Tool Versions: Vivado 2020.1
// Description: 
// HDMI?1¤7?1¤7?1¤7?1¤7?1¤7?1¤7?1¤7?1¤7?1¤7?1¤9?1¤7?1¤7?1¤7?0?0?1¤7?1¤7
// Dependencies: 
// 
// Revision:V1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module Encoder(
input               pclk            ,//?1¤7?1¤7?1¤7?1¤7?0?2?1¤7?1¤7
input               rst_n           ,//?1¤7?1¤7?Ë?1¤7?0?2?1¤7
input [7:0]         data_i          ,//?1¤7?1¤7?1¤7?1¤7?1¤7?1¤7?1¤7?1¤7
input [1:0]         ctrl            ,//?1¤7?1¤7?1¤7?1?3?1¤7?1¤7?1¤7?0?0?1¤7?1¤7 ?1¤7?1¤7Blue ?1¤7?1¤7?1¤7?1¤7?1¤7?1¤7 ctrl[0] == Hsync ctrl[1] == Vsync ?1¤7?1¤7
input               DE              ,//?1¤7?1¤7?1¤7?1¤7?1¤7?1¤7§š

output reg [9:0]        data_o           //8bit?1¤7?1¤710bit?1¤7?1¤7?0?8?1¤7?1¤7?1¤7?1¤7?1¤7
    );
//----------------------------------------//
reg [3:0] cnt_1_D,cnt_0_D;//data_i?1¤7?1¤7?1¤7?1¤71/0?1¤7?0?0?1¤7?1¤7?1¤7?1¤7?0?4?1¤7?1¤7?1¤7?1¤7?1¤7
reg [7:0] data_0;
always@(posedge pclk or negedge rst_n)begin
    if(!rst_n)begin
        cnt_1_D <= 0;
        cnt_0_D <= 0;
        data_0  <= 0;
    end
    else begin
        cnt_1_D <= data_i[0] + data_i[1] + data_i[2] + data_i[3]+data_i[4] + data_i[5] + data_i[6] + data_i[7];
        cnt_0_D <= 8-(data_i[0] + data_i[1] + data_i[2] + data_i[3]+data_i[4] + data_i[5] + data_i[6] + data_i[7]);
        data_0  <= data_i;
    end    
end
wire flag1;
assign flag1 = cnt_1_D>4||(cnt_1_D==4&&data_0[0]==0);
wire [8:0] q_m;
//
//reg [7:0] data[11:0];
assign q_m[0] = data_0[0]; 
assign q_m[1] = flag1? (q_m[0]~^data_0[1]): (q_m[0]^data_0[1]);
assign q_m[2] = flag1? (q_m[1]~^data_0[2]): (q_m[1]^data_0[2]);
assign q_m[3] = flag1? (q_m[2]~^data_0[3]): (q_m[2]^data_0[3]);
assign q_m[4] = flag1? (q_m[3]~^data_0[4]): (q_m[3]^data_0[4]);
assign q_m[5] = flag1? (q_m[4]~^data_0[5]): (q_m[4]^data_0[5]);
assign q_m[6] = flag1? (q_m[5]~^data_0[6]): (q_m[5]^data_0[6]);
assign q_m[7] = flag1? (q_m[6]~^data_0[7]): (q_m[6]^data_0[7]);
assign q_m[8] = flag1? 1'b0 : 1'b1;
//---------------------------------------------------//
reg [3:0] cnt_1_qm,cnt_0_qm;//data_i?1¤7?1¤7?1¤7?1¤71/0?1¤7?0?0?1¤7?1¤7?1¤7?1¤7?0?4?1¤7?1¤7?1¤7?1¤7?1¤7
reg [8:0] data_qm;
reg DE_temp           ;
reg [1:0] C1_temp;
reg [1:0] C0_temp;
always@(posedge pclk or negedge rst_n)begin
    if(!rst_n)begin
        cnt_1_qm <= 0;
        cnt_0_qm <= 0;
        data_qm  <= 0;
        DE_temp  <= 0;
        C1_temp  <= 0;
        C0_temp  <= 0;
    end
    else begin
        cnt_1_qm <= q_m[0]+q_m[1]+q_m[2]+q_m[3]+q_m[4]+q_m[5]+q_m[6]+q_m[7];
        cnt_0_qm <= 8-(q_m[0]+q_m[1]+q_m[2]+q_m[3]+q_m[4]+q_m[5]+q_m[6]+q_m[7]);
        data_qm  <= q_m;
        DE_temp  <= DE;
        C1_temp  <= {C1_temp[0],ctrl[1]};
        C0_temp  <= {C0_temp[0],ctrl[0]};
    end
end
reg [7:0] cnt;
wire flag2;
assign flag2 = (cnt==0)||(cnt_1_qm==cnt_0_qm);
wire flag3;
assign flag3 = (cnt[7]==0&&cnt_1_qm>cnt_0_qm)||(cnt[7]==1&&cnt_0_qm>cnt_1_qm);
always@(posedge pclk or negedge rst_n)begin
    if(!rst_n)begin
        data_o <= 0;
        cnt    <= 0;
    end
    else if(DE_temp)begin
        if(flag2)begin
            data_o[9]<=~data_qm[8];
            data_o[8]<= data_qm[8];
            data_o[7:0] <= data_qm[8]?data_qm[7:0]:~data_qm[7:0];
            cnt <= data_qm[8]? cnt + cnt_1_qm - cnt_0_qm:cnt + cnt_0_qm - cnt_1_qm;
        end
        else begin
            if(flag3)begin
                data_o[9]<=1'b1;
                data_o[8]<= data_qm[8];
                data_o[7:0]<= ~data_qm[7:0];
                cnt <= cnt + {data_qm[8],1'b0} +cnt_0_qm - cnt_1_qm;
            end
            else begin
                data_o[9]<=1'b1;
                data_o[8]<= data_qm[8];
                data_o[7:0]<= data_qm[7:0];
                cnt <= cnt - {~data_qm[8],1'b0} +cnt_1_qm - cnt_0_qm;
            end
        end
    end
    else begin
        cnt <= 0;
        case({C1_temp[1],C0_temp[1]})
            2'd0:data_o <= 10'b1101010100;
            2'd1:data_o <= 10'b0010101011;
            2'd2:data_o <= 10'b0101010100;
            2'd3:data_o <= 10'b1010101011;
        endcase
    end
end
endmodule

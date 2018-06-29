`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:20:06 05/15/2018 
// Design Name: 
// Module Name:    Top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Top(
	input [3:0] BTN_y,
   input clk_100mhz,
   input RSTN,
   input [15:0] SW,
	input PS2_clk,
	input PS2_data,
   output [3:0] AN,
   output [4:0] BTN_x,
   output Buzzer,
   output CR,
   output [7:0] LED,
   output led_clk,
   output led_clrn,
   output LED_PEN,
   output led_sout,
   output RDY,
   output readn,
   output [7:0] SEGMENT,
   output seg_clk,
   output seg_clrn,
   output SEG_PEN,
   output seg_sout,
	output [3:0] Blue, Red, Green,
	output HSYNC, VSYNC
	);
   
   wire [31:0] Addr_out;
   wire [31:0] Ai;
   wire [31:0] Bi;
   wire [7:0] blink;
   wire [3:0] BTN_OK;
   wire Clk_CPU;
   wire [31:0] Counter_out;
   wire [31:0] CPU2IO;
   wire [31:0] Data_in;
   wire [31:0] Data_out;
   wire [31:0] Disp_num;
   wire [31:0] Div;
   wire GPIOF0;
   wire [31:0] inst;
   wire IO_clk;
   wire [7:0] LE_out;
   wire [31:0] PC;
   wire [7:0] point_out;
   wire [3:0] Pulse;
   wire rst;
   wire [15:0] SW_OK;
   wire [4:0] XLXN_13;
   wire XLXN_70;
   wire XLXN_124;
   wire [31:0] XLXN_126;
   wire [31:0] XLXN_127;
   wire [31:0] XLXN_128;
   wire [0:0] XLXN_129;
   wire [11:0] ram;
   wire [31:0] XLXN_131;
   wire XLXN_139;
   wire [1:0] XLXN_157;
   wire XLXN_175;
   wire [15:0] XLXN_176;
   wire XLXN_178;
   wire XLXN_179;
   wire XLXN_181;
   wire [31:0] XLXN_202;
   wire XLXN_204;
   wire RDY_DUMMY;
   wire readn_DUMMY;
	wire [4:0] State;
	
	wire vram_we;
	wire [11:0] vga_data, vram_data_out, vram_data_in;
	wire [8:0] row_addr;
	wire [9:0] col_addr;
	wire [18:0] vram_r_addr, vram_w_addr;
	wire [9:0] PS2_key;
   
   assign RDY = RDY_DUMMY;
   assign readn = readn_DUMMY;
	assign XLXN_70 = ~Clk_CPU;
	assign IO_clk = ~Clk_CPU;
	
	VGA  vga(.clk(Div[1]),.rst(rst),.Din(vga_data),.row(row_addr),
				.col(col_addr),.rdn(),.R(Red),.G(Green),.B(Blue),.HS(HSYNC),.VS(VSYNC));
	
	GPU  gpu(.clk(Div[1]), .row(row_addr), .col(col_addr), .vram_addr(vram_r_addr), 
				.vram_data(vram_data_out), .vga_data(vga_data));
	
	VRAM VRAM(.clka(clk_100mhz), .wea(vram_we), .addra(vram_w_addr), .dina(vram_data_in), .clkb(Div[1]), 
						.addrb(vram_r_addr), .doutb(vram_data_out));
	
	PS2 ps2		(.clk(clk_100mhz), .rst(rst), .ps2_clk(PS2_clk), .ps2_data(PS2_data), 
						.data_out(PS2_key), .ready());
	
   SEnter_2_32  M4 (.BTN(BTN_OK[2:0]), 
                   .clk(clk_100mhz), 
                   .Ctrl({SW_OK[7:5], SW_OK[15], SW_OK[0]}), 
                   .Din(XLXN_13[4:0]), 
                   .D_ready(RDY_DUMMY), 
                   .Ai(Ai[31:0]), 
                   .Bi(Bi[31:0]), 
                   .blink(blink[7:0]), 
                   .readn(readn_DUMMY));
   Muliti_CPU  U1 (.clk(Clk_CPU), 
                  .Data_in(XLXN_126[31:0]), 
                  .inst_out(inst[31:0]), 
                  .INT(XLXN_181), 
                  .MIO_ready(1'b1), 
                  .reset(rst), 
                  .Addr_out(Addr_out[31:0]), 
                  .CPU_MIO(), 
                  .Data_out(XLXN_127[31:0]), 
                  .mem_w(XLXN_124), 
                  .PC_out(PC[31:0]),
						.state(State[4:0]));
   RAM_B  U3 (.addra(ram[11:0]), 
             .clka(XLXN_70), 
             .dina(XLXN_128[31:0]), 
             .wea(XLXN_129[0]), 
             .douta(XLXN_131[31:0]));
   MIO_BUS  U4 (.addr_bus(Addr_out[31:0]), 
               .BTN(BTN_OK[3:0]), 
               .clk(clk_100mhz), 
               .counter_out(Counter_out[31:0]), 
               .counter0_out(XLXN_181), 
               .counter1_out(XLXN_179), 
               .counter2_out(XLXN_178), 
               .Cpu_data2bus(XLXN_127[31:0]),
               .led_out(XLXN_176[15:0]), 
               .mem_w(XLXN_124), 
               .ram_data_out(XLXN_131[31:0]), 
               .rst(rst), 
               .SW(SW_OK[15:0]), 
               .counter_we(XLXN_139), 
               .Cpu_data4bus(XLXN_126[31:0]), 
               .data_ram_we(XLXN_129[0]), 
               .GPIOe0000000_we(XLXN_204), 
               .GPIOf0000000_we(XLXN_175), 
               .Peripheral_in(XLXN_202[31:0]), 
               .ram_addr(ram[11:0]), 
               .ram_data_in(XLXN_128[31:0]),
					.vram_we(vram_we), .vram_data(vram_data_in), .vram_addr(vram_w_addr),
					.ps2kb_key(PS2_key)
					);
   Multi_8CH32  U5 (.clk(IO_clk), 
                   .Data0(XLXN_202[31:0]), 
                   .data1({2'b0, PC[31:2]}), 
                   .data2(inst[31:0]), 
                   .data3(Counter_out[31:0]), 
                   .data4(Addr_out[31:0]), 
                   .data5(Data_out[31:0]), 
                   .data6(Data_in[31:0]), 
                   .data7(PC[31:0]), 
                   .EN(XLXN_204), 
                   .LES(64'b0), 
                   .point_in({Div[31:0], Div[31:0]}), 
                   .rst(rst), 
                   .Test(SW_OK[7:5]), 
                   .Disp_num(Disp_num[31:0]), 
                   .LE_out(LE_out[7:0]), 
                   .point_out(point_out[7:0]));
   SSeg7_Dev  U6 (.clk(clk_100mhz), 
                           .flash(Div[25]), 
                           .Hexs(Disp_num[31:0]), 
                           .LES(LE_out[7:0]), 
                           .point(point_out[7:0]), 
                           .rst(rst), 
                           .Start(Div[20]), 
                           .SW0(SW_OK[0]), 
                           .seg_clk(seg_clk), 
                           .seg_clrn(seg_clrn), 
                           .SEG_PEN(SEG_PEN), 
                           .seg_sout(seg_sout));
   SPIO  U7 (.clk(IO_clk), 
            .EN(XLXN_175), 
            .P_Data(XLXN_202[31:0]), 
            .rst(rst), 
            .Start(Div[20]), 
            .counter_set(XLXN_157[1:0]), 
            .GPIOf0(), 
            .led_clk(led_clk), 
            .led_clrn(led_clrn), 
            .LED_out(XLXN_176[15:0]), 
            .LED_PEN(LED_PEN), 
            .led_sout(led_sout));
   clk_div  U8 (.clk(clk_100mhz), 
               .rst(rst), 
               .SW2(SW_OK[2]), 
               .clkdiv(Div[31:0]), 
               .Clk_CPU(Clk_CPU));
   SAnti_jitter  U9 (.clk(clk_100mhz), 
                    .Key_y(BTN_y[3:0]), 
                    .readn(readn_DUMMY), 
                    .RSTN(RSTN), 
                    .SW(SW[15:0]), 
                    .BTN_OK(BTN_OK[3:0]), 
                    .CR(CR), 
                    .Key_out(XLXN_13[4:0]), 
                    .Key_ready(RDY_DUMMY), 
                    .Key_x(BTN_x[4:0]), 
                    .pulse_out(Pulse[3:0]), 
                    .rst(rst), 
                    .SW_OK(SW_OK[15:0]));
   Counter_x  U10 (.clk(IO_clk), 
                  .clk0(Div[6]), 
                  .clk1(Div[9]), 
                  .clk2(Div[11]), 
                  .counter_ch(XLXN_157[1:0]), 
                  .counter_val(XLXN_202[31:0]), 
                  .counter_we(XLXN_139), 
                  .rst(rst), 
                  .counter_out(Counter_out[31:0]), 
                  .counter0_OUT(XLXN_181), 
                  .counter1_OUT(XLXN_179), 
                  .counter2_OUT(XLXN_178));
   Seg7_Dev  U61 (.flash(Div[25]), 
                           .Hexs(Disp_num[31:0]), 
                           .LES(LE_out[7:0]), 
                           .point(point_out[7:0]), 
                           .Scan({SW_OK[1], Div[19:18]}), 
                           .SW0(SW_OK[0]), 
                           .AN(AN[3:0]), 
                           .SEGMENT(SEGMENT[7:0]));
   PIO  U71 (.clk(IO_clk), 
            .EN(GPIOF0), 
            .PData_in(CPU2IO[31:0]), 
            .rst(rst), 
            .counter_set(), 
            .GPIOf0(), 
            .LED_out(LED[7:0]));
   BUF  XLXI_14 (.I(1'b1), 
                .O(Buzzer));
endmodule

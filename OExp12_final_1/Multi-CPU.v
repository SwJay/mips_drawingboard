`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:29:47 05/15/2018 
// Design Name: 
// Module Name:    Multi-CPU 
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
module  Muliti_CPU(input wire clk,
						 input wire reset,
						 input wire MIO_ready,		 //be used：=1
						 input wire INT, 				 //中断
						 input wire [31:0]Data_in,	 //数据输入总线
						 output wire[31:0]PC_out,	 //Test
						 output wire[31:0]inst_out, //TEST
						 output wire[31:0]Addr_out, //数据空间访问地址
						 output wire[31:0]Data_out, //数据输出总线
						 output wire mem_w, 			 //存储器读写控制
						 output wire CPU_MIO, 		 //Be used
						 output wire[4:0]state 		 //Test
);
wire MemRead, MemWrite, lorD, IRWrite, RegWrite, PCWrite, PCWriteCond, Branch;
wire [1:0] RegDst, MemtoReg, ALUSrcA, PCSource;
wire [2:0] ALUSrcB, ALU_operation;
wire zero, overflow;

assign mem_w = MemWrite && (~MemRead);

ctrl U11(.clk(clk),
			.reset(reset),
			.zero(zero),
			.overflow(overflow),
			.MIO_ready(MIO_ready),
			.Inst_in(inst_out),
			.MemRead(MemRead),
			.MemWrite(MemWrite),
			.CPU_MIO(CPU_MIO),
			.IorD(lorD),
			.IRWrite(IRWrite),
			.RegWrite(RegWrite),
			.ALUSrcA(ALUSrcA),
			.PCWrite(PCWrite),
			.PCWriteCond(PCWriteCond),
			.Branch(Branch),
			.RegDst(RegDst),
			.MemtoReg(MemtoReg),
			.ALUSrcB(ALUSrcB),
			.PCSource(PCSource),
			.ALU_operation(ALU_operation),
			.state_out(state)
			);

M_datapath U1_2(.clk(clk),
					 .reset(reset),
					 .zero(zero),
					 .overflow(overflow),
					 .MIO_ready(MIO_ready),
					 .IorD(lorD),
					 .IRWrite(IRWrite),
					 .RegWrite(RegWrite),
					 .ALUSrcA(ALUSrcA),
					 .PCWrite(PCWrite),
					 .PCWriteCond(PCWriteCond),
					 .Branch(Branch),
					 .RegDst(RegDst),
					 .MemtoReg(MemtoReg),
					 .ALUSrcB(ALUSrcB),
					 .PCSource(PCSource),
					 .ALU_operation(ALU_operation),
					 .data2CPU(Data_in),
					 .PC_Current(PC_out),
					 .Inst(inst_out),
					 .data_out(Data_out),
					 .M_addr(Addr_out)
					 );

endmodule

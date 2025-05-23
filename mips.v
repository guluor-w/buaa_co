`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:00:29 11/13/2024 
// Design Name: 
// Module Name:    mips 
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
`include "constants.vh"

module mips(
    input clk,
    input reset,
    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3 :0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
);

initial begin
		//初始化寄存器
		RegD_instr = 32'b0;
		RegD_PC = 32'b0;		
		RD1E = 0;
		RD2E = 0;
		rsE = 0;
		rtE = 0;
		rdE = 0;
		sE = 0;
		PCE = 0;
		RegDstE = 0;
		RegWEE = 0;
		ALU_SE = 0;
		ALU_BE = 0;
		ALU_OPE = 0;
		MemWEE = 0;
		Mem2RegE = 0;
		imm32E = 0;	
      linkE = 0;	
      MUL_OPE = 0;
      startE = 0;		
		ALU_resultM = 0;
		DM_inM = 0;
		GRF_addrM = 0;
		PCM = 0;
		RegWEM = 0;
		MemWEM = 0;
		Mem2RegM = 0;
		linkM = 0;
		RegWEW = 0;
		PCW = 0;
		ALU_resultW = 0;
		dataFromMemW = 0;
		GRF_addrW = 0;
		linkW = 0;
		rtM = 0;
		//
      
end
	 
//-------------D------------//
reg [31:0] RegD_instr;
reg [31:0] RegD_PC;

always @(reset)begin
		RegD_instr = 32'b0;
		RegD_PC = 32'b0;		
end

always @(posedge clk)begin
	if(reset)begin
		RegD_instr <= 32'b0;
		RegD_PC <= 32'b0;		
	end
	else if(stallD)begin  
		RegD_instr <= RegD_instr;
		RegD_PC <= RegD_PC;		
	end
	else begin
		RegD_instr <= instrF;
		RegD_PC <= PCF;
	end
end 
wire [5:0] op;
wire [5:0] func;
wire [4:0] rsD;
wire [4:0] rtD;
wire [4:0] rdD;
wire [4:0] sD; 
wire [31:0] PCD;
wire [15:0] imm16;
wire [25:0] imm26;
  
reg [4:0] GRF_addrW; //在W中assign 
wire [31:0] GRF_dataW; //在W中assign
reg RegWEW;//在W中assign
reg [31:0] PCW;//在W中assign

assign op = RegD_instr[31:26];
assign func = RegD_instr[5:0];
assign rsD = RegD_instr[25:21];
assign rtD = RegD_instr[20:16];
assign rdD = RegD_instr[15:11];
assign sD = RegD_instr[10:6];
assign imm16 = RegD_instr[15:0];
assign imm26 = RegD_instr[25:0];
assign PCD = RegD_PC;

//产生控制信号
wire [3:0] jump_OP;
wire [1:0] RegDstD;
wire RegWED;
wire ALU_SD;
wire ALU_BD;
wire [3:0] ALU_OPD;
wire [1:0] MemWED;
wire [1:0] Mem2RegD;
wire EXT_OPD;
wire[3:0] MUL_OPD;
wire startD;
Controller control(
    .op(op),
    .func(func),
    .jump_OP(jump_OP),
    .RegDst(RegDstD),
    .RegWE(RegWED),
    .ALU_S(ALU_SD),
    .ALU_B(ALU_BD),
    .ALU_OP(ALU_OPD),
    .MemWE(MemWED),
	 .Mem2Reg(Mem2RegD),
    .EXT_OP(EXT_OPD),
	 .MUL_OP(MUL_OPD),
	 .start(startD)
    );


wire [31:0] RD1D;
wire [31:0] RD2D;
GRF grf(
	 .PC(PCW),	
    .clk(clk),
    .WE(RegWEW || linkW),
    .reset(reset),
    .A1(rsD),
    .A2(rtD),
    .A3(GRF_addrW),
    .WD(GRF_dataW),
    .RD1(RD1D),
    .RD2(RD2D)
);
assign w_grf_we = RegWEW || linkW;
assign w_grf_addr = GRF_addrW;
assign w_grf_wdata = GRF_dataW;
assign w_inst_addr = PCW;

wire [31:0] imm32D;
EXT ext(
    .imm(imm16),
    .op(EXT_OPD),
    .imm_ext(imm32D)
    );

//计算NPC
wire [31:0] nPC;
wire [3:0] next_OP;
wire linkD;
wire [31:0] RD1D_true;
wire [31:0] RD2D_true;

assign RD1D_true =  (forwardAD == 3'b001) ? ALU_resultM:
			           (forwardAD == 3'b010) ? GRF_dataW:
						  (forwardAD == 3'b011) ? PCE + 8:
						  (forwardAD == 3'b100) ? PCM + 8:
						  (forwardAD == 3'b101) ? PCW + 8:
			            RD1D;	

assign RD2D_true =  (forwardBD == 3'b001) ? ALU_resultM:
			           (forwardBD == 3'b010) ? GRF_dataW:
						  (forwardBD == 3'b011) ? PCE + 8:
						  (forwardBD == 3'b100) ? PCM + 8:
						  (forwardBD == 3'b101) ? PCW + 8:
			            RD2D;	
							
CMP cmp(
	.RD1(RD1D_true),
	.RD2(RD2D_true),
	.jump_OP(jump_OP),
	.next_OP(next_OP),
	.link(linkD)
);
NPC npc(
    .next_OP(next_OP),
    .imm16(imm16),
    .imm26(imm26),
    .ra(RD1D_true),
    .PC(PCD),
    .nPC(nPC)
    );
	 
wire clr;
assign clr = (nPC === PCD + 4) ? 1'b0 : 1'b1;
//-------------F------------//   

wire [31:0] PCF;
wire [31:0] instrF;
wire stallF;
PC pc(
	 .stall(stallF),
	 .clr(clr),
    .reset(reset),
    .clk(clk),
    .nPC(nPC),
    .PC(PCF)
    );
assign i_inst_addr = PCF;
assign instrF = i_inst_rdata;
//不需要取指功能，但仍然需要计算取出的指令对应的pc

//-------------E------------//
reg [31:0] RD1E;
reg [31:0] RD2E;
reg [4:0] rsE;
reg [4:0] rtE;
reg [4:0] rdE;
reg [31:0] PCE;
reg [4:0] sE;
reg [1:0] RegDstE;
reg RegWEE;
reg ALU_SE;
reg ALU_BE;
reg [3:0] ALU_OPE;
reg [1:0] MemWEE;
reg [1:0] Mem2RegE;
reg [31:0] imm32E;
reg linkE;
reg startE;
reg [3:0] MUL_OPE;
always @(posedge clk)begin
   if(clrE || reset) begin
		RD1E <= 0;
		RD2E <= 0;
		rsE <= 0;
		rtE <= 0;
		rdE <= 0;
		sE <= 0;
		PCE <= 0;
		RegDstE <= 0;
		RegWEE <= 0;
		ALU_SE <= 0;
		ALU_BE <= 0;
		ALU_OPE <= 0;
		MemWEE <= 0;
		imm32E <= 0;
      Mem2RegE <= 0;		
		linkE <= 0;
		startE <= 0;
		MUL_OPE <= 0;
	end
	else begin
		RD1E <= RD1D;
		RD2E <= RD2D;
		rsE <= rsD;
		rtE <= rtD;
		rdE <= rdD;
		sE <= sD;
		PCE <= PCD;
		RegDstE <= RegDstD;
		RegWEE <= RegWED;
		ALU_SE <= ALU_SD;
		ALU_BE <= ALU_BD;
		ALU_OPE <= ALU_OPD;
		MemWEE <= MemWED;
		imm32E <= imm32D;
		Mem2RegE <= Mem2RegD;
		linkE <= linkD;
		MUL_OPE <= MUL_OPD;
		startE <= startD;
	end
end

reg [31:0] ALU_resultM; //在M模块中赋值

wire [4:0] GRF_addrE;
wire [31:0] A;
wire [31:0] RD2E_true;
wire [31:0] B;
wire [4:0] S;

assign GRF_addrE = (RegDstE == 2'd1) ? rdE : 
                   (RegDstE == 2'd2) ? 31 :
                                       rtE;
assign A = (forwardAE == 3'b001) ? ALU_resultM:
           (forwardAE == 3'b010) ? GRF_dataW:
			  (forwardAE == 3'b011) ? PCM + 8:
			  (forwardAE == 3'b100) ? PCW + 8:
			                         RD1E;
assign RD2E_true =  (forwardBE == 3'b001) ? ALU_resultM:
			           (forwardBE == 3'b010) ? GRF_dataW:
						  (forwardBE == 3'b011) ? PCM + 8:
						  (forwardBE == 3'b100) ? PCW + 8:
			            RD2E;											 
assign B = (ALU_BE == 1'b1) ? imm32E : RD2E_true;

assign S = (ALU_SE == 1'b1) ? 5'h10 : sE;


wire [31:0] ALU_resultE;
wire ifEqE;
wire ifGtE;
ALU alu(
    .OP(ALU_OPE),
    .S(S),
    .A(A),
    .B(B),
    .result(ALU_resultE),
    .ifEq(ifEqE),
    .ifGt(ifGtE)
);

wire busyE;
wire [31:0] MUL_resultE;
wire [31:0] hiE;
wire [31:0] loE;
MUL mul(
    .reset(reset),
    .clk(clk),
    .A(A),
    .B(B),
    .start(startE),
    .MUL_OP(MUL_OPE),
    .busy(busyE),
    .out(MUL_resultE),
    .hi(hiE),
    .lo(loE)
);

wire [31:0] resultE;
assign resultE = (MUL_OPE === `mul_mfhi || MUL_OPE === `mul_mflo)? MUL_resultE : ALU_resultE;

//-------------M------------//
//reg [31:0] ALU_resultM;
reg [4:0] rtM;
reg [31:0] DM_inM;
reg [4:0] GRF_addrM;
reg [31:0] PCM;
reg RegWEM;
reg [1:0] MemWEM;
reg [1:0] Mem2RegM; 
reg linkM;
always @(posedge clk)begin
	if(reset)begin
	   rtM <= 0;
		ALU_resultM <= 0;
		DM_inM <= 0;
		GRF_addrM <= 0;
		PCM <= 0;
		RegWEM <= 0;
		MemWEM <= 0;
      Mem2RegM <= 0;		
		linkM <= 0;
	end
	else begin
	   rtM <= rtE;
		ALU_resultM <= resultE;
		DM_inM <= RD2E_true;
		GRF_addrM <= GRF_addrE;
		PCM <= PCE;
		RegWEM <= RegWEE;
		MemWEM <= MemWEE;
		Mem2RegM <= Mem2RegE;
		linkM <= linkE;
	end
end

wire [31:0] DM_inM_true;
assign DM_inM_true = (forwardM === 1)? GRF_dataW : DM_inM;
BYTEEN byteen(
    .raw_data(DM_inM_true),
	 .MemWEM(MemWEM),
	 .Addr10(ALU_resultM[1:0]),
	 .byteen(m_data_byteen),
	 .after_data(m_data_wdata)
);
wire [31:0] DM_outM;
assign DM_outM = m_data_rdata;
/*DM dm(
	 .PC(PCM),
    .clk(clk),
    .WE(MemWEM),
    .A(ALU_resultM),
    .Din(DM_dataM),
    .reset(reset),
    .Dout(DM_outM)
    );
*/
assign m_data_addr = ALU_resultM;
//assign m_data_byteen
assign m_inst_addr = PCM;

wire [31:0] dataFromMemM;
EXT2 ext2(
	.Mem2Reg(Mem2RegM),
	.Addr10(ALU_resultM[1:0]),
	.Mout(DM_outM),
   .dataFromMem(dataFromMemM)	
);
//-------------W------------//
reg [31:0] ALU_resultW;
reg [31:0] dataFromMemW;
reg linkW;
reg [1:0] Mem2RegW;
//wire [4:0] GRF_addrW; 
//wire [31:0] GRF_dataW; 
//reg RegWEW;
//reg PCW;
always @(posedge clk)begin
	if(reset)begin
		RegWEW <= 0;
		PCW <= 0;
		ALU_resultW <= 0;
		dataFromMemW <= 0;
		GRF_addrW <= 0;
		linkW <= 0;
		Mem2RegW <= 0;
	end
	else begin
		RegWEW <= RegWEM;
		PCW <= PCM;
		ALU_resultW <= ALU_resultM;
		dataFromMemW <= dataFromMemM;
		GRF_addrW <= GRF_addrM;
		linkW <= linkM;
		Mem2RegW <= Mem2RegM;
	end
end
assign GRF_dataW = (Mem2RegW !== 0) ? dataFromMemW:
                   (linkW) ? PCW + 8:
						  ALU_resultW; 


//-------------冲突处理------------//
wire [2:0] forwardAE;
wire [2:0] forwardBE;
wire forwardM;
wire [2:0] forwardAD;
wire [2:0] forwardBD;
//wire stallF;
wire stallD;
wire stallE;
wire clrE;

conflict cf(
    .op(op),
	 .func(func),
	 //数据冲突/转发
	 .rsE(rsE),
	 .rtE(rtE),
	 .rtM(rtM),
	 .GRF_addrM(GRF_addrM),
	 .GRF_addrW(GRF_addrW),
	 .RegWEM(RegWEM),
	 .RegWEW(RegWEW),
	 .forwardAE(forwardAE),
	 .forwardBE(forwardBE),
	 .forwardM(forwardM),
	 //悬停
	 .GRF_addrE(GRF_addrE),
	 .rsD(rsD),
	 .rtD(rtD),
	 .Mem2RegE(Mem2RegE),
	 .Mem2RegM(Mem2RegM),
	 .Mem2RegW(Mem2RegW),
	 .stallF(stallF),
	 .stallD(stallD),
	 .clrE(clrE),
	 //控制冲突/转发
	 .RegWEE(RegWEE),
	 .forwardAD(forwardAD),
	 .forwardBD(forwardBD),	
    .linkE(linkE),
    .linkM(linkM),
    .linkW(linkW),
	 //
	 .busyE(busyE),
	 .startE(startE),
	 .MUL_OPD(MUL_OPD) 
    );

endmodule 

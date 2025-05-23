`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:06:13 11/17/2024 
// Design Name: 
// Module Name:    conflict 
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

module conflict(
    input [5:0] op,
	 input [5:0] func,
	 //���ݳ�ͻ/ת��
	 input [4:0] rsE,
	 input [4:0] rtE,
	 input [4:0] rtM,
	 input [4:0] GRF_addrM,
	 input [4:0] GRF_addrW,
	 input RegWEM,
	 input RegWEW,
	 output [2:0] forwardAE,
	 output [2:0] forwardBE,
	 output forwardM,
	 //��ͣ
	 input [4:0] GRF_addrE,
	 input [4:0] rsD,
	 inout [4:0] rtD,
	 input [1:0] Mem2RegE,
	 input [1:0] Mem2RegM,
	 input [1:0] Mem2RegW,
	 output stallF,
	 output stallD,
	 output clrE,
	 //���Ƴ�ͻ/ת��
	 input RegWEE,
	 output [2:0] forwardAD,
	 output [2:0] forwardBD,	
    input linkE,
    input linkM,
    input linkW,	 
	 //
	 input busyE,
	 input startE,
	 input [3:0] MUL_OPD
    );

//---------------���ݳ�ͻ/ת��---------------//
assign forwardAE = ((rsE!==0)&&(rsE === GRF_addrM)&&RegWEM&&(Mem2RegM === 0))? 3'b001:
                   ((rsE===31)&&(linkM))? 3'b011:
                   ((rsE!==0)&&(rsE === GRF_addrW)&&RegWEW)? 3'b010:						 
						 ((rsE===31)&&(linkW))? 3'b100:						 
						                       3'b000; 

assign forwardBE = ((rtE!==0)&&(rtE === GRF_addrM)&&RegWEM&&(Mem2RegM === 0))? 3'b001:
                   ((rtE===31)&&(linkM))? 3'b011:
                   ((rtE!==0)&&(rtE === GRF_addrW)&&RegWEW)? 3'b010:						 
						 ((rtE===31)&&(linkW))? 3'b100:								 
						                       3'b000; 

assign forwardM = ((rtM === GRF_addrW && rtM !== 0) && (RegWEW === 1 || linkW));

//---------------���Ƴ�ͻ/ת��----------------//
assign forwardAD = ((rsD===31)&&linkE)? 3'b011:
                   ((rsD!==0)&&(rsD === GRF_addrM)&&RegWEM&&(Mem2RegM === 0))? 3'b001:
						 ((rsD===31)&&linkM)? 3'b100:
                   ((rsD!==0)&&(rsD === GRF_addrW)&&RegWEW)? 3'b010:						 
						 ((rsD===31)&&linkW)? 3'b101:
						                      3'b000; 

assign forwardBD = ((rtD===31)&&linkE)? 3'b011:
                   ((rtD!==0)&&(rtD === GRF_addrM)&&RegWEM&&(Mem2RegM === 0))? 3'b001:
						 ((rtD===31)&&linkM)? 3'b100:
                   ((rtD!==0)&&(rtD === GRF_addrW)&&RegWEW)? 3'b010:						 
						 ((rtD===31)&&linkW)? 3'b101:						 
						                      3'b000; 
				

//---------------------����---------------------//

wire stall;
wire aluorder_1;
wire aluorder_2;
wire jumporder_1;
wire jumporder_2;
//aluorder_1ָ��rs��rt����Ҫ�õ� ��r����store�ࣩ 
assign aluorder_1 = ((op === 6'b0&&(func === `add || func === `sub || func === `o_r || func === `a_nd || func === `slt || func === `sltu 
                                    || func === `mult || func === `multu || func === `div || func === `divu))
                   || op === `sw || op === `sb || op === `sh);
//aluorder_2ָ��ֻ��Ҫ�õ�rs ��i����loard�ࣩ
assign aluorder_2 =  (op === `ori || op === `andi || op === `addi || 
                      op === `lw || op === `lh || op === `lb ||
						   (op === 6'b0 && (func === `mthi || func === `mtlo)));				 

//jumporder_1ָ��rs��rt����Ҫ�õ�
assign jumporder_1 = (op === `beq || op === `bne);

//jumporder_2ָ��ֻ��Ҫ�õ�rs 
assign jumporder_2 = (op === 6'b0 && func === `jr);

assign stall = (   //��ALU�ļ���ָ�ֻ��Ҫ�õ�rs����M����loardָ���ͻ   
                   ((Mem2RegE !== 0) && (rsD === rtE) && aluorder_2)    || 
             		 //��ALU�ļ���ָ�rs��rt����Ҫ�õ�����M����loardָ���ͻ  				 
                   ((Mem2RegE !== 0) && ((rsD === rtE)||(rtD === rtE)) && aluorder_1)    ||    
						 
                    //��D��beq/bneָ������ALU�ļ���ָ���ͻ						 
					    ( jumporder_1 && !linkE && (RegWEE === 1) && ((rsD === GRF_addrE && rsD!==0)||(rtD === GRF_addrE && rtD!==0)) ) ||    
                    //��D��beq/bneָ������M��lָ���ͻ						 
					    (jumporder_1 && (Mem2RegM !== 0) && (RegWEM === 1) && ((rsD === GRF_addrM && rsD!==0)||(rtD === GRF_addrM && rtD!==0)) ) || 
						 //��D��jrָ������ALU�ļ���ָ���ͻ 	
						 (jumporder_2 && !linkE && (RegWEE === 1) && (rsD === GRF_addrE) &&  (rsD!==0))   ||      
                   //��D��jrָ������M��lָ���ͻ							 
                   (jumporder_2 && (Mem2RegM !== 0) && (RegWEM === 1) && (rsD === GRF_addrM) &&  (rsD!==0))  ||
						 ((busyE||startE)&&(MUL_OPD !== 0))   )	                             				 
                     ? 1 : 0;
							

assign stallF = stall;
assign stallD = stall;
assign clrE =  stall;

endmodule

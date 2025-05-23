`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:36:19 11/01/2024 
// Design Name: 
// Module Name:    Controller 
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

module Controller(
    input [5:0] op,
    input [5:0] func,
    output [3:0] jump_OP,
    output [1:0] RegDst,
    output RegWE,
    output ALU_S,
    output ALU_B,
    output [3:0] ALU_OP,
    output [1:0] MemWE,
	 output [1:0] Mem2Reg,
    output EXT_OP,
	 //
	 output [3:0] MUL_OP,
	 output start
    );

assign RegDst = (op === 6'b0 && (func === `add || func === `sub || func === `srl || func === `a_nd || func === `o_r || func === `slt || func === `sltu || func === `mfhi || func === `mflo)) ? 2'd1:
                (op === `jal) ? 2'd2:
					  2'd0;
assign RegWE = ((op === 6'b0 && (func === `add || func === `sub || func === `srl || func === `a_nd || func === `o_r || func === `slt || func === `sltu || func === `mfhi || func === `mflo))||
                 op === `lw || op === `lb || op === `lh || 
					  op === `lui || op === `ori || op === `addi || op === `andi)? 1'b1:1'b0;
assign ALU_S = (op === `lui) ? 1'b1 : 1'b0;
assign ALU_B = (op === `ori || op ===`lui || op === `addi || op === `andi ||
                op === `lw || op === `lh || op === `lb || 
					 op === `sw || op === `sh || op === `sb  ) ? 1'b1:1'b0;
assign MemWE = (op === `sw) ? 2'b01:
               (op === `sh) ? 2'b10:
					(op === `sb) ? 2'b11:
					2'b00;

assign Mem2Reg = (op === `lw) ? 2'b01:
                 (op === `lh) ? 2'b10:
                 (op === `lb) ? 2'b11:
                  2'b00;					  
									
assign jump_OP = (op === `bne) ? `jump_bne:
                 (op === `beq) ? `jump_beq:
                 (op === `jal) ? `jump_jal:
                 (op === 6'b0 && func === `jr) ? `jump_jr:
					   0;
					  
assign EXT_OP = (op === `sw || op === `sh || op === `sb || 
                 op === `lw || op === `lb || op === `lh || 
					  op === `addi) ? 1'b1:1'b0;

assign ALU_OP = (op === 6'b0 && func === `sub) ? `alu_sub:
                (op === `ori ||(op === 6'b0 && func === `o_r)) ? `alu_or:
					 (op === `lui) ? `alu_left:
					 (op === 6'b0 && func === `srl) ? `alu_right:
					 (op === 6'b0 && func === `a_nd ||(op === `andi))? `alu_and:
					 (op === 6'b0 && func === `slt)?  `alu_cmp:
					 (op === 6'b0 && func === `sltu)? `alu_cmpu:
					 4'd0;


assign MUL_OP = (op === 6'b0 && func === `mult)? `mul_mult:
                (op === 6'b0 && func === `multu)? `mul_multu:
					 (op === 6'b0 && func === `div)? `mul_div:
					 (op === 6'b0 && func === `divu)? `mul_divu:
					 (op === 6'b0 && func === `mfhi)? `mul_mfhi:
					 (op === 6'b0 && func === `mflo)? `mul_mflo:
					 (op === 6'b0 && func === `mthi)? `mul_mthi:
					 (op === 6'b0 && func === `mtlo)? `mul_mtlo:
					 0;

assign start = (op === 6'b0 &&(func === `mult || func === `multu || func === `div || func === `divu))? 1:0;

endmodule

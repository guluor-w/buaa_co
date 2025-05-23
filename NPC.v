`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:35:45 11/01/2024 
// Design Name: 
// Module Name:    NPC 
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
module NPC(
    input [3:0] next_OP,
    input [15:0] imm16,
    input [25:0] imm26,
    input [31:0] ra,
    input [31:0] PC,
    output [31:0] nPC
    );
wire [31:0] imm16_ext;
assign imm16_ext = {{16{imm16[15]}},imm16};

assign nPC = (next_OP === 4'd1) ? PC + 4 + (imm16_ext<<2):
             (next_OP === 4'd2) ? {PC[31:28],imm26,{2{1'b0}}}:
				 (next_OP === 4'd3) ? ra:
				 PC + 4;

endmodule

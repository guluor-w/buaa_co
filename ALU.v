`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:30:17 11/01/2024 
// Design Name: 
// Module Name:    ALU 
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
 
module ALU(
    input [3:0] OP,
    input [4:0] S,
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] result,
    output ifEq,
    output ifGt
    );

assign ifEq = (A === B)? 1'b1:1'b0;
assign ifGt = (A > B)? 1'b1:1'b0;

always @(*)begin
	case(OP)
		`alu_right:begin
			 result = A >> S;
		end
		`alu_sub:begin
			result = A - B;
		end
		`alu_or:begin
			result = A | B;
		end
		`alu_left:begin
			result = B << S;
		end
		`alu_and:begin
			result = A & B;
		end
		`alu_cmp:begin
			result = ($signed(A) < $signed(B))? 1:0;
		end
		`alu_cmpu:begin
		   result = (A < B)? 1:0;
		end
		default: result = A + B;
	endcase
end

endmodule

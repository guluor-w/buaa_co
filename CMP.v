`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:35:29 11/28/2024 
// Design Name: 
// Module Name:    CMP 
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

module CMP(
	input [31:0] RD1,
	input [31:0] RD2,
	input [3:0] jump_OP,
	output reg [3:0] next_OP,
	output reg link
    );

initial begin
	next_OP = 0;
	link = 0;
end

always @(*)begin
	case(jump_OP)
		`jump_beq:begin
		   link = 0;
			if(RD1 === RD2)begin
				next_OP = 4'd1;
			end
			else begin
				next_OP = 0;
			end
		end
		`jump_bne:begin
			link = 0;
			if(RD1 !== RD2)begin
				next_OP = 4'd1;
			end
			else begin
				next_OP = 0;
			end
		end
		`jump_jal:begin
			next_OP = 4'd2;
			link = 1;
		end
		`jump_jr:begin
		   link = 0;
			next_OP = 4'd3;
		end
		default:begin
			link = 0;
			next_OP = 0;
		end
	endcase
end
	

endmodule

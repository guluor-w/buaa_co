`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:35:42 11/29/2024 
// Design Name: 
// Module Name:    MUL 
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

module MUL(
    input reset,
    input clk,
    input [31:0] A,
    input [31:0] B,
    input start,
    input [3:0] MUL_OP,
    output busy,
    output [31:0] out,
    output reg [31:0] hi,
    output reg [31:0] lo
    );

reg [31:0] hi_temp;
reg [31:0] lo_temp;
reg [3:0] delay;

initial begin
	hi = 0;
	lo = 0;
	hi_temp = 0;
	lo_temp = 0;
	delay = 0;
end

always @(posedge clk)begin
	if(reset)begin
		hi <= 0;
		lo <= 0;
		hi_temp <= 0;
		lo_temp <= 0;
		delay <= 0;
	end
	else if(!busy && start)begin
		case(MUL_OP)
			`mul_mult:begin
				{hi_temp,lo_temp} <= $signed(A) * $signed(B);
				delay <= 5;
			end
			`mul_multu:begin
				{hi_temp,lo_temp} <= A * B;
				delay <= 5;
			end
			`mul_div:begin
				{hi_temp,lo_temp} <= {{$signed(A) % $signed(B)},{$signed(A) / $signed(B)}};
				delay <= 10;
			end	
			/*`mul_divu*/default:begin
				{hi_temp,lo_temp} <= {{A % B},{A / B}};
				delay <= 10;
			end			
		endcase
	end
	else if(!busy && !start)begin
		 case(MUL_OP)
			 `mul_mthi:begin
				 hi <= A;
			 end
			 `mul_mtlo:begin
				 lo <= A;
			 end
			 default:begin
				 hi <= hi;
				 lo <= lo;
			 end
		 endcase
	end
	else begin/*busy*/
		 hi <= hi;
		 lo <= lo;
	end
end


always @(posedge clk)begin
      if(delay > 0)begin
			delay <= delay - 1;
		end
end
assign busy =(delay === 0)? 0:1;

always @(negedge busy)begin
	hi = hi_temp;
	lo = lo_temp;
end


assign out = (MUL_OP === `mul_mfhi)? hi : lo;

endmodule

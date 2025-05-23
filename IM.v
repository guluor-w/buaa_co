`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:32:14 11/01/2024 
// Design Name: 
// Module Name:    IM 
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
module IM(
	 input stall,
	 input clr,
    input reset,
    input clk,
    input [31:0] nPC,
    output [31:0] instr,
    output reg [31:0] PC
    );
reg [31:0] Mem [4095:0];
integer i;
initial begin
	 PC <= 32'h3000;
	 for (i = 0; i < 4095; i = i + 1) begin
		 Mem[i] = 0;	
	 end
	 $readmemh("code.txt", Mem);
end

wire [31:0] Ad;

always @(posedge clk)begin
	 if(reset)begin
		 PC <= 32'h3000;
	 end
	 else if(stall)begin
		 PC <= PC;
	 end
	 else if(clr) begin
		 PC <= nPC;
	 end
	 else begin
		 PC <= PC + 4;
	 end
end

assign Ad = (PC-32'h3000)>>2;
assign instr = Mem[Ad[12:0]];

endmodule


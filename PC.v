`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:34:28 11/28/2024 
// Design Name: 
// Module Name:    PC 
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
module PC(
	 input stall,
	 input clr,
    input reset,
    input clk,
    input [31:0] nPC,
    output reg [31:0] PC
    );

initial begin
	 PC = 32'h3000;
end

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

endmodule


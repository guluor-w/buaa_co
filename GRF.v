`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:30:57 11/01/2024 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
	 input [31:0] PC,	
    input clk,
    input WE,
    input reset,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
    output [31:0] RD1,
    output [31:0] RD2
    );

reg [31:0] Registers [31:0];

assign RD1 = (A1 === 32'b0) ? 32'b0 :
             (A1 === A3 && WE === 1) ? WD:
             Registers[A1];
assign RD2 = (A2 === 32'b0) ? 32'b0 : 
             (A2 === A3 && WE === 1) ? WD:
              Registers[A2];

integer i;
initial begin
    for (i = 0; i < 32; i = i + 1)begin
		Registers[i] = 32'b0;
	 end
end

always @(posedge clk)begin
	 if(reset)begin
		for(i = 0; i < 32; i = i + 1)begin
			Registers[i] = 32'b0;
		end
	 end
	 else if(WE == 1'b1 && A3 != 5'b0)begin
		Registers[A3] = WD;
//		$display("%d@%h: $%d <= %h", $time, PC, A3, WD);
	 end
end

endmodule

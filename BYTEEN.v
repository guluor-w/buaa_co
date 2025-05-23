`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:10:41 11/28/2024 
// Design Name: 
// Module Name:    BYTEEN 
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
module BYTEEN(
    input [31:0] raw_data,
	 input [1:0] MemWEM,
	 input [1:0] Addr10,
	 output reg[3:0] byteen,
	 output [31:0] after_data
    );
	 
	 initial begin
		byteen = 0;
	 end
	 
	 always @(*)begin
		case(MemWEM)
		2'b01:begin
			 byteen = 4'b1111;  
		end
		2'b10:begin
			 if(Addr10[1] === 0)begin
				byteen = 4'b0011;
			 end
			 else begin
				byteen = 4'b1100;
			 end
		end
		2'b11:begin
			if(Addr10 === 2'b00)begin
				byteen = 4'b0001;
			end
			else if(Addr10 === 2'b01)begin
				byteen = 4'b0010;
			end
			else if(Addr10 === 2'b10)begin
				byteen = 4'b0100;
			end		
			else begin
				byteen = 4'b1000;
			end			
		end
		default: byteen = 4'b0000;
		endcase
	 end
    
	 assign after_data = (byteen === 4'b1100 || byteen === 4'b0100)? raw_data << 16:
	                     (byteen === 4'b0010)? raw_data << 8:
								(byteen === 4'b1000)? raw_data << 24:
								raw_data;

endmodule

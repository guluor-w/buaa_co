`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:03:49 11/28/2024 
// Design Name: 
// Module Name:    EXT2 
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
module EXT2(
	input [1:0] Mem2Reg,
	input [1:0] Addr10,
	input [31:0] Mout,
   output reg [31:0] dataFromMem	
    );
	
	initial begin
		dataFromMem	= 0;
	end
	
	always@(*)begin
		case(Mem2Reg)
		2'b01:begin
			dataFromMem = Mout;
		end
		2'b10:begin
			if(Addr10[1] === 0)begin
				dataFromMem = {{16{Mout[15]}},Mout[15:0]};
			end
			else begin
				dataFromMem = {{16{Mout[31]}},Mout[31:16]};
			end
		end
		2'b11:begin
			if(Addr10 === 2'b00)begin
				dataFromMem = {{24{Mout[7]}},Mout[7:0]};
			end
			else if(Addr10 === 2'b01)begin
				dataFromMem = {{24{Mout[15]}},Mout[15:8]};
			end
			else if(Addr10 === 2'b10)begin
				dataFromMem = {{24{Mout[23]}},Mout[23:16]};
			end
			else begin
				dataFromMem = {{24{Mout[31]}},Mout[31:24]};
			end			
		end
		default: dataFromMem = {{16{Mout[15]}},Mout[15:0]};
		endcase
	end


endmodule

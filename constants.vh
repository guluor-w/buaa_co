// constants.vh
`ifndef CONSTANTS_VH
`define CONSTANTS_VH

`define lw 6'b100011
`define sw 6'b101011
`define ori 6'b001101
`define lui 6'b001111
`define add 6'b100000 //func
`define sub 6'b100010 //func
`define beq 6'b000100
`define srl 6'b000010 //func
`define jal 6'b000011
`define jr 6'b001000 //func
`define a_nd 6'b100100 //func
`define o_r  6'b100101 //func
`define slt 6'b101010 //func
`define sltu 6'b101011 //func
`define addi 6'b001000
`define andi 6'b001100
`define lb 6'b100000
`define lh 6'b100001
`define sb 6'b101000
`define sh 6'b101001
`define bne 6'b000101

`define mult 6'b011000
`define multu 6'b011001
`define div 6'b011010
`define divu 6'b011011
`define mfhi 6'b010000
`define mflo 6'b010010
`define mthi 6'b010001
`define mtlo 6'b010011

`define alu_add 4'd0
`define alu_sub 4'd1
`define alu_or 4'd2
`define alu_left 4'd3
`define alu_and 4'd4
`define alu_cmp 4'd5
`define alu_cmpu 4'd6 
`define alu_right 4'd7

`define jump_beq 4'd1
`define jump_bne 4'd2
`define jump_jal 4'd3
`define jump_jr  4'd4

`define mul_mult 4'b0001
`define mul_multu 4'b0010 
`define mul_div 4'b0011 
`define mul_divu 4'b0100
`define mul_mfhi 4'b0101
`define mul_mflo 4'b0110
`define mul_mthi 4'b0111
`define mul_mtlo 4'b1000

`endif // CONSTANTS_VH
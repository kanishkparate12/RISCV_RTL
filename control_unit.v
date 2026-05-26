module riscv_decoder(
    input [6:0] funct7,
    input [2:0] funct3,
    input [6:0] opcode,
    output reg is_add, is_sub, is_and, is_or,  is_xor,
    output reg is_sll, is_srl, is_sra, is_slt, is_sltu,
    output reg is_addi, is_andi, is_ori, is_xori,
    output reg is_slli, is_srli, is_srai, is_slti, is_sltiu,
    output reg is_beq, is_bne, is_blt, is_bge,
    output reg is_bltu, is_bgeu,
    output reg is_jal, is_jalr,
    output reg is_lui, is_auipc,
    output reg is_lw, is_sw
);
    reg [10:0] dec_bits;
    always @(*) begin
        dec_bits  = {funct7[5], funct3, opcode};
        is_add = 1'b0; 
	is_sub = 1'b0; 
	is_and = 1'b0;
        is_or = 1'b0; 
	is_xor = 1'b0; 
	is_sll = 1'b0;
        is_srl = 1'b0; 
	is_sra = 1'b0; 
	is_slt = 1'b0;
        is_sltu = 1'b0; 
	is_addi = 1'b0; 
	is_andi = 1'b0;
        is_ori = 1'b0; 
	is_xori = 1'b0; 
	is_slli = 1'b0;
        is_srli = 1'b0; 
	is_srai = 1'b0; 
	is_slti = 1'b0;
        is_sltiu = 1'b0; 
	is_beq = 1'b0; 
	is_bne = 1'b0;
        is_blt = 1'b0; 
	is_bge = 1'b0; 
	is_bltu = 1'b0;
        is_bgeu = 1'b0; 
	is_jal = 1'b0; 
	is_jalr = 1'b0;
        is_lui = 1'b0; 
	is_auipc = 1'b0;
        is_lw = 1'b0; 
	is_sw = 1'b0;

        casez (dec_bits)
            11'b0_000_0110011: is_add = 1'b1;
            11'b1_000_0110011: is_sub = 1'b1;
            11'b0_111_0110011: is_and = 1'b1;
            11'b0_110_0110011: is_or = 1'b1;
            11'b0_100_0110011: is_xor = 1'b1;
            11'b0_001_0110011: is_sll = 1'b1;
            11'b0_101_0110011: is_srl = 1'b1;
            11'b1_101_0110011: is_sra = 1'b1;
            11'b0_010_0110011: is_slt = 1'b1;
            11'b0_011_0110011: is_sltu = 1'b1;
            11'b?_000_0010011: is_addi = 1'b1;
            11'b?_111_0010011: is_andi = 1'b1;
            11'b?_110_0010011: is_ori = 1'b1;
            11'b?_100_0010011: is_xori = 1'b1;
            11'b0_001_0010011: is_slli = 1'b1;
            11'b0_101_0010011: is_srli = 1'b1;
            11'b1_101_0010011: is_srai = 1'b1;
            11'b?_010_0010011: is_slti = 1'b1;
            11'b?_011_0010011: is_sltiu = 1'b1;
            11'b?_000_1100011: is_beq = 1'b1;
            11'b?_001_1100011: is_bne = 1'b1;
            11'b?_100_1100011: is_blt = 1'b1;
            11'b?_101_1100011: is_bge = 1'b1;
            11'b?_110_1100011: is_bltu = 1'b1;
            11'b?_111_1100011: is_bgeu = 1'b1;
            11'b?_010_0000011: is_lw = 1'b1;
            11'b?_010_0100011: is_sw = 1'b1;
            11'b?_???_1101111: is_jal = 1'b1;
            11'b?_000_1100111: is_jalr = 1'b1;
            11'b?_???_0110111: is_lui = 1'b1;
            11'b?_???_0010111: is_auipc = 1'b1;
            default: ;
        endcase
    end
endmodule
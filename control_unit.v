module riscv_decoder(
    input [6:0] funct7,
    input [2:0] funct3,
    input [6:0] opcode,

    output reg is_add,
    output reg is_sub,
    output reg is_and,
    output reg is_or,
    output reg is_xor,
    output reg is_sll,
    output reg is_srl,
    output reg is_sra,
    output reg is_slt,
    output reg is_sltu,

    output reg is_addi,
    output reg is_andi,
    output reg is_ori,
    output reg is_xori,
    output reg is_slli,
    output reg is_srli,
    output reg is_srai,
    output reg is_slti,
    output reg is_sltiu,

    output reg is_beq,
    output reg is_bne,
    output reg is_blt,
    output reg is_bge,
    output reg is_bltu,
    output reg is_bgeu,

    output reg is_jal,
    output reg is_jalr,

    output reg is_lui,
    output reg is_auipc
);

reg [10:0] dec_bits;

always @(*) begin
    dec_bits = {funct7[5], funct3, opcode};

    is_add   = 1'b0;
    is_sub   = 1'b0;
    is_and   = 1'b0;
    is_or    = 1'b0;
    is_xor   = 1'b0;
    is_sll   = 1'b0;
    is_srl   = 1'b0;
    is_sra   = 1'b0;
    is_slt   = 1'b0;
    is_sltu  = 1'b0;

    is_addi  = 1'b0;
    is_andi  = 1'b0;
    is_ori   = 1'b0;
    is_xori  = 1'b0;
    is_slli  = 1'b0;
    is_srli  = 1'b0;
    is_srai  = 1'b0;
    is_slti  = 1'b0;
    is_sltiu = 1'b0;

    is_beq   = 1'b0;
    is_bne   = 1'b0;
    is_blt   = 1'b0;
    is_bge   = 1'b0;
    is_bltu  = 1'b0;
    is_bgeu  = 1'b0;

    is_jal   = 1'b0;
    is_jalr  = 1'b0;

    is_lui   = 1'b0;
    is_auipc = 1'b0;

    casez (dec_bits)

        11'b00000110011: is_add   = 1'b1;
        11'b10000110011: is_sub   = 1'b1;
        11'b01110110011: is_and   = 1'b1;
        11'b01100110011: is_or    = 1'b1;
        11'b01000110011: is_xor   = 1'b1;
        11'b00010110011: is_sll   = 1'b1;
        11'b01010110011: is_srl   = 1'b1;
        11'b11010110011: is_sra   = 1'b1;
        11'b00100110011: is_slt   = 1'b1;
        11'b00110110011: is_sltu  = 1'b1;

        11'b?0000010011: is_addi  = 1'b1;
        11'b?1110010011: is_andi  = 1'b1;
        11'b?1100010011: is_ori   = 1'b1;
        11'b?1000010011: is_xori  = 1'b1;
        11'b00010010011: is_slli  = 1'b1;
        11'b01010010011: is_srli  = 1'b1;
        11'b11010010011: is_srai  = 1'b1;
        11'b?0100010011: is_slti  = 1'b1;
        11'b?0110010011: is_sltiu = 1'b1;

        11'b?0001100011: is_beq   = 1'b1;
        11'b?0011100011: is_bne   = 1'b1;
        11'b?1001100011: is_blt   = 1'b1;
        11'b?1011100011: is_bge   = 1'b1;
        11'b?1101100011: is_bltu  = 1'b1;
        11'b?1111100011: is_bgeu  = 1'b1;

        11'b????1101111: is_jal   = 1'b1;
        11'b?0001100111: is_jalr  = 1'b1;

        11'b????0110111: is_lui   = 1'b1;
        11'b????0010111: is_auipc = 1'b1;

        default: begin
        end

    endcase
end

endmodule
module alu(
    input  [31:0] rd1, rd2,
    input  [31:0] imm,
    input  [31:0] pc,

    input is_add,
    input is_sub,
    input is_and,
    input is_or,
    input is_xor,
    input is_sll,
    input is_srl,
    input is_sra,
    input is_slt,
    input is_sltu,

    input is_addi,
    input is_andi,
    input is_ori,
    input is_xori,
    input is_slli,
    input is_srli,
    input is_srai,
    input is_slti,
    input is_sltiu,

    input is_beq,
    input is_bne,
    input is_blt,
    input is_bge,
    input is_bltu,
    input is_bgeu,

    input is_jal,
    input is_jalr,

    input is_lui,
    input is_auipc,

    output reg [31:0] result
);

always @(*) begin
    result = 32'b0;

    if (is_add)
        result = rd1 + rd2;

    else if (is_sub)
        result = rd1 - rd2;

    else if (is_and)
        result = rd1 & rd2;

    else if (is_or)
        result = rd1 | rd2;

    else if (is_xor)
        result = rd1 ^ rd2;

    else if (is_sll)
        result = rd1 << rd2[4:0];

    else if (is_srl)
        result = rd1 >> rd2[4:0];

    else if (is_sra)
        result = $signed(rd1) >>> rd2[4:0];

    else if (is_slt)
        result = ($signed(rd1) < $signed(rd2)) ? 32'd1 : 32'd0;

    else if (is_sltu)
        result = (rd1 < rd2) ? 32'd1 : 32'd0;


    else if (is_addi)
        result = rd1 + imm;

    else if (is_andi)
        result = rd1 & imm;

    else if (is_ori)
        result = rd1 | imm;

    else if (is_xori)
        result = rd1 ^ imm;

    else if (is_slli)
        result = rd1 << imm[4:0];

    else if (is_srli)
        result = rd1 >> imm[4:0];

    else if (is_srai)
        result = $signed(rd1) >>> imm[4:0];

    else if (is_slti)
        result = ($signed(rd1) < $signed(imm)) ? 32'd1 : 32'd0;

    else if (is_sltiu)
        result = (rd1 < imm) ? 32'd1 : 32'd0;


    else if (is_beq)
        result = (rd1 == rd2) ? 32'd1 : 32'd0;

    else if (is_bne)
        result = (rd1 != rd2) ? 32'd1 : 32'd0;

    else if (is_blt)
        result = ($signed(rd1) < $signed(rd2)) ? 32'd1 : 32'd0;

    else if (is_bge)
        result = ($signed(rd1) >= $signed(rd2)) ? 32'd1 : 32'd0;

    else if (is_bltu)
        result = (rd1 < rd2) ? 32'd1 : 32'd0;

    else if (is_bgeu)
        result = (rd1 >= rd2) ? 32'd1 : 32'd0;


    else if (is_jal)
        result = pc + 32'd4;

    else if (is_jalr)
        result = pc + 32'd4;


    else if (is_lui)
        result = imm;

    else if (is_auipc)
        result = pc + imm;

end

endmodule

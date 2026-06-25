module riscv_top(
    input clk,
    input rst,

    input [31:0] instr,
    output [31:0] pc_out,
	
    output dmem_we,
    output [31:0] dmem_addr,
    output [31:0] dmem_wd,
    input [31:0] dmem_rd
);

    wire [31:0] pc, next_pc;
    wire [31:0] rd1, rd2, alu_result, imm, wb_data;
    wire [6:0]  opcode, funct7;
    wire [4:0]  rd, rs1, rs2;
    wire [2:0]  funct3;
    wire is_add, is_sub, is_and, is_or, is_xor;
    wire is_sll, is_srl, is_sra, is_slt, is_sltu;
    wire is_addi, is_andi, is_ori, is_xori;
    wire is_slli, is_srli, is_srai, is_slti, is_sltiu;
    wire is_beq, is_bne, is_blt, is_bge, is_bltu, is_bgeu;
    wire is_jal, is_jalr, is_lui, is_auipc;
    wire is_lw, is_sw;
    wire branch_taken;
    wire [31:0] branch_target;
    wire [31:0] jalr_target;
    wire reg_we;

    assign pc_out = pc;

    assign branch_taken = (is_beq  & alu_result[0]) |
                          (is_bne  & alu_result[0]) |
                          (is_blt  & alu_result[0]) |
                          (is_bge  & alu_result[0]) |
                          (is_bltu & alu_result[0]) |
                          (is_bgeu & alu_result[0]);

    assign branch_target = pc + imm;
    assign jalr_target   = (rd1 + imm) & 32'hFFFFFFFE;

    assign next_pc = is_jal      ? branch_target :
                     is_jalr     ? jalr_target   :
                     branch_taken ? branch_target :
                                    pc + 32'd4;

    assign reg_we = is_add | is_sub  | is_and  | is_or   | is_xor  |
                    is_sll | is_srl  | is_sra  | is_slt  | is_sltu |
                    is_addi| is_andi | is_ori  | is_xori |
                    is_slli| is_srli | is_srai | is_slti | is_sltiu|
                    is_lui | is_auipc| is_jal  | is_jalr | is_lw;

    assign wb_data = is_lw ? dmem_rd : alu_result;

    assign dmem_we = is_sw;
    assign dmem_addr = alu_result;
    assign dmem_wd = rd2;

    pc u_pc (
        .clk(clk),
        .rst(rst),
        .next_pc(next_pc),
        .pc(pc)
    );

    decoder u_dec (
        .instr(instr),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .funct3(funct3),
        .funct7(funct7),
        .imm(imm)
    );

    riscv_decoder u_idec (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .is_add(is_add),
        .is_sub(is_sub),
        .is_and(is_and),
        .is_or(is_or),
        .is_xor(is_xor),
        .is_sll(is_sll),
        .is_srl(is_srl),
        .is_sra(is_sra),
        .is_slt(is_slt),
        .is_sltu(is_sltu),

        .is_addi(is_addi),
        .is_andi(is_andi),
        .is_ori(is_ori),
        .is_xori(is_xori),
        .is_slli(is_slli),
        .is_srli(is_srli),
        .is_srai(is_srai),
        .is_slti(is_slti),
        .is_sltiu(is_sltiu),

        .is_beq(is_beq),
        .is_bne(is_bne),
        .is_blt(is_blt),
        .is_bge(is_bge),
        .is_bltu(is_bltu),
        .is_bgeu(is_bgeu),

        .is_jal(is_jal),
        .is_jalr(is_jalr),

        .is_lui(is_lui),
        .is_auipc(is_auipc),

        .is_lw(is_lw),
        .is_sw(is_sw)
    );

    regfile u_rf (
        .clk(clk),
        .we(reg_we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wb_data),
        .rd1(rd1),
        .rd2(rd2)
    );

    alu u_alu (
        .rd1(rd1),
        .rd2(rd2),
        .imm(imm),
        .pc(pc),

        .is_add(is_add),
        .is_sub(is_sub),
        .is_and(is_and),
        .is_or(is_or),
        .is_xor(is_xor),
        .is_sll(is_sll),
        .is_srl(is_srl),
        .is_sra(is_sra),
        .is_slt(is_slt),
        .is_sltu(is_sltu),

        .is_addi(is_addi),
        .is_andi(is_andi),
        .is_ori(is_ori),
        .is_xori(is_xori),
        .is_slli(is_slli),
        .is_srli(is_srli),
        .is_srai(is_srai),
        .is_slti(is_slti),
        .is_sltiu(is_sltiu),

        .is_beq(is_beq),
        .is_bne(is_bne),
        .is_blt(is_blt),
        .is_bge(is_bge),
        .is_bltu(is_bltu),
        .is_bgeu(is_bgeu),

        .is_jal(is_jal),
        .is_jalr(is_jalr),

        .is_lui(is_lui),
        .is_auipc(is_auipc),

        .is_lw(is_lw),
        .is_sw(is_sw),

        .result(alu_result)
    );

endmodule

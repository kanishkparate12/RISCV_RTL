module decoder(
    input [31:0] instr,
    output wire [6:0]  opcode,
    output reg [4:0]  rd, rs1, rs2,
    output reg [2:0]  funct3,
    output reg [6:0]  funct7,
    output reg [31:0] imm
);
    assign opcode = instr[6:0];

    always @(*) begin
        rd     = 5'b0;
        rs1    = 5'b0;
        rs2    = 5'b0;
        funct3 = 3'b0;
        funct7 = 7'b0;
        imm    = 32'b0;

        case(opcode)
            7'b0110011: begin
                rd     = instr[11:7];
                funct3 = instr[14:12];
                rs1    = instr[19:15];
                rs2    = instr[24:20];
                funct7 = instr[31:25];
            end

            7'b0010011,
            7'b0000011,
            7'b1100111: begin
                rd     = instr[11:7];
                funct3 = instr[14:12];
                rs1    = instr[19:15];
                funct7 = instr[31:25];
                imm    = {{20{instr[31]}}, instr[31:20]};
            end

            7'b0100011: begin
                funct3 = instr[14:12];
                rs1    = instr[19:15];
                rs2    = instr[24:20];
                imm    = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            end

            7'b1100011: begin
                funct3 = instr[14:12];
                rs1    = instr[19:15];
                rs2    = instr[24:20];
                imm    = {{19{instr[31]}}, instr[31], instr[7],
                          instr[30:25], instr[11:8], 1'b0};
            end

            7'b0110111,
            7'b0010111: begin
                rd  = instr[11:7];
                imm = {instr[31:12], 12'b0};
            end

            7'b1101111: begin
                rd  = instr[11:7];
                imm = {{11{instr[31]}}, instr[31], instr[19:12],
                       instr[20], instr[30:21], 1'b0};
            end

            default: begin
                rd     = 5'b0;
                rs1    = 5'b0;
                rs2    = 5'b0;
                funct3 = 3'b0;
                funct7 = 7'b0;
                imm    = 32'b0;
            end
        endcase
    end
endmodule

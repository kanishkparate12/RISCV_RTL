`timescale 1ns/1ps

module tb_riscv;

    reg clk;
    reg rst;

    reg  [31:0] instr;
    wire [31:0] pc_out;

    wire        dmem_we;
    wire [31:0] dmem_addr;
    wire [31:0] dmem_wd;
    reg  [31:0] dmem_rd;

    wire [31:0] alu_out;

    reg [31:0] imem [0:255];
    reg [31:0] dmem [0:255];

    integer i;

    riscv_top dut (
        .clk(clk),
        .rst(rst),

        .instr(instr),
        .pc_out(pc_out),

        .dmem_we(dmem_we),
        .dmem_addr(dmem_addr),
        .dmem_wd(dmem_wd),
        .dmem_rd(dmem_rd),

        .alu_out(alu_out)
    );

    always #5 clk = ~clk;

    always @(*) begin
        instr = imem[pc_out[9:2]];
        dmem_rd = dmem[dmem_addr[9:2]];
    end

    always @(posedge clk) begin
        if (dmem_we)
            dmem[dmem_addr[9:2]] <= dmem_wd;
    end

    initial begin
        clk = 0;
        rst = 1;

        for (i = 0; i < 256; i = i + 1) begin
            imem[i] = 32'h00000013;   // nop
            dmem[i] = 32'd0;
        end

        imem[0] = 32'h00500093; // addi x1, x0, 5
        imem[1] = 32'h00A00113; // addi x2, x0, 10
        imem[2] = 32'h002081B3; // add  x3, x1, x2
        imem[3] = 32'h00302023; // sw   x3, 0(x0)
        imem[4] = 32'h00002203; // lw   x4, 0(x0)
        imem[5] = 32'h001202B3; // add  x5, x4, x1
        imem[6] = 32'h00000013; // nop

        #12 rst = 0;

        #150;

        $stop;
    end

endmodule
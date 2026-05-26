module imem(
    input  [31:0] pc,
    output [31:0] instr
);

    reg [31:0] mem [0:1023];
    assign instr = mem[pc[11:2]];

endmodule

module dmem(
    input clk,
    input we,
    input [31:0] addr,
    input [31:0] wd,
    output [31:0] rd
);

    reg [31:0] mem [0:1023];

    always @(posedge clk) begin
        if (we)
            mem[addr[11:2]] <= wd;
    end

    assign rd = mem[addr[11:2]];

endmodule

module pc(
    input clk, rst,
    input [31:0] next_pc,
    output reg [31:0] pc
);

    always @(posedge clk or posedge rst)
        if (rst) pc <= 32'b0;
        else pc <= next_pc;

endmodule

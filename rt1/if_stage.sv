

module IF_stage(
    input logic clk,
    input logic [31:0]pc,
    output logic [31:0]IF_instr
);

imem imem_u(
    .clk(clk),
    .a(pc),
    .en(1),
    .rd(IF_instr)
);

endmodule
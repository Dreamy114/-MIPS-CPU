

module IF_stage(
    input logic clk,
    input logic [31:0]pc,
    output logic [31:0]IF_instr,
    output logic IF_ready_go
);

assign IF_ready_go  = 1'b1;

imem imem_u(
    .clk(clk),
    .a(pc),
    .en(1),
    .rd(IF_instr)
);

endmodule
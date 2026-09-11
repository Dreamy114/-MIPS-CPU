

module IF_stage(
    input logic clk,
    input logic [31:0]pc,
    input logic [31:0]inst_rdata,
    output logic [31:0]IF_instr,
    output logic IF_ready_go
);

assign IF_ready_go  = 1'b1;

assign IF_instr = inst_rdata;

endmodule
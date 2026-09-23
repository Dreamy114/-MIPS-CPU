

module IF_stage(
    input wire clk,
    input wire [31:0]pc,
    input wire [31:0]inst_rdata,
    output wire [31:0]IF_instr,
    output wire IF_ready_go
);

assign IF_ready_go  = 1'b1;

assign IF_instr = inst_rdata;

endmodule
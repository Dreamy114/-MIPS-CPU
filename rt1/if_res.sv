

module IF_res(
    input logic clk,
    input logic rst,
    input logic [31:0]IF_pc_i,
    input logic [31:0]IF_pc_plus_8_i,
    input logic pre_IF_ready_go,

    output logic [31:0]IF_pc_o,
    output logic [31:0]IF_pc_plus_8_o
);

logic IF_res_en;

assign IF_res_en = pre_IF_ready_go;

pipeline_reg IF_ff_pc(
    .clk(clk),
    .rst(rst),
    .en(IF_res_en),
    .d_i(IF_pc_i),
    .q_o(IF_pc_o)
);

pipeline_reg IF_ff_pc_plus_8(
    .clk(clk),
    .rst(rst),
    .en(IF_res_en),
    .d_i(IF_pc_plus_8_i),
    .q_o(IF_pc_plus_8_o)
);

endmodule
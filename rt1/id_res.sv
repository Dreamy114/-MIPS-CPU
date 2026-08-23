

module ID_res(
    input logic clk,
    input logic rst,
    input logic [31:0]IF_pc_plus_8_i,
    input logic [31:0]IF_instr_i,
    input logic IF_ready_go,

    output logic [31:0]IF_pc_plus_8_o,
    output logic [31:0]IF_instr_o
);

logic ID_res_en;

assign ID_res_en = IF_ready_go;

pipeline_reg ID_ff_pc_plus_8(
    .clk(clk),
    .rst(rst),
    .en(ID_res_en),
    .d_i(IF_pc_plus_8_i),
    .q_o(IF_pc_plus_8_o)
);

pipeline_reg ID_instr(
    .clk(clk),
    .rst(rst),
    .en(ID_res_en),
    .d_i(IF_instr_i),
    .q_o(IF_instr_o)
);

endmodule
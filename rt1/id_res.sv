

module ID_res(
    input logic clk,
    input logic rst,
    input logic [31:0]IF_pc_plus_4_i,
    input logic [31:0]IF_pc_plus_8_i,
    input logic [31:0]IF_instr_i,
    input logic IF_ready_go,
    input logic Stall,
    input logic [1:0]ID_sel_next_pc,//用来判断flush

    output logic [31:0]IF_pc_plus_4_o,
    output logic [31:0]IF_pc_plus_8_o,
    output logic [31:0]IF_instr_o
);

logic ID_res_en,Flush;

assign ID_res_en = IF_ready_go && !Stall;
assign Flush=(ID_sel_next_pc != 2'b00);

pipeline_reg ID_ff_pc_plus_8(
    .clk(clk),
    .rst(rst),
    .en(ID_res_en),
    .d_i(IF_pc_plus_8_i),
    .q_o(IF_pc_plus_8_o)
);

pipeline_reg ID_ff_pc_plus_4(
    .clk(clk),
    .rst(rst),
    .en(ID_res_en),
    .d_i(IF_pc_plus_4_i),
    .q_o(IF_pc_plus_4_o)
);

pipeline_reg ID_instr(
    .clk(clk),
    .rst(rst),
    .en(ID_res_en),
    .d_i(Flush? 32'h00000000:IF_instr_i),
    .q_o(IF_instr_o)
);

endmodule
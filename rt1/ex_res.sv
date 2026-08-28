

module EX_res(
    input logic clk,
    input logic rst,
    input logic [31:0]ID_instr_i,
    input logic [31:0]ID_imm_i,
    input logic [4:0]ID_shamt_i,
    input logic [4:0]ID_reg_write_addr_i,
    input logic ID_RegWrite_i,
    input logic [1:0]ID_ALUSrc_i,
    input logic [1:0]ID_MemtoReg_i,
    input logic ID_MemWrite_i,
    input logic ID_MemRead_i,
    input logic [3:0]ID_alu_control_i,
    input logic [31:0] ID_reg_read_data1_i,
    input logic [31:0] ID_reg_read_data2_i,
    input logic [31:0]ID_pc_plus_8_i,
    input logic [4:0] ID_rs_i,
    input logic [4:0] ID_rt_i,
    input logic ID_ready_go,
    input logic Stall,

    output logic [31:0]ID_instr_o,
    output logic [31:0]ID_imm_o,
    output logic [4:0]ID_shamt_o,
    output logic [4:0]ID_reg_write_addr_o,
    output logic ID_RegWrite_o,
    output logic [1:0]ID_ALUSrc_o,
    output logic [1:0]ID_MemtoReg_o,
    output logic ID_MemWrite_o,
    output logic ID_MemRead_o,
    output logic [3:0]ID_alu_control_o,
    output logic [31:0] ID_reg_read_data1_o,
    output logic [31:0] ID_reg_read_data2_o,
    output logic [31:0]ID_pc_plus_8_o,
    output logic [4:0] ID_rs_o,
    output logic [4:0] ID_rt_o
);

logic EX_res_en;

assign EX_res_en = ID_ready_go;

pipeline_reg EX_ff_ID_instr(
    .clk(clk),
    .rst(rst),
    .en(EX_res_en),
    .d_i(ID_instr_i),
    .q_o(ID_instr_o)
);

pipeline_reg EX_ff_ID_imm(
    .clk(clk),
    .rst(rst),
    .en(EX_res_en),
    .d_i(ID_imm_i),
    .q_o(ID_imm_o)
);

pipeline_reg #(.Width(5))EX_ff_ID_shamt(
    .clk(clk),
    .rst(rst),
    .en(EX_res_en),
    .d_i(ID_shamt_i),
    .q_o(ID_shamt_o)
);

pipeline_reg #(.Width(5))EX_ff_ID_reg_write_addr(
    .clk(clk),
    .rst(rst),
    .en(EX_res_en),
    .d_i(ID_reg_write_addr_i),
    .q_o(ID_reg_write_addr_o)
);

pipeline_reg #(.Width(1))EX_ff_ID_RegWrite(
    .clk(clk),
    .rst(rst),
    .en(EX_res_en),
    .d_i(Stall ? 1'b0:ID_RegWrite_i),
    .q_o(ID_RegWrite_o)
);

pipeline_reg #(.Width(2))EX_ff_ID_ALUSrc(
    .clk(clk),
    .rst(rst),
    .en(EX_res_en),
    .d_i(Stall ? 2'b00 : ID_ALUSrc_i),
    .q_o(ID_ALUSrc_o)
);

pipeline_reg #(.Width(2))EX_ff_ID_MemtoReg(
    .clk(clk),
    .rst(rst),
    .en(EX_res_en),
    .d_i(Stall ? 2'b00 : ID_MemtoReg_i),
    .q_o(ID_MemtoReg_o)
);

pipeline_reg #(.Width(1))EX_ff_ID_MemWrite(
    .clk(clk),
    .rst(rst),
    .en(EX_res_en),
    .d_i(Stall ? 1'b0:ID_MemWrite_i),
    .q_o(ID_MemWrite_o)
);

pipeline_reg #(.Width(1))EX_ff_ID_MemRead(
    .clk(clk),
    .rst(rst),
    .en(EX_res_en),
    .d_i(Stall ? 1'b0:ID_MemRead_i),
    .q_o(ID_MemRead_o)
);

pipeline_reg #(.Width(4))EX_ff_ID_alu_control(
    .clk(clk),
    .rst(rst),
    .en(EX_res_en),
    .d_i(Stall ? 4'b0000 : ID_alu_control_i),
    .q_o(ID_alu_control_o)
);

pipeline_reg EX_ff_ID_reg_read_data1(
    .clk(clk),
    .rst(rst),
    .en(EX_res_en),
    .d_i(ID_reg_read_data1_i),
    .q_o(ID_reg_read_data1_o)
);

pipeline_reg EX_ff_ID_reg_read_data2(
    .clk(clk),
    .rst(rst),
    .en(EX_res_en),
    .d_i(ID_reg_read_data2_i),
    .q_o(ID_reg_read_data2_o)
);

pipeline_reg EX_ff_ID_pc_plus_8(
    .clk(clk),
    .rst(rst),
    .en(EX_res_en),
    .d_i(ID_pc_plus_8_i),
    .q_o(ID_pc_plus_8_o)
);

pipeline_reg #(.Width(5))EX_ff_ID_rs(
    .clk(clk),
    .rst(rst),
    .en(EX_res_en),
    .d_i(ID_rs_i),
    .q_o(ID_rs_o)
);

pipeline_reg #(.Width(5))EX_ff_ID_rt(
    .clk(clk),
    .rst(rst),
    .en(EX_res_en),
    .d_i(ID_rt_i),
    .q_o(ID_rt_o)
);

endmodule
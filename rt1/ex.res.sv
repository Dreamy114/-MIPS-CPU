

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
    input logic [3:0]ID_alu_control_i,
    input logic [31:0] ID_reg_read_data1_i,
    input logic [31:0] ID_reg_read_data2_i,
    input logic [31:0]ID_pc_plus_8_i,
    output logic [31:0]ID_instr_o,
    output logic [31:0]ID_imm_o,
    output logic [4:0]ID_shamt_o,
    output logic [4:0]ID_reg_write_addr_o,
    output logic ID_RegWrite_o,
    output logic [1:0]ID_ALUSrc_o,
    output logic [1:0]ID_MemtoReg_o,
    output logic ID_MemWrite_o,
    output logic [3:0]ID_alu_control_o,
    output logic [31:0] ID_reg_read_data1_o,
    output logic [31:0] ID_reg_read_data2_o,
    output logic [31:0]ID_pc_plus_8_o
);

flip_flop EX_ff_ID_instr(
    .clk(clk),
    .rst(rst),
    .d_i(ID_instr_i),
    .q_o(ID_instr_o)
);

flip_flop EX_ff_ID_imm(
    .clk(clk),
    .rst(rst),
    .d_i(ID_imm_i),
    .q_o(ID_imm_o)
);

flip_flop #(.Width(5))EX_ff_ID_shamt(
    .clk(clk),
    .rst(rst),
    .d_i(ID_shamt_i),
    .q_o(ID_shamt_o)
);

flip_flop #(.Width(5))EX_ff_ID_reg_write_addr(
    .clk(clk),
    .rst(rst),
    .d_i(ID_reg_write_addr_i),
    .q_o(ID_reg_write_addr_o)
);

flip_flop #(.Width(1))EX_ff_ID_RegWrite(
    .clk(clk),
    .rst(rst),
    .d_i(ID_RegWrite_i),
    .q_o(ID_RegWrite_o)
);

flip_flop #(.Width(2))EX_ff_ID_ALUSrc(
    .clk(clk),
    .rst(rst),
    .d_i(ID_ALUSrc_i),
    .q_o(ID_ALUSrc_o)
);

flip_flop #(.Width(2))EX_ff_ID_MemtoReg(
    .clk(clk),
    .rst(rst),
    .d_i(ID_MemtoReg_i),
    .q_o(ID_MemtoReg_o)
);

flip_flop #(.Width(1))EX_ff_ID_MemWrite(
    .clk(clk),
    .rst(rst),
    .d_i(ID_MemWrite_i),
    .q_o(ID_MemWrite_o)
);


flip_flop #(.Width(4))EX_ff_ID_alu_control(
    .clk(clk),
    .rst(rst),
    .d_i(ID_alu_control_i),
    .q_o(ID_alu_control_o)
);

flip_flop EX_ff_ID_reg_read_data1(
    .clk(clk),
    .rst(rst),
    .d_i(ID_reg_read_data1_i),
    .q_o(ID_reg_read_data1_o)
);

flip_flop EX_ff_ID_reg_read_data2(
    .clk(clk),
    .rst(rst),
    .d_i(ID_reg_read_data2_i),
    .q_o(ID_reg_read_data2_o)
);

flip_flop EX_ff_ID_pc_plus_8(
    .clk(clk),
    .rst(rst),
    .d_i(ID_pc_plus_8_i),
    .q_o(ID_pc_plus_8_o)
);

endmodule
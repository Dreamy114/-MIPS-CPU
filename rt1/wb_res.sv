

module WB_res(
    input logic clk,
    input logic rst,
    input logic [31:0]MEM_instr_i,
    input logic [4:0]MEM_reg_write_addr_i,
    input logic MEM_RegWrite_i,
    input logic [1:0]MEM_MemtoReg_i,
    input logic [31:0]MEM_pc_plus_8_i,
    input logic [31:0]MEM_alu_result_i,
    input logic [31:0]MEM_mem_read_data_i,
    output logic [31:0]MEM_instr_o,
    output logic [4:0]WB_reg_write_addr_o,
    output logic WB_RegWrite_o,
    output logic [1:0]MEM_MemtoReg_o,
    output logic [31:0]MEM_pc_plus_8_o,
    output logic [31:0]MEM_alu_result_o,
    output logic [31:0]MEM_mem_read_data_o
);

flip_flop WB_MEM_instr(
    .clk(clk),
    .rst(rst),
    .d_i(MEM_instr_i),
    .q_o(MEM_instr_o)
);

flip_flop #(.Width(5))WB_MEM_reg_write_addr(
    .clk(clk),
    .rst(rst),
    .d_i(MEM_reg_write_addr_i),
    .q_o(WB_reg_write_addr_o)
);

flip_flop #(.Width(1))WB_RegWrite(
    .clk(clk),
    .rst(rst),
    .d_i(MEM_RegWrite_i),
    .q_o(WB_RegWrite_o)
);

flip_flop #(.Width(2))WB_MEM_MemtoReg(
    .clk(clk),
    .rst(rst),
    .d_i(MEM_MemtoReg_i),
    .q_o(MEM_MemtoReg_o)
);

flip_flop WB_MEM_pc_plus_8(
    .clk(clk),
    .rst(rst),
    .d_i(MEM_pc_plus_8_i),
    .q_o(MEM_pc_plus_8_o)
);

flip_flop WB_MEM_alu_result(
    .clk(clk),
    .rst(rst),
    .d_i(MEM_alu_result_i),
    .q_o(MEM_alu_result_o)
);

flip_flop WB_MEM_mem_read_data(
    .clk(clk),
    .rst(rst),
    .d_i(MEM_mem_read_data_i),
    .q_o(MEM_mem_read_data_o)
);

endmodule
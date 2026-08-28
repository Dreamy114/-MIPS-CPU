

module MEM_res(
    input logic clk,
    input logic rst,
    input logic [31:0]EX_instr_i,
    input logic [4:0]EX_reg_write_addr_i,
    input logic EX_RegWrite_i,
    input logic [1:0]EX_MemtoReg_i,
    input logic EX_MemWrite_i,
    input logic EX_MemRead_i,
    input logic [31:0]EX_pc_plus_8_i,
    input logic [31:0]EX_alu_result_i,
    input logic [31:0]EX_mem_addr_i,
    input logic [31:0]EX_reg_read_data2_i,
    input logic EX_ready_go,
    
    output logic [31:0]EX_instr_o,
    output logic [4:0]EX_reg_write_addr_o,
    output logic EX_RegWrite_o,
    output logic [1:0]EX_MemtoReg_o,
    output logic EX_MemWrite_o,
    output logic EX_MemRead_o,
    output logic [31:0]EX_pc_plus_8_o,
    output logic [31:0]EX_alu_result_o,
    output logic [31:0]EX_mem_addr_o,
    output logic [31:0]EX_reg_read_data2_o
);

logic MEM_res_en;

assign MEM_res_en = EX_ready_go;

pipeline_reg MEM_EX_instr(
    .clk(clk),
    .rst(rst),
    .en(MEM_res_en),
    .d_i(EX_instr_i),
    .q_o(EX_instr_o)
);

pipeline_reg #(.Width(5))MEM_EX_reg_write_addr(
    .clk(clk),
    .rst(rst),
    .en(MEM_res_en),
    .d_i(EX_reg_write_addr_i),
    .q_o(EX_reg_write_addr_o)
);

pipeline_reg #(.Width(1))MEM_EX_RegWrite(
    .clk(clk),
    .rst(rst),
    .en(MEM_res_en),
    .d_i(EX_RegWrite_i),
    .q_o(EX_RegWrite_o)
);

pipeline_reg #(.Width(2))MEM_EX_MemtoReg(
    .clk(clk),
    .rst(rst),
    .en(MEM_res_en),
    .d_i(EX_MemtoReg_i),
    .q_o(EX_MemtoReg_o)
);

pipeline_reg #(.Width(1))MEM_EX_MemWrite(
    .clk(clk),
    .rst(rst),
    .en(MEM_res_en),
    .d_i(EX_MemWrite_i),
    .q_o(EX_MemWrite_o)
);

pipeline_reg #(.Width(1))MEM_EX_MemRead(
    .clk(clk),
    .rst(rst),
    .en(MEM_res_en),
    .d_i(EX_MemRead_i),
    .q_o(EX_MemRead_o)
);

pipeline_reg MEM_EX_pc_plus_8(
    .clk(clk),
    .rst(rst),
    .en(MEM_res_en),
    .d_i(EX_pc_plus_8_i),
    .q_o(EX_pc_plus_8_o)
);

pipeline_reg MEM_EX_alu_result(
    .clk(clk),
    .rst(rst),
    .en(MEM_res_en),
    .d_i(EX_alu_result_i),
    .q_o(EX_alu_result_o)
);

pipeline_reg MEM_EX_mem_addr(
    .clk(clk),
    .rst(rst),
    .en(MEM_res_en),
    .d_i(EX_mem_addr_i),
    .q_o(EX_mem_addr_o)
);

pipeline_reg MEM_EX_reg_read_data(
    .clk(clk),
    .rst(rst),
    .en(MEM_res_en),
    .d_i(EX_reg_read_data2_i),
    .q_o(EX_reg_read_data2_o)
);


endmodule


module WB_res(
    input wire clk,
    input wire rst,
    input wire [31:0]MEM_instr_i,
    input wire [4:0]MEM_reg_write_addr_i,
    input wire MEM_RegWrite_i,
    input wire [1:0]MEM_MemtoReg_i,
    input wire [31:0]MEM_pc_plus_8_i,
    input wire [31:0]MEM_alu_result_i,
    input wire [31:0]MEM_mem_read_data_i,
    input wire MEM_ready_go,
    
    output wire [31:0]MEM_instr_o,
    output wire [4:0]WB_reg_write_addr_o,
    output wire WB_RegWrite_o,
    output wire [1:0]MEM_MemtoReg_o,
    output wire [31:0]MEM_pc_plus_8_o,
    output wire [31:0]MEM_alu_result_o,
    output wire [31:0]MEM_mem_read_data_o
);
wire WB_res_en;

assign WB_res_en = MEM_ready_go;

pipeline_reg WB_MEM_instr(
    .clk(clk),
    .rst(rst),
    .en(WB_res_en),
    .d_i(MEM_instr_i),
    .q_o(MEM_instr_o)
);

pipeline_reg #(.Width(5))WB_MEM_reg_write_addr(
    .clk(clk),
    .rst(rst),
    .en(WB_res_en),
    .d_i(MEM_reg_write_addr_i),
    .q_o(WB_reg_write_addr_o)
);

pipeline_reg #(.Width(1))WB_RegWrite(
    .clk(clk),
    .rst(rst),
    .en(WB_res_en),
    .d_i(MEM_RegWrite_i),
    .q_o(WB_RegWrite_o)
);

pipeline_reg #(.Width(2))WB_MEM_MemtoReg(
    .clk(clk),
    .rst(rst),
    .en(WB_res_en),
    .d_i(MEM_MemtoReg_i),
    .q_o(MEM_MemtoReg_o)
);

pipeline_reg WB_MEM_pc_plus_8(
    .clk(clk),
    .rst(rst),
    .en(WB_res_en),
    .d_i(MEM_pc_plus_8_i),
    .q_o(MEM_pc_plus_8_o)
);

pipeline_reg WB_MEM_alu_result(
    .clk(clk),
    .rst(rst),
    .en(WB_res_en),
    .d_i(MEM_alu_result_i),
    .q_o(MEM_alu_result_o)
);

pipeline_reg WB_MEM_mem_read_data(
    .clk(clk),
    .rst(rst),
    .en(WB_res_en),
    .d_i(MEM_mem_read_data_i),
    .q_o(MEM_mem_read_data_o)
);

endmodule
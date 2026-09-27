

module WB_stage(
    input wire [31:0]MEM_instr,
    input wire [31:0]MEM_alu_result,
    input wire [31:0]MEM_pc_plus_8,
    input wire [31:0]MEM_mem_read_data,
    input wire [1:0]MEM_MemtoReg,
    output wire [31:0]WB_reg_write_data,
    output wire WB_ready_go
);

assign WB_ready_go  = 1'b1;

mux4 reg_write_data_mux(
.data0(MEM_alu_result),
.data1(MEM_mem_read_data),
.data2(MEM_pc_plus_8),
.data3({MEM_instr[15:0],16'b0}),
.sel(MEM_MemtoReg),
.result(WB_reg_write_data)
);

endmodule


module ID_stage(
    input logic clk,
    input logic rst,
    input logic [31:0]IF_instr,
    input logic WB_RegWrite,
    input logic [4:0]WB_reg_write_addr,
    input logic [31:0]WB_reg_write_data,
    input logic [1:0]BranchForwardA,
    input logic [1:0]BranchForwardB,
    input logic [31:0]MEM_alu_result,
    input logic [31:0]EX_alu_result,

    output logic [31:0]ID_imm,
    output logic [4:0]ID_shamt,
    output logic [4:0]ID_reg_write_addr,
    output logic ID_RegWrite,
    output logic [1:0]ID_ALUSrc,
    output logic [1:0]ID_MemtoReg,
    output logic ID_MemWrite,
    output logic ID_MemRead,
    output logic [1:0]ID_sel_next_pc,
    output logic [3:0]ID_alu_control,
    output logic [31:0] forward_a_src,
    output logic [31:0] forward_b_src,
    output logic [4:0] ID_rs,
    output logic [4:0] ID_rt,
    output logic ID_ready_go,
    output logic ID_rsUsed,
    output logic ID_rtUsed
);

logic [1:0]RegDst;
logic [31:0] reg_read_data1;
logic [31:0] reg_read_data2;
logic Zero;

assign ID_ready_go  = 1'b1;

assign ID_shamt = IF_instr[10:6];
assign ID_rs = IF_instr[25:21];
assign ID_rt = IF_instr[20:16];

reg_file regfile(
.clk(clk),
.rst(rst),
.we(WB_RegWrite),
.wa(WB_reg_write_addr),
.wd(WB_reg_write_data),
.ra1(IF_instr[25:21]),
.ra2(IF_instr[20:16]),
.rd1(reg_read_data1),
.rd2(reg_read_data2)
);

mux4 #(.Width(5)) reg_write_addr_mux(
.data0(IF_instr[20:16]),
.data1(IF_instr[15:11]),
.data2(5'd31),
.data3(5'b0),
.sel(RegDst),
.result(ID_reg_write_addr)
);


sign_ext sign_ext_u(
.imm16(IF_instr[15:0]),
.imm32(ID_imm)
);

//branch判断
assign Zero = (forward_a_src == forward_b_src);

mux4 forward_a_src_mux(
    .data0(reg_read_data1),
    .data1(EX_alu_result),
    .data2(MEM_alu_result),
    .data3(WB_reg_write_data),
    .sel(BranchForwardA),
    .result(forward_a_src)
);

mux4 forward_b_src_mux(
    .data0(reg_read_data2),
    .data1(EX_alu_result),
    .data2(MEM_alu_result),
    .data3(WB_reg_write_data),
    .sel(BranchForwardB),
    .result(forward_b_src)
);

control_unit control_unit_u(
.op(IF_instr[31:26]),
.shamt(IF_instr[10:6]),
.funct(IF_instr[5:0]),
.Zero(Zero),
.RegWrite(ID_RegWrite),
.RegDst(RegDst),
.ALUSrc(ID_ALUSrc),
.MemtoReg(ID_MemtoReg),
.MemWrite(ID_MemWrite),
.MemRead(ID_MemRead),
.sel_next_pc(ID_sel_next_pc),
.alu_control(ID_alu_control),
.rsUsed(ID_rsUsed),
.rtUsed(ID_rtUsed)
);

endmodule
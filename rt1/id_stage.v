

module ID_stage(
    input wire clk,
    input wire rst,
    input wire [31:0]IF_instr,
    input wire WB_RegWrite,
    input wire [4:0]WB_reg_write_addr,
    input wire [31:0]WB_reg_write_data,
    input wire [1:0]BranchForwardA,
    input wire [1:0]BranchForwardB,
    input wire [31:0]MEM_alu_result,
    input wire [31:0]EX_alu_result,

    output wire [31:0]ID_imm,
    output wire [4:0]ID_shamt,
    output wire [4:0]ID_reg_write_addr,
    output wire ID_RegWrite,
    output wire [1:0]ID_ALUSrc,
    output wire [1:0]ID_MemtoReg,
    output wire ID_MemWrite,
    output wire ID_MemRead,
    output wire [1:0]ID_sel_next_pc,
    output wire [3:0]ID_alu_control,
    output wire [31:0] forward_a_src,
    output wire [31:0] forward_b_src,
    output wire [4:0] ID_rs,
    output wire [4:0] ID_rt,
    output wire ID_ready_go,
    output wire ID_rsUsed,
    output wire ID_rtUsed
);

wire [1:0]RegDst;
wire [31:0] reg_read_data1;
wire [31:0] reg_read_data2;
wire Zero;
wire [31:0]sign_ext_imm;
wire [31:0]zero_ext_imm;
wire sel_imm;

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

//imm扩展+判断

sign_ext sign_ext_u(
.imm16(IF_instr[15:0]),
.imm32(sign_ext_imm)
);

zero_ext zero_ext_u(
    .imm16(IF_instr[15:0]),
    .imm32(zero_ext_imm)
);

mux2 imm_mux(
    .data0(sign_ext_imm),
    .data1(zero_ext_imm),
    .sel(sel_imm),
    .result(ID_imm)
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
.rtUsed(ID_rtUsed),
.sel_imm(sel_imm)
);

endmodule
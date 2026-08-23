

module ID_stage(
    input logic clk,
    input logic rst,
    input logic [31:0]IF_instr,
    input logic WB_RegWrite,
    input logic [4:0]WB_reg_write_addr,
    input logic [31:0]WB_reg_write_data,
    input logic EX_Zero,
    output logic [31:0]ID_imm,
    output logic [4:0]ID_shamt,
    output logic [4:0]ID_reg_write_addr,
    output logic ID_RegWrite,
    output logic [1:0]ID_ALUSrc,
    output logic [1:0]ID_MemtoReg,
    output logic ID_MemWrite,
    output logic [1:0]ID_sel_next_pc,
    output logic [3:0]ID_alu_control,
    output logic [31:0] ID_reg_read_data1,
    output logic [31:0] ID_reg_read_data2,
    output logic [4:0] ID_rs,
    output logic [4:0] ID_rt,
    output logic ID_ready_go
);

logic [1:0]RegDst;

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
.rd1(ID_reg_read_data1),
.rd2(ID_reg_read_data2)
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

control_unit control_unit_u(
.op(IF_instr[31:26]),
.shamt(IF_instr[10:6]),
.funct(IF_instr[5:0]),
.Zero(EX_Zero),
.RegWrite(ID_RegWrite),
.RegDst(RegDst),
.ALUSrc(ID_ALUSrc),
.MemtoReg(ID_MemtoReg),
.MemWrite(ID_MemWrite),
.sel_next_pc(ID_sel_next_pc),
.alu_control(ID_alu_control)
);

endmodule


module cpu(
    input logic clk,
    input logic rst
);

logic        pre_IF_ready_go;


logic [31:0] IF_pc;
logic [31:0] pIF_pc;
logic [31:0] pIF_pc_plus_4;
logic [31:0] pIF_pc_plus_8;

logic [31:0] IF_instr;
logic [31:0] IF_pc_plus_4;
logic [31:0] IF_pc_plus_8;
logic        IF_ready_go;

logic [31:0] ID_instr;
logic [31:0] ID_pc_plus_4;
logic [31:0] ID_pc_plus_8;
logic [31:0] ID_imm;
logic [4:0]  ID_shamt;
logic [4:0]  ID_reg_write_addr;
logic        ID_RegWrite;
logic [1:0]  ID_ALUSrc;
logic [1:0]  ID_MemtoReg;
logic        ID_MemWrite;
logic        ID_MemRead;
logic [1:0]  sel_next_pc;
logic [3:0]  ID_alu_control;
logic [31:0] ID_reg_read_data1;
logic [31:0] ID_reg_read_data2;
logic [4:0]  ID_rs;
logic [4:0]  ID_rt;
logic        ID_ready_go;
logic        ID_rsUsed;
logic        ID_rtUsed;

logic [1:0]  ForwardA;
logic [1:0]  ForwardB;

logic [1:0]  BranchForwardA;
logic [1:0]  BranchForwardB;

logic [31:0] EX_instr;
logic [31:0] EX_imm;
logic [4:0]  EX_shamt;
logic [4:0]  EX_reg_write_addr;
logic        EX_RegWrite;
logic [1:0]  EX_ALUSrc;
logic [1:0]  EX_MemtoReg;
logic        EX_MemWrite;
logic [3:0]  EX_alu_control;
logic [31:0] EX_reg_read_data1;
logic [31:0] EX_reg_read_data2;
logic [31:0] EX_pc_plus_8;

logic [4:0]  EX_rs;
logic [4:0]  EX_rt;

logic        EX_Zero;
logic [31:0] EX_alu_result;
logic [31:0] EX_mem_addr;
logic        EX_ready_go;
logic        EX_MemRead;


logic [31:0] MEM_instr;
logic [4:0]  MEM_reg_write_addr;
logic        MEM_RegWrite;
logic [1:0]  MEM_MemtoReg;
logic        MEM_MemWrite;
logic [31:0] MEM_pc_plus_8;
logic [31:0] MEM_alu_result;
logic [31:0] MEM_mem_addr;
logic [31:0] MEM_reg_read_data2;
logic [31:0] MEM_mem_read_data;
logic        MEM_ready_go;

logic [31:0] WB_instr;
logic [4:0]  WB_reg_write_addr;
logic        WB_RegWrite;
logic [1:0]  WB_MemtoReg;
logic [31:0] WB_pc_plus_8;
logic [31:0] WB_alu_result;
logic [31:0] WB_mem_read_data;
logic [31:0] WB_reg_write_data;
logic        WB_ready_go;

logic        Stall;

pre_IF_stage pre_IF(
    .pc_i(IF_pc),
    .instr(ID_instr),
    .ID_sel_next_pc(sel_next_pc), 
    .ID_imm(ID_imm),
    .ID_reg_read_data1(ID_reg_read_data1),
    .ID_pc_plus_4(ID_pc_plus_4),

    .IF_pc_o(pIF_pc),
    .IF_pc_plus_4(pIF_pc_plus_4),
    .IF_pc_plus_8(pIF_pc_plus_8),
    .pre_IF_ready_go(pre_IF_ready_go)
);

IF_res if_res(
    .clk(clk),
    .rst(rst),
    .IF_pc_i(pIF_pc),
    .IF_pc_plus_4_i(pIF_pc_plus_4),
    .IF_pc_plus_8_i(pIF_pc_plus_8),
    .pre_IF_ready_go(pre_IF_ready_go),
    .Stall(Stall),

    .IF_pc_o(IF_pc),
    .IF_pc_plus_4_o(IF_pc_plus_4),
    .IF_pc_plus_8_o(IF_pc_plus_8)
);

IF_stage IF(
    .clk(clk),
    .pc(IF_pc),
    .IF_instr(IF_instr),
    .IF_ready_go(IF_ready_go)
);

ID_res id_res(
    .clk(clk),
    .rst(rst),
    .IF_pc_plus_4_i(IF_pc_plus_4),
    .IF_pc_plus_8_i(IF_pc_plus_8),
    .IF_instr_i(IF_instr),
    .IF_ready_go(IF_ready_go),
    .Stall(Stall),
    .ID_sel_next_pc(sel_next_pc),//判断flush
    
    .IF_pc_plus_4_o(ID_pc_plus_4),
    .IF_pc_plus_8_o(ID_pc_plus_8),
    .IF_instr_o(ID_instr)
);

ID_stage ID(
    .clk(clk),
    .rst(rst),
    .IF_instr(ID_instr),
    .WB_RegWrite(WB_RegWrite),
    .WB_reg_write_addr(WB_reg_write_addr),
    .WB_reg_write_data(WB_reg_write_data),
    .BranchForwardA(BranchForwardA),
    .BranchForwardB(BranchForwardB),
    .MEM_alu_result(MEM_alu_result),
    .EX_alu_result(EX_alu_result),

    .ID_imm(ID_imm),
    .ID_shamt(ID_shamt),
    .ID_reg_write_addr(ID_reg_write_addr),
    .ID_RegWrite(ID_RegWrite),
    .ID_ALUSrc(ID_ALUSrc),
    .ID_MemtoReg(ID_MemtoReg),
    .ID_MemWrite(ID_MemWrite),
    .ID_MemRead(ID_MemRead),
    .ID_sel_next_pc(sel_next_pc),
    .ID_alu_control(ID_alu_control),
    .forward_a_src(ID_reg_read_data1),
    .forward_b_src(ID_reg_read_data2),
    .ID_rs(ID_rs),
    .ID_rt(ID_rt),
    .ID_ready_go(ID_ready_go),
    .ID_rsUsed(ID_rsUsed),
    .ID_rtUsed(ID_rtUsed)
);

branch_forwarding_unit BranchForwarding_unit(
    .rs(ID_rs),
    .rt(ID_rt),
    .EX_rd(EX_reg_write_addr),
    .EX_RegWrite(EX_RegWrite),
    .MEM_rd(MEM_reg_write_addr),
    .MEM_RegWrite(MEM_RegWrite),
    .WB_rd(WB_reg_write_addr),
    .WB_RegWrite(WB_RegWrite),

    .ForwardA(BranchForwardA),
    .ForwardB(BranchForwardB)
);

hazard_detection_unit HDU(
    .EX_MemRead(EX_MemRead),
    .EX_rt(EX_rt),
    .ID_rs(ID_rs),
    .ID_rt(ID_rt),
    .ID_rsUsed(ID_rsUsed),
    .ID_rtUsed(ID_rtUsed),
    .Stall(Stall)
);

EX_res ex_res(
    .clk(clk),
    .rst(rst),
    .ID_instr_i(ID_instr),
    .ID_imm_i(ID_imm),
    .ID_shamt_i(ID_shamt),
    .ID_reg_write_addr_i(ID_reg_write_addr),
    .ID_RegWrite_i(ID_RegWrite),
    .ID_ALUSrc_i(ID_ALUSrc),
    .ID_MemtoReg_i(ID_MemtoReg),
    .ID_MemWrite_i(ID_MemWrite),
    .ID_MemRead_i(ID_MemRead),
    .ID_alu_control_i(ID_alu_control),
    .ID_reg_read_data1_i(ID_reg_read_data1),
    .ID_reg_read_data2_i(ID_reg_read_data2),
    .ID_pc_plus_8_i(ID_pc_plus_8),
    .ID_rs_i(ID_rs),
    .ID_rt_i(ID_rt),
    .ID_ready_go(ID_ready_go),
    .Stall(Stall),

    .ID_instr_o(EX_instr),
    .ID_imm_o(EX_imm),
    .ID_shamt_o(EX_shamt),
    .ID_reg_write_addr_o(EX_reg_write_addr),
    .ID_RegWrite_o(EX_RegWrite),
    .ID_ALUSrc_o(EX_ALUSrc),
    .ID_MemtoReg_o(EX_MemtoReg),
    .ID_MemWrite_o(EX_MemWrite),
    .ID_MemRead_o(EX_MemRead),
    .ID_alu_control_o(EX_alu_control),
    .ID_reg_read_data1_o(EX_reg_read_data1),
    .ID_reg_read_data2_o(EX_reg_read_data2),
    .ID_pc_plus_8_o(EX_pc_plus_8),
    .ID_rs_o(EX_rs),
    .ID_rt_o(EX_rt)
);

forwarding_unit Forwarding_unit(
    .rs(EX_rs),
    .rt(EX_rt),
    .MEM_rd(MEM_reg_write_addr),
    .MEM_RegWrite(MEM_RegWrite),
    .WB_rd(WB_reg_write_addr),
    .WB_RegWrite(WB_RegWrite),

    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);

EX_stage EX(
    .ID_alu_control(EX_alu_control),
    .ID_ALUSrc(EX_ALUSrc),
    .ID_reg_read_data1(EX_reg_read_data1),
    .ID_reg_read_data2(EX_reg_read_data2),
    .ID_shamt(EX_shamt),
    .ID_imm(EX_imm),

    .MEM_alu_result(MEM_alu_result),
    .WB_reg_write_data(WB_reg_write_data),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB),

    .EX_alu_result(EX_alu_result),
    .EX_mem_addr(EX_mem_addr),
    .EX_ready_go(EX_ready_go)
);

MEM_res mem_res(
    .clk(clk),
    .rst(rst),
    .EX_instr_i(EX_instr),
    .EX_reg_write_addr_i(EX_reg_write_addr),
    .EX_RegWrite_i(EX_RegWrite),
    .EX_MemtoReg_i(EX_MemtoReg),
    .EX_MemWrite_i(EX_MemWrite),
    .EX_MemRead_i(EX_MemRead),
    .EX_pc_plus_8_i(EX_pc_plus_8),
    .EX_alu_result_i(EX_alu_result),
    .EX_mem_addr_i(EX_mem_addr),
    .EX_reg_read_data2_i(EX_reg_read_data2),
    .EX_ready_go(EX_ready_go),

    .EX_instr_o(MEM_instr),
    .EX_reg_write_addr_o(MEM_reg_write_addr),
    .EX_RegWrite_o(MEM_RegWrite),
    .EX_MemtoReg_o(MEM_MemtoReg),
    .EX_MemWrite_o(MEM_MemWrite),
    .EX_MemRead_o(MEM_MemRead),
    .EX_pc_plus_8_o(MEM_pc_plus_8),
    .EX_alu_result_o(MEM_alu_result),
    .EX_mem_addr_o(MEM_mem_addr),
    .EX_reg_read_data2_o(MEM_reg_read_data2)

);

MEM_stage MEM(
    .clk(clk),
    .EX_MemWrite(MEM_MemWrite),
    .EX_MemRead(MEM_MemRead),
    .EX_reg_read_data2(MEM_reg_read_data2),
    .EX_mem_addr(MEM_mem_addr),
    .MEM_mem_read_data(MEM_mem_read_data),
    .MEM_ready_go(MEM_ready_go)

);


WB_res wb_res(
    .clk(clk),
    .rst(rst),
    .MEM_instr_i(MEM_instr),
    .MEM_reg_write_addr_i(MEM_reg_write_addr),
    .MEM_RegWrite_i(MEM_RegWrite),
    .MEM_MemtoReg_i(MEM_MemtoReg),
    .MEM_pc_plus_8_i(MEM_pc_plus_8),
    .MEM_alu_result_i(MEM_alu_result),
    .MEM_mem_read_data_i(MEM_mem_read_data),
    .MEM_ready_go(MEM_ready_go),

    .MEM_instr_o(WB_instr),
    .WB_reg_write_addr_o(WB_reg_write_addr),
    .WB_RegWrite_o(WB_RegWrite),
    .MEM_MemtoReg_o(WB_MemtoReg),
    .MEM_pc_plus_8_o(WB_pc_plus_8),
    .MEM_alu_result_o(WB_alu_result),
    .MEM_mem_read_data_o(WB_mem_read_data)
);

WB_stage WB(
    .MEM_instr(WB_instr),
    .MEM_alu_result(WB_alu_result),
    .MEM_pc_plus_8(WB_pc_plus_8),
    .MEM_mem_read_data(WB_mem_read_data),
    .MEM_MemtoReg(WB_MemtoReg),
    .WB_reg_write_data(WB_reg_write_data),
    .WB_ready_go(WB_ready_go)
);

endmodule
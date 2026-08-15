

module mips(
    input logic clk,
    input logic rst,
    input logic [31:0]instr,
    input logic [31:0]mem_read_data,
    output logic [31:0]pc,
    output logic MemWrite,
    output logic [31:0]mem_write_data,
    output logic [31:0]mem_addr
);

logic RegWrite,Zero;
logic [1:0]RegDst,MemtoReg,sel_next_pc,ALUSrc;
logic [3:0]alu_control;

datapath datapath_u(
.clk(clk),
.rst(rst),
.instr(instr),
.RegWrite(RegWrite),
.RegDst(RegDst),
.ALUSrc(ALUSrc),
.alu_control(alu_control),
.MemtoReg(MemtoReg),
.mem_read_data,
.sel_next_pc(sel_next_pc),
.pc_o(pc),
.mem_write_data,
.mem_addr,
.Zero
);

control_unit control_unit_u(
.op(instr[31:26]),
.shamt(instr[10:6]),
.funct(instr[5:0]),
.RegWrite(RegWrite),
.RegDst(RegDst),
.ALUSrc(ALUSrc),
.MemtoReg(MemtoReg),
.MemWrite(MemWrite),
.sel_next_pc(sel_next_pc),
.alu_control(alu_control),
.Zero
);

endmodule
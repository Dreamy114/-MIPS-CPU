

module datapath(
    input logic clk,
    input logic rst,
    input logic [31:0]instr,
    input logic RegWrite,
    input logic [1:0]RegDst,
    input logic [1:0]ALUSrc,
    input logic [3:0]alu_control,
    input logic [1:0]MemtoReg,
    input logic [31:0]mem_read_data,
    input logic [1:0]sel_next_pc,
    output logic [31:0]pc_o,
    output logic [31:0]mem_write_data,
    output logic [31:0]mem_addr,
    output logic Zero
);

logic [31:0]pc_i,pc_plus_4,reg_write_data,reg_read_data1,reg_read_data2,imm,a_src,b_src,alu_result,pc_plus_8;
logic [4:0]reg_write_addr;

//pc

flip_flop pc(
.clk(clk),
.rst(rst),
.d_i(pc_i),
.q_o(pc_o)
);

adder add(
.a(pc_o),
.b(32'd4),
.result(pc_plus_4)
);

adder add_jal(
    .a(pc_plus_4),
    .b(32'd4),
    .result(pc_plus_8)
);


mux4 next_pc(
.data0(pc_plus_4),
.data1(pc_plus_4+{imm[29:0],2'b00}),
.data2({pc_plus_4[31:28],instr[25:0],2'b00}),
.data3(reg_read_data1),
.sel(sel_next_pc),
.result(pc_i)
);

//reg_file

reg_file regfile(
.clk(clk),
.rst(rst),
.we(RegWrite),
.wa(reg_write_addr),
.wd(reg_write_data),
.ra1(instr[25:21]),
.ra2(instr[20:16]),
.rd1(reg_read_data1),
.rd2(reg_read_data2)
);

mux4 #(.Width(5)) reg_write_addr_mux(
.data0(instr[20:16]),
.data1(instr[15:11]),
.data2(31),
.data3(32'b0),
.sel(RegDst),
.result(reg_write_addr)
);

mux4 reg_write_data_mux(
.data0(alu_result),
.data1(mem_read_data),
.data2(pc_plus_8),
.data3({instr[15:0],16'b0}),
.sel(MemtoReg),
.result(reg_write_data)
);

assign mem_write_data = reg_read_data2;

sign_ext sign_ext_u(
.imm16(instr[15:0]),
.imm32(imm)
);

//alu

alu alu_u(
.a(a_src),
.b(b_src),
.alu_control(alu_control),
.result(alu_result),
.mem_addr(mem_addr)   
);

assign Zero = (reg_read_data1==reg_read_data2);  

mux2 a_src_mux(
.data0(reg_read_data1),
.data1({27'b0,instr[10:6]}),
.sel(ALUSrc[0]),
.result(a_src)
);

mux2 b_src_mux(
.data0(reg_read_data2),
.data1(imm),
.sel(ALUSrc[1]),
.result(b_src)
);



endmodule


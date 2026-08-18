

module EX_stage(
    input logic [3:0]ID_alu_control,
    input logic [1:0]ID_ALUSrc,
    input logic [31:0]ID_reg_read_data1,
    input logic [31:0]ID_reg_read_data2,
    input logic [4:0]ID_shamt,
    input logic [31:0]ID_imm,
    output logic EX_Zero,
    output logic [31:0]EX_alu_result,
    output logic [31:0]EX_mem_addr
);

logic [31:0]a_src,b_src;

alu alu_u(
.a(a_src),
.b(b_src),
.alu_control(ID_alu_control),
.result(EX_alu_result),
.mem_addr(EX_mem_addr)
);

assign EX_Zero = (ID_reg_read_data1==ID_reg_read_data2);  

mux2 a_src_mux(
.data0(ID_reg_read_data1),
.data1({27'b0,ID_shamt}),
.sel(ID_ALUSrc[0]),
.result(a_src)
);

mux2 b_src_mux(
.data0(ID_reg_read_data2),
.data1(ID_imm),
.sel(ID_ALUSrc[1]),
.result(b_src)
);

endmodule
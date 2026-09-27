

module EX_stage(
    input wire [3:0]ID_alu_control,
    input wire [1:0]ID_ALUSrc,
    input wire [31:0]ID_reg_read_data1,
    input wire [31:0]ID_reg_read_data2,
    input wire [4:0]ID_shamt,
    input wire [31:0]ID_imm,

    input wire [31:0]MEM_alu_result,
    input wire [31:0]WB_reg_write_data,
    input wire [1:0]ForwardA,
    input wire [1:0]ForwardB,

    output wire [31:0]EX_alu_result,
    output wire [31:0]EX_mem_addr,
    output wire EX_ready_go
);

wire [31:0]a_src,b_src;
wire [31:0]forward_a_src;
wire [31:0]forward_b_src;

assign EX_ready_go  = 1'b1;

alu alu_u(
.a(a_src),
.b(b_src),
.alu_control(ID_alu_control),
.result(EX_alu_result),
.mem_addr(EX_mem_addr)
);


mux4 forward_a_src_mux(
    .data0(ID_reg_read_data1),
    .data1(MEM_alu_result),
    .data2(WB_reg_write_data),
    .data3(),
    .sel(ForwardA),
    .result(forward_a_src)
);

mux4 forward_b_src_mux(
    .data0(ID_reg_read_data2),
    .data1(MEM_alu_result),
    .data2(WB_reg_write_data),
    .data3(),
    .sel(ForwardB),
    .result(forward_b_src)
);

mux2 a_src_mux(
.data0(forward_a_src),
.data1({27'b0,ID_shamt}),
.sel(ID_ALUSrc[0]),
.result(a_src)
);

mux2 b_src_mux(
.data0(forward_b_src),
.data1(ID_imm),
.sel(ID_ALUSrc[1]),
.result(b_src)
);

endmodule
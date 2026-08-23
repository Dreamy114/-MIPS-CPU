

module pre_IF_stage(
    input logic [31:0]pc_i,
    input logic [31:0]instr,
    input logic [1:0]ID_sel_next_pc, 
    input logic [31:0]ID_imm,
    input logic [31:0]ID_reg_read_data1,

    output logic [31:0]IF_pc_o,
    output logic [31:0]IF_pc_plus_8,
    output logic pre_IF_ready_go
);

logic [31:0]pc_plus_4;

assign pre_IF_ready_go = 1'b1;

adder add(
.a(pc_i),
.b(32'd4),
.result(pc_plus_4)
);

adder add_jal(
    .a(pc_plus_4),
    .b(32'd4),
    .result(IF_pc_plus_8)
);

mux4 next_pc(
.data0(pc_plus_4),
.data1(pc_plus_4+{ID_imm[29:0],2'b00}),
.data2({pc_plus_4[31:28],instr[25:0],2'b00}),
.data3(ID_reg_read_data1),
.sel(ID_sel_next_pc),
.result(IF_pc_o)
);

endmodule
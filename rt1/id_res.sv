

module ID_res(
    input logic clk,
    input logic rst,
    input logic [31:0]IF_pc_plus_8_i,
    input logic [31:0]IF_instr_i,
    output logic [31:0]IF_pc_plus_8_o,
    output logic [31:0]IF_instr_o
);


flip_flop ID_ff_pc_plus_8(
    .clk(clk),
    .rst(rst),
    .d_i(IF_pc_plus_8_i),
    .q_o(IF_pc_plus_8_o)
);

flip_flop ID_instr(
    .clk(clk),
    .rst(rst),
    .d_i(IF_instr_i),
    .q_o(IF_instr_o)
);

endmodule


module IF_res(
    input logic clk,
    input logic rst,
    input logic [31:0]IF_pc_i,
    input logic [31:0]IF_pc_plus_8_i,
    output logic [31:0]IF_pc_o,
    output logic [31:0]IF_pc_plus_8_o
);

flip_flop IF_ff_pc(
    .clk(clk),
    .rst(rst),
    .d_i(IF_pc_i),
    .q_o(IF_pc_o)
);

flip_flop IF_ff_pc_plus_8(
    .clk(clk),
    .rst(rst),
    .d_i(IF_pc_plus_8_i),
    .q_o(IF_pc_plus_8_o)
);

endmodule
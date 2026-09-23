

module IF_res(
    input wire clk,
    input wire rst,
    input wire [31:0]IF_pc_i,
    input wire [31:0]IF_pc_plus_4_i,
    input wire [31:0]IF_pc_plus_8_i,
    input wire pre_IF_ready_go,
    input wire Stall,

    output reg [31:0]IF_pc_o,
    output wire [31:0]IF_pc_plus_4_o,
    output wire [31:0]IF_pc_plus_8_o

);

wire IF_res_en;

assign IF_res_en = pre_IF_ready_go && !Stall;

always @(posedge clk) begin
    if (rst)
        IF_pc_o <= 32'h80000000;
    else if (IF_res_en)
        IF_pc_o <= IF_pc_i;
end

pipeline_reg IF_ff_pc_plus_4(
    .clk(clk),
    .rst(rst),
    .en(IF_res_en),
    .d_i(IF_pc_plus_4_i),
    .q_o(IF_pc_plus_4_o)
);

pipeline_reg IF_ff_pc_plus_8(
    .clk(clk),
    .rst(rst),
    .en(IF_res_en),
    .d_i(IF_pc_plus_8_i),
    .q_o(IF_pc_plus_8_o)
);

endmodule
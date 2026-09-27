module IF_res(
    input wire clk,
    input wire rst,
    input wire [31:0]IF_pc_i,
    input wire [31:0]IF_pc_plus_4_i,
    input wire [31:0]IF_pc_plus_8_i,
    input wire pre_IF_ready_go,
    input wire Stall,

    output reg [31:0]IF_pc_o,
    output reg [31:0]IF_pc_plus_4_o,
    output reg [31:0]IF_pc_plus_8_o
);

wire IF_res_en;

assign IF_res_en = pre_IF_ready_go && !Stall;

always @(posedge clk) begin
    if (rst) begin
        IF_pc_o        <= 32'h80000000;
        IF_pc_plus_4_o <= 32'h80000004;
        IF_pc_plus_8_o <= 32'h80000008;
    end
    else if (IF_res_en) begin
        IF_pc_o        <= IF_pc_i;
        IF_pc_plus_4_o <= IF_pc_plus_4_i;
        IF_pc_plus_8_o <= IF_pc_plus_8_i;
    end
end

endmodule
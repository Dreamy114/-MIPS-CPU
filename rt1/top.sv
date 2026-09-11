module top(
    input logic clk,
    input logic rst
);

logic [31:0] inst_addr;
logic [31:0] inst_rdata;

logic [31:0] data_addr;
logic [31:0] data_wdata;
logic [31:0] data_rdata;
logic data_we;
logic data_en;

cpu cpu_u(
    .clk(clk),
    .rst(rst),

    .inst_addr(inst_addr),
    .inst_rdata(inst_rdata),

    .data_addr(data_addr),
    .data_wdata(data_wdata),
    .data_rdata(data_rdata),
    .data_we(data_we),
    .data_en(data_en)
);

imem imem_u(
    .clk(clk),
    .a(inst_addr),
    .en(1'b1),
    .rd(inst_rdata)
);

dmem dmem_u(
    .clk(clk),
    .we(data_we),
    .re(data_en),
    .wd(data_wdata),
    .a(data_addr),
    .rd(data_rdata)
);

endmodule


module MEM_stage(
    input wire clk,
    input wire EX_MemWrite,
    input wire EX_MemRead,
    input wire [31:0]EX_reg_read_data2,
    input wire [31:0]EX_mem_addr,

    input wire [31:0] data_rdata,

    output wire [31:0]MEM_mem_read_data,
    output wire MEM_ready_go,

    output wire [31:0]data_addr,
    output wire [31:0]data_wdata,
    output wire data_we,
    output wire data_en
);

assign MEM_ready_go = 1'b1;

assign data_addr  = EX_mem_addr;
assign data_wdata = EX_reg_read_data2;
assign data_we    = EX_MemWrite;
assign data_en    = EX_MemWrite | EX_MemRead;

assign MEM_mem_read_data = data_rdata;

endmodule
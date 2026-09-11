

module MEM_stage(
    input logic clk,
    input logic EX_MemWrite,
    input logic EX_MemRead,
    input logic [31:0]EX_reg_read_data2,
    input logic [31:0]EX_mem_addr,

    input logic [31:0] data_rdata,

    output logic [31:0]MEM_mem_read_data,
    output logic MEM_ready_go,

    output logic [31:0]data_addr,
    output logic [31:0]data_wdata,
    output logic data_we,
    output logic data_en
);

assign MEM_ready_go = 1'b1;

assign data_addr  = EX_mem_addr;
assign data_wdata = EX_reg_read_data2;
assign data_we    = EX_MemWrite;
assign data_en    = EX_MemWrite | EX_MemRead;

assign MEM_mem_read_data = data_rdata;

endmodule
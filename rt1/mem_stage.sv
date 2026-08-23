

module MEM_stage(
    input logic clk,
    input logic EX_MemWrite,
    input logic [31:0]EX_reg_read_data2,
    input logic [31:0]EX_mem_addr,
    output logic [31:0]MEM_mem_read_data,
    output logic MEM_ready_go
);

assign MEM_ready_go = 1'b1;

dmem dmem_u(
.clk(clk),
.we(EX_MemWrite),
.wd(EX_reg_read_data2),
.a(EX_mem_addr),
.rd(MEM_mem_read_data)
);

endmodule
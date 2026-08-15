

module cpu(
    input logic clk,
    input logic rst
);

logic [31:0]instr,pc,mem_write_data,mem_addr,mem_read_data;
logic MemWrite;

mips mips(
.clk(clk),
.rst(rst),
.instr(instr),
.mem_read_data(mem_read_data),
.pc(pc),
.MemWrite(MemWrite),
.mem_write_data(mem_write_data),
.addr(addr)
);

imem imem_u(
.a(pc),
.rd(instr)
);

dmem dmem_u(
.clk(clk),
.we(MemWrite),
.wd(mem_write_data),
.a(mem_addr),
.rd(mem_read_data)
);

endmodule
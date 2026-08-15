module imem(
input [31:0]a,
output [31:0]rd
);

logic [31:0]RAM[63:0];

initial begin

$readmemb("D:/Project/CPU/MIPS_CPU_5/memfile.dat",RAM);

end

assign rd=RAM[a[31:2]];

endmodule



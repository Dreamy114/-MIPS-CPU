module imem(
    input logic clk,
    input logic en,
    input logic [31:0]a,
    output logic [31:0]rd
);

logic [31:0] RAM[225:0];

initial begin

$readmemh("D:/Project/CPU/my_CPU/lab1.mem", RAM);

end

assign rd = en ? RAM[(a - 32'h80000000) >> 2] : 32'b0;

endmodule
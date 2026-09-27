module imem(
    input wire clk,
    input wire en,
    input wire [31:0]a,
    output wire [31:0]rd
);

reg [31:0] RAM[225:0];

initial begin

$readmemh("D:/Project/CPU/my_CPU/memfile.dat", RAM);

end

assign rd = en ? RAM[(a - 32'h80000000) >> 2] : 32'b0;

endmodule
module imem(
    input logic clk,
    input logic en,
    input logic [31:0]a,
    output logic [31:0]rd
);

logic [31:0]RAM[63:0];

initial begin

$readmemh("D:/Project/CPU/my_CPU/memfile.dat",RAM);

end

always_ff @(posedge clk) begin
    if(en)rd <= RAM[a[31:2]];
end

endmodule





module dmem(
    input wire clk,
    input wire [3:0]we,
    input wire re,
    input wire [31:0]wd,
    input wire [31:0]a,
    output wire [31:0]rd
);

reg [31:0]RAM [63:0];
wire [5:0] ram_addr = (a - 32'h80400000) >> 2;

//分块写入，实现sb、sh
always @(posedge clk) begin
    if(we[0]) RAM[ram_addr][7:0]   <= wd[7:0];
    if(we[1]) RAM[ram_addr][15:8]  <= wd[15:8];
    if(we[2]) RAM[ram_addr][23:16] <= wd[23:16];
    if(we[3]) RAM[ram_addr][31:24] <= wd[31:24];
end

assign rd = re ? RAM[ram_addr] : 32'b0;

initial begin
    RAM[0] = 32'h80FF007F;
end

endmodule
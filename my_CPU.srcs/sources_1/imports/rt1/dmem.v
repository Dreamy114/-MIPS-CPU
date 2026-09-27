

module dmem(
    input wire clk,
    input wire we,
    input wire re,
    input wire [31:0]wd,
    input wire [31:0]a,
    output wire [31:0]rd
);

reg [31:0]RAM [63:0];


always @(posedge clk) begin
    if(we) begin
    RAM[(a - 32'h80400000) >> 2] <= wd;
    end
end

assign rd = re ? RAM[(a - 32'h80400000) >> 2] : 32'b0;

endmodule
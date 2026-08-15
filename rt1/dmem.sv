

module dmem(
    input logic clk,
    input logic we,
    input logic [31:0]wd,
    input logic [31:0]a,
    output logic [31:0]rd
);

logic [31:0]RAM [63:0];


always_ff @(posedge clk) begin
    if(we) begin
    RAM[a[31:2]] <= wd;
    end
end

assign rd= RAM[a[31:2]];

endmodule
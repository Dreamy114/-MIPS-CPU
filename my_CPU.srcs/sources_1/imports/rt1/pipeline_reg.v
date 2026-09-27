module pipeline_reg #(
    parameter Width = 32
)(
    input  wire             clk,
    input  wire             rst,
    input  wire             en,
    input  wire [Width-1:0] d_i,
    output reg [Width-1:0] q_o
);

always @(posedge clk) begin
    if (rst)
        q_o <= {Width{1'b0}};
    else if (en)
        q_o <= d_i;
end

endmodule
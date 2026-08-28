module pipeline_reg #(
    parameter Width = 32
)(
    input  logic             clk,
    input  logic             rst,
    input  logic             en,
    input  logic [Width-1:0] d_i,
    output logic [Width-1:0] q_o
);

always_ff @(posedge clk) begin
    if (rst)
        q_o <= '0;
    else if (en)
        q_o <= d_i;
end

endmodule
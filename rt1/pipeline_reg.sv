module pipeline_reg #(
    parameter WIDTH = 32
)(
    input  logic             clk,
    input  logic             rst,
    input  logic             en,
    input  logic [WIDTH-1:0] d_i,
    output logic [WIDTH-1:0] q_o
);

always_ff @(posedge clk) begin
    if (rst)
        q_o <= '0;
    else if (en)
        q_o <= d_i;
end

endmodule
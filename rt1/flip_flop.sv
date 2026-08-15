

module flip_flop(
    input logic clk,
    input logic rst,
    input logic [31:0]d_i,
    output logic [31:0]q_o
);

always_ff @(posedge clk or posedge rst) begin
    if(rst) q_o <= '0;
    else q_o <= d_i;
end

endmodule

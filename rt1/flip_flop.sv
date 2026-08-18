

module flip_flop#(
    parameter Width=32)
    (
    input logic clk,
    input logic rst,
    input logic [Width-1:0]d_i,
    output logic [Width-1:0]q_o
);

always_ff @(posedge clk or posedge rst) begin
    if(rst) q_o <= '0;
    else q_o <= d_i;
end

endmodule

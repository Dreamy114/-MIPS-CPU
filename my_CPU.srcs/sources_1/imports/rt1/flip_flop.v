

module flip_flop#(
    parameter Width=32)
    (
    input wire clk,
    input wire rst,
    input wire [Width-1:0]d_i,
    output reg [Width-1:0]q_o
);

always @(posedge clk or posedge rst) begin
    if(rst) q_o <= {Width{1'b0}};
    else q_o <= d_i;
end

endmodule

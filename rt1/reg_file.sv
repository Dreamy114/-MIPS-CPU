

module reg_file(
    input logic clk,
    input logic rst,
    input logic we,
    input logic [4:0]wa,
    input logic [31:0]wd,
    input logic [4:0]ra1,
    input logic [4:0]ra2,
    output logic [31:0]rd1,
    output logic [31:0]rd2
);

logic [31:0] rf[31:0];
integer i;

always_ff @(posedge clk or posedge rst) begin
    if(rst) begin 
        for(i=0;i<32;++i) begin 
        rf[i]<= '0;
        end
    end
    else if (we) begin
    rf[wa]<= wd;
    end
end

assign rd1= rf[ra1];
assign rd2= rf[ra2];

endmodule



module reg_file(
    input wire clk,
    input wire rst,
    input wire we,
    input wire [4:0]wa,
    input wire [31:0]wd,
    input wire [4:0]ra1,
    input wire [4:0]ra2,
    output wire [31:0]rd1,
    output wire [31:0]rd2
);

reg [31:0] rf[31:0];
integer i;

always @(posedge clk or posedge rst) begin
    if(rst) begin 
        for(i=0;i<32;i=i+1) begin 
        rf[i]<= 32'b0;
        end
    end
    else if (we) begin
        rf[wa]<= wd;
    end
end

assign rd1= rf[ra1];
assign rd2= rf[ra2];

endmodule

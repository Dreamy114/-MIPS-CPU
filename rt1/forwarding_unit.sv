module forwarding_unit(
    input logic [4:0]rs,
    input logic [4:0]rt,
    input logic [4:0]MEM_rd,
    input logic MEM_RegWrite,
    input logic [4:0]WB_rd,
    input logic WB_RegWrite,

    output logic [1:0]ForwardA,
    output logic [1:0]ForwardB
);

always_comb begin
    if(rs == MEM_rd && MEM_RegWrite && MEM_rd != 5'd0) ForwardA = 2'b01;
    else if(rs == WB_rd && WB_RegWrite && WB_rd != 5'd0) ForwardA = 2'b10;
    else ForwardA = 2'b00;

    if(rt == MEM_rd && MEM_RegWrite && MEM_rd != 5'd0) ForwardB = 2'b01;
    else if(rt == WB_rd && WB_RegWrite && WB_rd != 5'd0) ForwardB = 2'b10;
    else ForwardB = 2'b00;
end

endmodule
module hazard_detection_unit(
    input logic EX_MemRead,
    input logic [4:0] EX_rt,

    input logic MEM_MemRead,
    input logic [4:0] MEM_rd,

    input logic [4:0] ID_rs,
    input logic [4:0] ID_rt,
    input logic ID_rsUsed,
    input logic ID_rtUsed,

    output logic Stall
);

always_comb begin
    Stall = 1'b0;

    if(EX_MemRead && (EX_rt != 5'b0)) begin
        if((ID_rsUsed && (EX_rt == ID_rs)) ||
           (ID_rtUsed && (EX_rt == ID_rt))) begin
            Stall = 1'b1;
        end
    end

    if(MEM_MemRead && (MEM_rd != 5'b0)) begin
        if((ID_rsUsed && (MEM_rd == ID_rs)) ||
           (ID_rtUsed && (MEM_rd == ID_rt))) begin
            Stall = 1'b1;
        end
    end

end

endmodule
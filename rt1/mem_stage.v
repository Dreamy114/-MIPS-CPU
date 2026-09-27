

module MEM_stage(
    input wire clk,
    input wire EX_MemWrite,
    input wire EX_MemRead,
    input wire [31:0]EX_reg_read_data2,
    input wire [31:0]EX_mem_addr,

    input wire [31:0]EX_alu_result,
    input wire [1:0]EX_MemtoReg,
    input wire [31:0]EX_pc_plus_8,
    input wire [31:0]EX_instr,

    input wire [31:0] data_rdata,

    input wire EX_mem_load_type,

    input wire EX_op_sb,
    input wire EX_op_sh,

    output reg [31:0]MEM_mem_read_data,
    output wire MEM_ready_go,

    output wire [31:0]data_addr,
    output wire [31:0]data_wdata,
    output reg [3:0]data_we,
    output wire data_en,
    output wire [31:0]mem_forward_data
);

wire [1:0] byte_sel;
wire [7:0] lb_data;

assign MEM_ready_go = 1'b1;

assign data_addr  = EX_mem_addr;
assign data_wdata = EX_op_sb? {4{EX_reg_read_data2[7:0]}}:EX_op_sh?{2{EX_reg_read_data2[15:0]}}:EX_reg_read_data2;

assign data_en    = EX_MemWrite | EX_MemRead;

assign byte_sel = data_addr[1:0];



mux4 #(.Width(8)) byte_mux(
    .data0(data_rdata[7:0]),
    .data1(data_rdata[15:8]),
    .data2(data_rdata[23:16]),
    .data3(data_rdata[31:24]),
    .sel(byte_sel),
    .result(lb_data)
);

always @(*) begin
    case(EX_mem_load_type)
        1'b0: MEM_mem_read_data = data_rdata;
        1'b1: MEM_mem_read_data = {{24{lb_data[7]}},lb_data};
        default:MEM_mem_read_data = data_rdata;
    endcase
end

always @(*)begin
    if(!EX_MemWrite) data_we=4'b0000;
    else begin
        if(EX_op_sb)begin 
            case(byte_sel)
                2'b00:data_we=4'b0001;
                2'b01:data_we=4'b0010;
                2'b10:data_we=4'b0100;
                2'b11:data_we=4'b1000;
                default:data_we=4'b0000;
            endcase
        end
        else if(EX_op_sh)begin
            case(byte_sel)
                2'b00:data_we=4'b0011;
                2'b10:data_we=4'b1100;
                default:data_we=4'b0000;
            endcase
        end
        else
        data_we=4'b1111;
    end
end


mux4 mem_forward_data_mux (
    .data0(EX_alu_result),
    .data1(MEM_mem_read_data),
    .data2(EX_pc_plus_8),
    .data3({EX_instr[15:0],16'b0}),
    .sel(EX_MemtoReg),
    .result(mem_forward_data)
);

endmodule


module alu(
    input wire [31:0]a,
    input wire [31:0]b,
    input wire [3:0]alu_control,
    output reg [31:0]result,
    output wire [31:0]mem_addr
);

reg [32:0] ext_a,ext_b,sub_res;
reg cout;

assign mem_addr=a+b;

always @(*) begin//防溢出
    if(alu_control==4'd2)begin//无符号比较
        ext_a={1'b0,a};
        ext_b={1'b0,b};
    end
    else begin//有符号比较
        ext_a={a[31],a};
        ext_b={b[31],b};
    end

    sub_res=ext_a-ext_b;
    cout=sub_res[32];//（a<b）输出1，否则输出0
end

always @(*) begin

    case(alu_control)
        4'd0:result = a+b;
        4'd1:result = a-b;
        4'd2:result = {31'b0,cout};//SLTU（无符号比较）
        4'd3:result = {31'b0,cout};//SLT（有符号比较）
        4'd4:result = b<<a;//SLL（逻辑左移）
        4'd5:result = b>>a;//SRL（逻辑右移）
        4'd6:result = $signed(b)>>>a;//SRA（算数右移）
        4'd7:result = a&b;//AND（按位与）
        4'd8:result = a|b;//OR（按位或）
        4'd9:result = a^b;//XOR（按位异或）
        4'd10:result = ~(a|b);//NOR（按位或非）
        
        default: result = 32'b0;
    endcase

end

endmodule
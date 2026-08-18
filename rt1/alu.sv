

module alu(
    input logic [31:0]a,
    input logic [31:0]b,
    input logic [3:0]alu_control,
    output logic [31:0]result,
    output logic [31:0]mem_addr
);

logic [32:0] ext_a,ext_b,sub_res;
logic cout;

assign mem_addr=a+b;

always_comb begin
    if(alu_control==4'd2)begin
        ext_a={1'b0,a};
        ext_b={1'b0,b};
    end
    else begin
        ext_a={a[31],a};
        ext_b={b[31],b};
    end

    sub_res=ext_a-ext_b;
    cout=sub_res[32];
end

always_comb begin

    case(alu_control)
        4'd0:result = a+b;
        4'd1:result = a-b;
        4'd2:result = {31'b0,cout};
        4'd3:result = {31'b0,cout};
        4'd4:result = b<<a;
        4'd5:result = b>>a;
        4'd6:result = $signed(b)>>>a;
        4'd7:result = a&b;
        4'd8:result = a|b;
        4'd9:result = a^b;
        4'd10:result = ~(a|b);
        
        default: result = '0;
    endcase

end

endmodule
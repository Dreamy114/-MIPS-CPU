

module adder(
    input logic [31:0]a,
    input logic [31:0]b,
    output logic [31:0]result
);

assign result = a+b;

endmodule


module mux2#(
    parameter Width = 32
)(
    input logic [Width-1:0]data0,
    input logic [Width-1:0]data1,
    input logic sel,
    output logic[Width-1:0]result
);

always_comb begin
    case(sel)
    1'b0: result =data0;
    1'b1: result = data1;
    default: result = '0;
    endcase
end

endmodule


module mux4#(
    parameter Width = 32
)(
    input logic [Width-1:0]data0,
    input logic [Width-1:0]data1,
    input logic [Width-1:0]data2,
    input logic [Width-1:0]data3,
    input logic [1:0]sel,
    output logic[Width-1:0]result
);

always_comb begin
    case(sel)
    2'b00: result =data0;
    2'b01: result = data1;
    2'b10: result = data2;
    2'b11: result = data3;
    default result = '0;
    endcase
end

endmodule


module sign_ext(
    input logic [15:0]imm16,
    output logic [31:0]imm32
);

    assign imm32={{16{imm16[15]}},imm16};

endmodule

module zero_ext(
    input logic [15:0]imm16,
    output logic [31:0]imm32
);

assign imm32={16'b0,imm16};

endmodule
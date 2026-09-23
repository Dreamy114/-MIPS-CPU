

module control_unit(
    input wire [5:0]op,
    input wire [4:0]shamt,
    input wire [5:0]funct,
    input wire Zero,

    output wire RegWrite,
    output wire [1:0]RegDst, 
    output wire [1:0]ALUSrc,
    output wire MemWrite,
    output wire MemRead,
    output wire [1:0]MemtoReg,
    output wire [1:0]sel_next_pc,
    output wire [3:0]alu_control,
    output wire rsUsed,
    output wire rtUsed,
    output wire sel_imm
  
);

wire inst_addu,inst_addiu,inst_subu,inst_lw,inst_sw,inst_beq,inst_bne,inst_jal,inst_jr,inst_slt,inst_sltu,inst_sll,inst_srl,inst_sra,inst_lui,inst_and,inst_or,inst_xor,inst_nor,inst_add,inst_addi,inst_sub,inst_slti,inst_sltiu,inst_andi,inst_ori,inst_xori,inst_sllv,inst_srlv,inst_srav;
wire [63:0]op_d,funct_d;
wire [31:0]shamt_d;



decoder_6_64 u_dec_op (.in(op),.out(op_d));

decoder_6_64 u_dec_funct(.in(funct),.out(funct_d));

decoder_5_32 u_dec_shamt(.in(shamt),.out(shamt_d));



assign inst_addu=op_d[6'b000000] & shamt_d[5'b00000] & funct_d[6'b100001];
assign inst_addiu=op_d[6'b001001];
assign inst_subu=op_d[6'b000000] & shamt_d[5'b00000] & funct_d[6'b100011];
assign inst_lw=op_d[6'b100011];
assign inst_sw=op_d[6'b101011];
assign inst_beq=op_d[6'b000100];
assign inst_bne=op_d[6'b000101];
assign inst_jal=op_d[6'b000011];
assign inst_jr=op_d[6'b000000] & shamt_d[5'b00000] & funct_d[6'b001000];
assign inst_slt=op_d[6'b000000] & shamt_d[5'b00000] & funct_d[6'b101010];
assign inst_sltu=op_d[6'b000000] & shamt_d[5'b00000] & funct_d[6'b101011];
assign inst_sll=op_d[6'b000000] & funct_d[6'b000000];
assign inst_srl=op_d[6'b000000] & funct_d[6'b000010];
assign inst_sra=op_d[6'b000000] & funct_d[6'b000011];
assign inst_lui=op_d[6'b001111];
assign inst_and=op_d[6'b000000] & shamt_d[5'b00000] & funct_d[6'b100100];
assign inst_or=op_d[6'b000000] & shamt_d[5'b00000] & funct_d[6'b100101];
assign inst_xor=op_d[6'b000000] & shamt_d[5'b00000] & funct_d[6'b100110];
assign inst_nor=op_d[6'b000000] & shamt_d[5'b00000] & funct_d[6'b100111];
assign inst_add=op_d[6'b000000] & shamt_d[5'b00000] & funct_d[6'b100000];
assign inst_addi=op_d[6'b001000];
assign inst_sub=op_d[6'b000000] & shamt_d[5'b00000] & funct_d[6'b100010];
assign inst_slti=op_d[6'b001010];
assign inst_sltiu=op_d[6'b001011];
assign inst_andi = op_d[6'b001100];
assign inst_ori  = op_d[6'b001101];
assign inst_xori = op_d[6'b001110];
assign inst_sllv = op_d[6'b000000] & shamt_d[5'b00000] & funct_d[6'b000100];
assign inst_srlv = op_d[6'b000000] & shamt_d[5'b00000] & funct_d[6'b000110];
assign inst_srav = op_d[6'b000000] & shamt_d[5'b00000] & funct_d[6'b000111];



assign RegWrite=inst_addu|inst_addiu|inst_subu|inst_lw|inst_jal|inst_sltu|inst_slt|inst_sll|inst_srl|inst_sra|inst_lui|inst_and|inst_or|inst_xor|inst_nor|inst_add|inst_addi|inst_sub|inst_slti|inst_sltiu|inst_andi|inst_ori|inst_xori|inst_sllv|inst_srlv|inst_srav;
assign RegDst[0]=inst_addu|inst_subu|inst_sltu|inst_slt|inst_sll|inst_srl|inst_sra|inst_and|inst_or|inst_xor|inst_nor|inst_add|inst_sub|inst_sllv|inst_srlv|inst_srav;             //0:rt,1:rd
assign RegDst[1]=inst_jal;
assign ALUSrc[1]=inst_addiu|inst_lw|inst_sw|inst_addi|inst_slti|inst_sltiu|inst_andi|inst_ori|inst_xori;
assign ALUSrc[0]=inst_sll|inst_srl|inst_sra;
assign MemWrite=inst_sw;
assign MemRead=inst_lw;
assign MemtoReg[0]=inst_lw|inst_lui;
assign MemtoReg[1]=inst_jal|inst_lui;
assign sel_next_pc[0]=((Zero & inst_beq)|(~Zero & inst_bne))|inst_jr;
assign sel_next_pc[1]=inst_jal|inst_jr;
assign sel_imm=inst_andi|inst_ori|inst_xori;


assign alu_control[0]=inst_subu|inst_beq|inst_bne|inst_slt|inst_srl|inst_and|inst_xor|inst_sub|inst_slti|inst_andi|inst_xori|inst_srlv;
assign alu_control[1]=inst_sltu|inst_slt|inst_sra|inst_and|inst_nor|inst_sltiu|inst_slti|inst_andi|inst_srav;
assign alu_control[2]=inst_sll|inst_srl|inst_sra|inst_and|inst_andi|inst_sllv|inst_srlv|inst_srav;
assign alu_control[3]=inst_or|inst_xor|inst_nor|inst_ori|inst_xori;

assign rsUsed = inst_addu|inst_addiu|inst_subu|inst_lw|inst_sw|inst_beq|inst_bne|inst_jr|inst_slt|inst_sltu|inst_and|inst_or|inst_xor|inst_nor|inst_add|inst_addi|inst_sub|inst_slti|inst_sltiu|inst_andi|inst_ori|inst_xori;
assign rtUsed = inst_addu|inst_subu|inst_sw|inst_beq|inst_bne|inst_slt|inst_sltu|inst_sll|inst_srl|inst_sra|inst_and|inst_or|inst_xor|inst_nor|inst_add|inst_sub|inst_sllv|inst_srlv|inst_srav;

endmodule

module decoder_6_64 (
    input wire [5:0]in,
    output wire [63:0]out
);

assign out=64'b1<<in;

endmodule


module decoder_5_32 (
    input wire [4:0]in,
    output wire [31:0]out
);

assign out=32'b1<<in;

endmodule
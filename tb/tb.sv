module tb;

logic clk;
logic rst;

cpu uut(
    .clk(clk),
    .rst(rst)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 1;

    // =========================
    // 初始化指令
    // =========================

    // $8 = 8
    uut.imem_u.RAM[0] = 32'h24080008;

    // $9 = 32
    uut.imem_u.RAM[1] = 32'h24090020;

    // $13 = -8
    uut.imem_u.RAM[2] = 32'h240DFFF8;

    // sll $11, $8, 2
    // 8 << 2 = 32
    uut.imem_u.RAM[3] = 32'h00085880;

    // srl $12, $9, 2
    // 32 >> 2 = 8
    uut.imem_u.RAM[4] = 32'h00096082;

    // sra $14, $13, 2
    // -8 >>> 2 = -2
    uut.imem_u.RAM[5] = 32'h000D7083;


    // =========================
    // 解除复位
    // =========================

    #20;
    rst = 0;


    // =========================
    // 每条指令执行后观察
    // =========================

    repeat(6) begin
        @(posedge clk);
        #1;

        $display("--------------------------------");
        $display("PC          = %h", uut.mips.datapath_u.pc_o);
        $display("instr       = %h", uut.instr);
        $display("a_src       = %h", uut.mips.datapath_u.a_src);
        $display("b_src       = %h", uut.mips.datapath_u.b_src);
        $display("alu_control = %b", uut.mips.datapath_u.alu_control);
        $display("alu_result  = %h", uut.mips.datapath_u.alu_result);
    end


    // =========================
    // 最终结果
    // =========================

    $display("================================");
    $display("reg[8]  = %d", uut.mips.datapath_u.regfile.rf[8]);
    $display("reg[9]  = %d", uut.mips.datapath_u.regfile.rf[9]);
    $display("reg[11] = %d", uut.mips.datapath_u.regfile.rf[11]);
    $display("reg[12] = %d", uut.mips.datapath_u.regfile.rf[12]);
    $display("reg[13] = %d", $signed(uut.mips.datapath_u.regfile.rf[13]));
    $display("reg[14] = %d", $signed(uut.mips.datapath_u.regfile.rf[14]));

    if (uut.mips.datapath_u.regfile.rf[11] == 32 &&
        uut.mips.datapath_u.regfile.rf[12] == 8 &&
        uut.mips.datapath_u.regfile.rf[14] == 32'hFFFFFFFE)
        $display("SLL + SRL + SRA PASS!");
    else
        $display("SLL + SRL + SRA FAIL!");

    $finish;
end

endmodule
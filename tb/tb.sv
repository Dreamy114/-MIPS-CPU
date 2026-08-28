`timescale 1ns / 1ps

module tb_branch_flush;

logic clk;
logic rst;

cpu uut(
    .clk(clk),
    .rst(rst)
);

// 10ns 一个周期
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;

    #20;
    rst = 0;

    // 等流水线运行
    #200;

    $display("================================");
    $display("Branch Flush Test");
    $display("================================");

    $display("r8  = %d", uut.ID.regfile.rf[8]);
    $display("r9  = %d", uut.ID.regfile.rf[9]);
    $display("r10 = %d", uut.ID.regfile.rf[10]);

    $finish;
end

// 观察流水线

always @(posedge clk) begin
    $display(
        "T=%0t | PC=%h | IF=%h | ID=%h | ID_pc_plus_4=%h | ID_imm=%h | Stall=%b | sel_next_pc=%b",
        $time,
        uut.IF_pc,
        uut.IF_instr,
        uut.ID_instr,
        uut.ID_pc_plus_4,
        uut.ID_imm,
        uut.Stall,
        uut.ID.ID_sel_next_pc
    );
end

endmodule
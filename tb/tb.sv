`timescale 1ns / 1ps

module tb_cpu;

    logic clk;
    logic rst;

    cpu uut (
        .clk(clk),
        .rst(rst)
    );

    // 时钟
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // 每个时钟周期打印一次流水线状态
    always @(posedge clk) begin
        #1;

        $display(
            "T=%0t | PC=%h | ID=%h | EX=%h | MEM=%h | WB=%h | ID_ALU=%b | EX_ALU_CTRL=%b | ALUSrc=%b | MemtoReg=%b | EX_RegWrite=%b | EX_rs=%0d | EX_rt=%0d | ForwardA=%b | ForwardB=%b | EX_data1=%0d | EX_data2=%0d | EX_RESULT=%0d",
            $time,
            uut.IF_pc,
            uut.ID_instr,
            uut.EX_instr,
            uut.MEM_instr,
            uut.WB_instr,
            uut.ID_alu_control,
            uut.EX_alu_control,
            uut.EX_ALUSrc,
            uut.EX_MemtoReg,
            uut.EX_RegWrite,
            uut.EX_rs,
            uut.EX_rt,
            uut.ForwardA,
            uut.ForwardB,
            uut.EX_reg_read_data1,
            uut.EX_reg_read_data2,
            uut.EX_alu_result
        );
    end

    // 测试
    initial begin

        rst = 1'b1;

        // 复位
        #20;

        rst = 1'b0;

        // 跑 200ns
        #200;

        $display("");
        $display("======================================");
        $display("           FINAL RESULT");
        $display("======================================");

        $display("$t0 = %0d", uut.ID.regfile.rf[8]);
        $display("$t1 = %0d", uut.ID.regfile.rf[9]);
        $display("$t2 = %0d", uut.ID.regfile.rf[10]);
        $display("$t3 = %0d", uut.ID.regfile.rf[11]);
        $display("$t4 = %0d", uut.ID.regfile.rf[12]);

        if (uut.ID.regfile.rf[8] == 30)
            $display("$t0 PASS");
        else
            $display("$t0 FAIL");

        if (uut.ID.regfile.rf[11] == 35)
            $display("$t3 PASS");
        else
            $display("$t3 FAIL");

        if (uut.ID.regfile.rf[12] == 5)
            $display("$t4 PASS");
        else
            $display("$t4 FAIL");

        $display("======================================");

        $finish;
    end

endmodule
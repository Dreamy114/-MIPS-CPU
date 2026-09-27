`timescale 1ns/1ps

module tb;

    logic clk;
    logic rst;

    // ============================================================
    // DUT
    // ============================================================

    top dut (
        .clk(clk),
        .rst(rst)
    );

    // ============================================================
    // Clock
    // ============================================================

    initial begin
        clk = 1'b0;
    end

    always #5 clk = ~clk;


    // ============================================================
    // 常用寄存器检查任务
    // ============================================================

    task automatic check_reg(
        input integer reg_num,
        input logic [31:0] expected
    );

        logic [31:0] actual;

        begin
            actual = dut.cpu_u.ID.regfile.rf[reg_num];

            if (actual !== expected) begin
                $error(
                    "REG[%0d] FAILED: expected = %08h, actual = %08h",
                    reg_num,
                    expected,
                    actual
                );
            end
            else begin
                $display(
                    "REG[%0d] PASS: %08h",
                    reg_num,
                    actual
                );
            end
        end

    endtask


    // ============================================================
    // Data Memory 检查
    // ============================================================

    task automatic check_mem(
        input integer word_index,
        input logic [31:0] expected
    );

        logic [31:0] actual;

        begin
            actual = dut.dmem_u.RAM[word_index];

            if (actual !== expected) begin
                $error(
                    "MEM[%0d] FAILED: expected = %08h, actual = %08h",
                    word_index,
                    expected,
                    actual
                );
            end
            else begin
                $display(
                    "MEM[%0d] PASS: %08h",
                    word_index,
                    actual
                );
            end
        end

    endtask


    // ============================================================
    // Reset
    // ============================================================

    initial begin

        rst = 1'b1;

        repeat (3) @(posedge clk);

        rst = 1'b0;

    end


    // ============================================================
    // 主测试
    // ============================================================

    initial begin

        // 等待 reset 完成
        wait(rst == 1'b0);

        // 给 CPU 足够时间执行整个测试程序
        repeat (1000) @(posedge clk);

$display("");
$display("========== ExtRAM CHECK ==========");

for (integer i = 0; i < 64; i = i + 1) begin
    $display("RAM[%0d] = %08h", i, dut.dmem_u.RAM[i]);
end

$display("==================================");

    /*    $display("");
        $display("====================================================");
        $display("                 FINAL CHECK");
        $display("====================================================");


        // ========================================================
        // 1. 基础算术
        // ========================================================

        // addiu t0, zero, 10
        // 后面 t0 会被重新写成 5
        //
        // addiu t1, zero, 3
        check_reg(9, 32'd3);

        // addu t2,t0,t1
        check_reg(10, 32'd13);

        // subu t3,t0,t1
        check_reg(11, 32'd7);


        // ========================================================
        // 2. 比较
        // ========================================================

        // slt t4,t3,t1
        // 7 < 3 = 0
        check_reg(12, 32'd0);

        // sltu t5,t1,t3
        // 3 < 7 = 1
        check_reg(13, 32'd1);


        // ========================================================
        // 3. 移位
        // ========================================================

        // sll t6,t1,2
        // 3 << 2 = 12
        check_reg(14, 32'd12);

        // srl t7,t6,1
        // 12 >> 1 = 6
        check_reg(15, 32'd6);


        // ========================================================
        // 4. LUI
        // ========================================================

        check_reg(16, 32'h12340000);


        // ========================================================
        // 5. 逻辑运算
        // ========================================================

        // and t0,t1
        // 10 & 3 = 2
        check_reg(17, 32'd2);

        // or
        // 10 | 3 = 11
        check_reg(18, 32'd11);

        // xor
        // 10 ^ 3 = 9
        check_reg(19, 32'd9);

        // nor
        // ~(10 | 3) = ~11
        check_reg(20, 32'hfffffff4);


        // ========================================================
        // 6. sw / lw
        // ========================================================

        // s5 = 0x40
        check_reg(21, 32'h00000040);

        // RAM[0x40 / 4] = RAM[16]
        check_mem(16, 32'd13);

        // lw s6,0(s5)
        check_reg(22, 32'd13);


        // ========================================================
        // 7. load-use hazard
        //
        // lw  s6,0(s5)
        // addu s7,s6,t1
        //
        // 应该得到：
        //
        // s7 = 13 + 3 = 16
        // ========================================================

        check_reg(23, 32'd16);


        // ========================================================
        // 8. branch
        // ========================================================

        // 后面的程序最终会让 t8 = 0x3333
        //
        // 0x1111 和 0x2222 都应该被 flush
        //
        check_reg(24, 32'h00003333);


        // ========================================================
        // 9. JAL
        //
        // 注意：
        // 本次实际程序中 jal 位于 PC = 0x5c
        //
        // 所以：
        //
        // $ra = PC + 8
        //     = 0x5c + 8
        //     = 0x64
        // ========================================================

        check_reg(31, 32'h00000064);


        // ========================================================
        // 10. JAL target
        // ========================================================

        // jal 跳转目标执行：
        //
        // addiu k0,zero,0x6666
        //
        check_reg(26, 32'h00006666);


        // ========================================================
        // 11. JR
        //
        // jr 应该使用 $ra
        //
        // 如果 jr 正确：
        //
        // PC 应该跳到 0x64
        //
        // 而不是：
        //
        // 0x6666
        // ========================================================


        // ========================================================
        // 12. SRA
        //
        // -8 >> 1 = -4
        // ========================================================

        check_reg(29, 32'hfffffffc);


        // ========================================================
        // 13. JR t9
        //
        // 程序会把 t9 设置成目标地址，
        // 然后通过 jr t9 跳过去。
        //
        // 目标位置最终写：
        //
        // gp = 0x8888
        // ========================================================

        check_reg(28, 32'h00008888);


        $display("");
        $display("====================================================");
        $display("              FINAL CHECK FINISHED");
        $display("====================================================");
    */
        $finish;
    end


    // ============================================================
    // 每个时钟周期打印流水线状态
    // ============================================================

    always @(posedge clk) begin

        #1;

        $display(
            "T=%0t | PC=%08h | IF=%08h | ID=%08h | EX=%08h | MEM=%08h | WB=%08h | Stall=%b",
            $time,

            dut.cpu_u.inst_addr,

            dut.cpu_u.IF_instr,
            dut.cpu_u.ID_instr,
            dut.cpu_u.EX_instr,
            dut.cpu_u.MEM_instr,
            dut.cpu_u.WB_instr,

            dut.cpu_u.Stall
        );

    end


    // ============================================================
    // 专门监视 JR / Branch 数据通路
    //
    // 这个是你现在最需要看的部分
    // ============================================================

    always @(posedge clk) begin

        #1;

        $display(
            "       ID: rs=%0d rt=%0d | ID_rd1=%08h ID_rd2=%08h | SelPC=%b | BF_A=%b BF_B=%b",
            
            dut.cpu_u.ID_rs,
            dut.cpu_u.ID_rt,

            dut.cpu_u.ID_reg_read_data1,
            dut.cpu_u.ID_reg_read_data2,

            dut.cpu_u.sel_next_pc,

            dut.cpu_u.BranchForwardA,
            dut.cpu_u.BranchForwardB
        );

    end


    // ============================================================
    // WB / RegFile 写回监视
    // ============================================================

    always @(posedge clk) begin

        #1;

        if (dut.cpu_u.WB_RegWrite) begin

            $display(
                "       WB WRITE: R[%0d] <= %08h | WB_instr=%08h | MemtoReg=%b",
                
                dut.cpu_u.WB_reg_write_addr,
                dut.cpu_u.WB_reg_write_data,

                dut.cpu_u.WB_instr,
                dut.cpu_u.WB_MemtoReg
            );

        end

    end


    // ============================================================
    // 专门监视 JAL / JR
    //
    // 当 ID 中出现 JAL/JR 时，把关键数据全部打印出来
    // ============================================================

    always @(posedge clk) begin

        #1;

        // JAL opcode = 000011
        if (dut.cpu_u.ID_instr[31:26] == 6'b000011) begin

            $display("");
            $display("*************** JAL IN ID ***************");

            $display(
                "ID PC+4  = %08h",
                dut.cpu_u.ID_pc_plus_4
            );

            $display(
                "ID PC+8  = %08h",
                dut.cpu_u.ID_pc_plus_8
            );

            $display(
                "ID rd    = %0d",
                dut.cpu_u.ID_reg_write_addr
            );

            $display(
                "sel_next_pc = %b",
                dut.cpu_u.sel_next_pc
            );

            $display("******************************************");
            $display("");

        end


        // JR = R-type + funct 001000
        if (
            dut.cpu_u.ID_instr[31:26] == 6'b000000 &&
            dut.cpu_u.ID_instr[5:0]  == 6'b001000
        ) begin

            $display("");
            $display("*************** JR IN ID ****************");

            $display(
                "JR instr       = %08h",
                dut.cpu_u.ID_instr
            );

            $display(
                "JR rs          = %0d",
                dut.cpu_u.ID_rs
            );

            $display(
                "REG[rs]        = %08h",
                dut.cpu_u.ID_reg_read_data1
            );

            $display(
                "forward_a_src  = %08h",
                dut.cpu_u.ID_reg_read_data1
            );

            $display(
                "BranchForwardA  = %b",
                dut.cpu_u.BranchForwardA
            );

            $display(
                "MEM ALU result = %08h",
                dut.cpu_u.MEM_alu_result
            );

            $display(
                "EX ALU result  = %08h",
                dut.cpu_u.EX_alu_result
            );

            $display(
                "WB write data  = %08h",
                dut.cpu_u.WB_reg_write_data
            );

            $display(
                "RF[31]         = %08h",
                dut.cpu_u.ID.regfile.rf[31]
            );

            $display(
                "sel_next_pc    = %b",
                dut.cpu_u.sel_next_pc
            );

            $display("******************************************");
            $display("");

        end

    end


    // ============================================================
    // Stall 专门监视
    // ============================================================

    always @(posedge clk) begin

        #1;

        if (dut.cpu_u.Stall) begin

            $display("");
            $display("=============== STALL ===================");

            $display(
                "EX_instr = %08h",
                dut.cpu_u.EX_instr
            );

            $display(
                "EX_MemRead = %b",
                dut.cpu_u.EX_MemRead
            );

            $display(
                "EX_rt = %0d",
                dut.cpu_u.EX_rt
            );

            $display(
                "ID_instr = %08h",
                dut.cpu_u.ID_instr
            );

            $display(
                "ID_rs = %0d",
                dut.cpu_u.ID_rs
            );

            $display(
                "ID_rt = %0d",
                dut.cpu_u.ID_rt
            );

            $display("==========================================");
            $display("");

        end

    end

endmodule

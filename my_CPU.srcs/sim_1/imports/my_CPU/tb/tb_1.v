`timescale 1ns/1ps

module tb1;

    reg clk;
    reg rst;

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
    // Register Check
    // ============================================================

    task check_reg;
        input integer reg_num;
        input [31:0] expected;

        reg [31:0] actual;

        begin
            actual = dut.cpu_u.ID.regfile.rf[reg_num];

            if (actual !== expected) begin
                $display(
                    "REG[%0d] FAILED: expected=%08h actual=%08h",
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
    // Data Memory Check
    // ============================================================

    task check_mem;
        input integer word_index;
        input [31:0] expected;

        reg [31:0] actual;

        begin
            actual = dut.dmem_u.RAM[word_index];

            if (actual !== expected) begin
                $display(
                    "MEM[%0d] FAILED: expected=%08h actual=%08h",
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
    // Main Test
    // ============================================================

    initial begin

        wait(rst == 1'b0);

        // 等待 CPU 执行完整测试程序
        repeat (100) @(posedge clk);

        $display("");
        $display("====================================================");
        $display("                 LW / SW TEST");
        $display("====================================================");

        // --------------------------------------------------------
        // t0 = 0x40
        // --------------------------------------------------------

        check_reg(8, 32'h00000040);

        // --------------------------------------------------------
        // t1 = 0x12345678
        // sw t1, 0(t0)
        // lw t2, 0(t0)
        // --------------------------------------------------------

        check_reg(9, 32'h12345678);
        check_reg(10, 32'h12345678);

        // --------------------------------------------------------
        // t3 = 0x000000ff
        // sw t3, 4(t0)
        // lw t4, 4(t0)
        // --------------------------------------------------------

        check_reg(11, 32'h000000ff);
        check_reg(12, 32'h000000ff);

        // --------------------------------------------------------
        // DMEM
        //
        // t0 = 0x40
        //
        // 0x40 / 4 = 16
        // 0x44 / 4 = 17
        // --------------------------------------------------------

        $display("");
        $display("========== DMEM CHECK ==========");

        check_mem(16, 32'h12345678);
        check_mem(17, 32'h000000ff);

        $display("================================");

        $display("");
        $display("====================================================");
        $display("               LW / SW TEST FINISHED");
        $display("====================================================");

        $finish;

    end


    // ============================================================
    // Pipeline Monitor
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
    // ID / Branch Monitor
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
    // WB Monitor
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
    // Stall Monitor
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
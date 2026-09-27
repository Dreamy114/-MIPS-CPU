`timescale 1ns/1ps

module tb_1;

    reg clk;
    reg rst;

    top dut (
        .clk(clk),
        .rst(rst)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst = 1'b1;
        repeat (3) @(posedge clk);
        rst = 1'b0;
    end

    initial begin
        wait(rst == 1'b0);
        repeat (20) @(posedge clk);
        $finish;
    end

    always @(posedge clk) begin
        #1;
        $display(
            "T=%0t | PC=%08h | IF=%08h | ID=%08h | EX=%08h | MEM=%08h | WB=%08h | t0=%08h | t1=%08h | t2=%08h",
            $time,
            dut.cpu_u.inst_addr,
            dut.cpu_u.IF_instr,
            dut.cpu_u.ID_instr,
            dut.cpu_u.EX_instr,
            dut.cpu_u.MEM_instr,
            dut.cpu_u.WB_instr,
            dut.cpu_u.ID.regfile.rf[8],
            dut.cpu_u.ID.regfile.rf[9],
            dut.cpu_u.ID.regfile.rf[10]
        );
    end

endmodule
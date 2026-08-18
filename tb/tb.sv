`timescale 1ns / 1ps

module tb;

logic clk;
logic rst;

cpu uut(
    .clk(clk),
    .rst(rst)
);

// 10ns 一个周期
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    // 复位
    rst = 1;
    #20;
    rst = 0;

    // 等待流水线执行完
    #400;

    $display("--------------------------------");
    $display("Register Test Result");
    $display("--------------------------------");

    $display("$1  = %d", uut.ID.regfile.rf[1]);
    $display("$2  = %d", uut.ID.regfile.rf[2]);
    $display("$3  = %d", uut.ID.regfile.rf[3]);
    $display("$4  = %d", uut.ID.regfile.rf[4]);
    $display("$5  = %d", uut.ID.regfile.rf[5]);
    $display("$6  = %d", uut.ID.regfile.rf[6]);
    $display("$7  = %d", uut.ID.regfile.rf[7]);
    $display("$8  = %d", uut.ID.regfile.rf[8]);
    $display("$9  = %d", uut.ID.regfile.rf[9]);
    $display("$10 = %d", uut.ID.regfile.rf[10]);
    $display("$11 = %d", uut.ID.regfile.rf[11]);

    $display("--------------------------------");

    // 自动判断
    if (uut.ID.regfile.rf[1]  == 32'd10 &&
        uut.ID.regfile.rf[2]  == 32'd3  &&
        uut.ID.regfile.rf[3]  == 32'd13 &&
        uut.ID.regfile.rf[4]  == 32'd7  &&
        uut.ID.regfile.rf[5]  == 32'd2  &&
        uut.ID.regfile.rf[6]  == 32'd11 &&
        uut.ID.regfile.rf[7]  == 32'd9  &&
        uut.ID.regfile.rf[8]  == -32'd12 &&
        uut.ID.regfile.rf[9]  == 32'd1  &&
        uut.ID.regfile.rf[10] == 32'd5  &&
        uut.ID.regfile.rf[11] == 32'd5) begin

        $display("PASS");
    end
    else begin

        $display("FAIL");
    end

    $display("--------------------------------");

    $finish;
end

endmodule
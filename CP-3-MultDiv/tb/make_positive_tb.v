`timescale 1ns/100ps
module make_positive_tb();
    reg enable = 1;
    reg signed [31:0] in = 12;
    wire signed [31:0] out;

    make_positive dut(out, in, enable);

    initial begin
        #20
        $display("%d -> %d (enable=%b)", in, out, enable);
        in = in*-1;
        #20
        $display("%d -> %d (enable=%b)", in, out, enable);
        enable = 0;
        #20
        $display("%d -> %d (enable=%b)", in, out, enable);
        in = in*-1;
        #20
        $display("%d -> %d (enable=%b)", in, out, enable);
        $finish;
    end
endmodule
`timescale 1ns/100ps
module sign_extender_17_tb();
    reg signed [16:0] in = -12;
    wire signed [31:0] out;

    sign_extender_17 dut(
        .extended(out),
        .in_17(in));

    initial begin
        #20
        $display("%b -> %b", in, out);
        in = 7;
        #20
        $display("%b -> %b", in, out);
        $finish;
    end
endmodule
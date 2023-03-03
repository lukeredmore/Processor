`timescale 1 ns/100 ps
module cla_8_tb;
    wire [7:0] A, B, S, P, G, bw_and, bw_or;
    wire Cin, isZero;
    // wire Cout;

    cla_8 cla(S, P, G, bw_and, bw_or, isZero, A, B, Cin);

    integer a, b, i;
    integer h = 0;

    assign {Cin} = h[0];
    assign {A} = a[7:0];
    assign {B} = b[7:0];

    initial begin
        $dumpfile("cla_8_wf.vcd");
        $dumpvars(0, cla_8_tb);
        $display("\033[1m\033[4m A\tB\tCin\t|\tS\tCout\tActual \033[24m\033[0m");
        for (i = 0; i < 25; i = i+ 1) begin
            a = $urandom;
            b = $urandom;
            #20;
            $display("%d\t%d\t%b\t|\t%d\t%b\t%d", A, B, Cin, S, Cout, a[7:0]+b[7:0]);
        end
        
        $finish;
    end

    // iverilog tb/cla_8_tb.v cla_8.v && vvp a.out && rm a.out
endmodule
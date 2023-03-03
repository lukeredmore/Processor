`timescale 1 ns/100 ps
module cla_32_tb;
    wire [31:0] A, B, S, bw_and, bw_or;
    wire Cin, isZero, Cout;

    cla_32 cla(S, Cout, bw_and, bw_or, isZero, A, B, Cin);

    integer a, b, i;
    integer h = 0;

    assign {Cin} = h[0];
    assign {A} = a[31:0];
    assign {B} = b[31:0];

    initial begin
        $dumpfile("cla_32_wf.vcd");
        $dumpvars(0, cla_32_tb);
        $display("\033[1m\033[4m bA\tA\tB\tCin\t|\tS\tCout\tActual\tisZero\tisPositive \033[24m\033[0m");

        // a = -450000;
        // b = 450000;
        // #20;
        // $display("%b\t%d\t%d\t%b\t|\t%d\t%b\t%d\t%b\t%b\t%b\t%b", A, $signed(A), $signed(B), Cin, $signed(S), Cout, $signed(a[31:0]+b[31:0]), bw_and, bw_or, isZero, isNegative);

        for (i = 0; i < 25; i = i+ 1) begin
            a = $random;
            b = $random;
            #20;
            $display("%b\t%d\t%d\t%b\t|\t%d\t%b\t%d\t%b\t%b\t%b\t%b", A, $signed(A), $signed(B), Cin, $signed(S), Cout, $signed(a[31:0]+b[31:0]), bw_and, bw_or, isZero, isNegative);
        end
        
        $finish;
    end

    // iverilog -c FileList.txt tb/cla_32_tb.v && vvp a.out && rm a.out
endmodule
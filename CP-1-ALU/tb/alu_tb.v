`timescale 1 ns/100 ps
module alu_tb;
    wire [31:0] A, B, out; 
    wire [4:0] Opcode, Shiftamt;
    wire isNotEqual, isLessThan, overflow;

    alu alu_op(A, B, Opcode, Shiftamt, out, isNotEqual, isLessThan, overflow);

    integer a, b, opcode, shiftamt, diff_with_act;

    assign {Opcode} = opcode[4:0];
    assign {A} = a[31:0];
    assign {B} = b[31:0];
    assign {Shiftamt} = shiftamt[4:0];

    initial begin
        $dumpfile("alu_wf.vcd");
        $dumpvars(0, alu_tb);


        //Testing ADD
        $display("\n\nOPCODE: 00000 (ADD)");
        opcode = 0;
        $display("\033[1m\033[4m A\t\tB\t\t|\to-flow\tA + B\t\tactual \033[24m\033[0m");
        for (integer i = 0; i < 25; i = i+ 1) begin
            a = $random;
            b = $random;
            #20;
            // diff_with_act = $signed(out) - (a+b);
            $display("%.2e\t%.2e\t|\t%d\t%.2e\t%.2e\t%b", a,b, overflow, $signed(out), $signed(a+b), out);
        end

        a = -1000000;
        b = 255;
        #20;
        $display("%.2e\t%.2e\t|\t%d\t%d\t%d\t%b", a,b, overflow, $signed(out), $signed(a+b), out);

        a = 2_147_483_647;
        b = -2_147_483_648;
        #20;
        $display("%.2e\t%.2e\t|\t%d\t%d\t%d\t%b", a,b, overflow, $signed(out), $signed(a+b), out);

        a = -2_147_483_648;
        b = -1;
        #20;
        $display("%.2e\t%.2e\t|\t%d\t%d\t%d\t%b", a,b, overflow, $signed(out), $signed(a+b), out);

        a = 2_147_483_647;
        b = 1;
        #20;
        $display("%.2e\t%.2e\t|\t%d\t%d\t%d\t%b", a,b, overflow, $signed(out), $signed(a+b), out);

        //Testing AND
        $display("OPCODE: 00010 (AND)");
        opcode = 2;
        $display("\033[1m\033[4m A\t\t\t\t\tB\t\t\t\t\t|\tA AND B\t\t\t\t\tDiff from true? \033[24m\033[0m");
        for (integer i = 0; i < 25; i = i+ 1) begin
            a = $urandom;
            b = $urandom;
            #20;
            diff_with_act = $signed(out) - $signed(A&B);
            $display("%b\t%b\t|\t%b\t%d", A, B, out, diff_with_act);
        end

        //Testing OR
        $display("\n\nOPCODE: 00011 (OR)");
        opcode = 3;
        $display("\033[1m\033[4m A\t\t\t\t\tB\t\t\t\t\t|\tA OR B\t\t\t\t\tDiff from true? \033[24m\033[0m");
        for (integer i = 0; i < 25; i = i+ 1) begin
            a = $urandom;
            b = $urandom;
            #20;
            diff_with_act = $signed(out) - $signed(A|B);
            $display("%b\t%b\t|\t%b\t%d", A, B, out, diff_with_act);
        end

        //Testing SLL
        $display("\n\nOPCODE: 00100 (SLL)");
        opcode = 4;
        $display("\033[1m\033[4m A\t\t\t\t\tshift_amt\t|\tA << shift_amt\t\t\tDiff from true? \033[24m\033[0m");
        for (integer i = 0; i < 32; i = i+ 1) begin
            shiftamt = i;
            a = $urandom;
            #20;
            diff_with_act = $signed(out) - $signed(A<<i);
            $display("%b\t%d\t|\t%b\t%d", A, shiftamt[4:0], out, diff_with_act);
        end

        //Testing SRA
        $display("\n\nOPCODE: 00101 (SRA)");
        opcode = 5;
        $display("\033[1m\033[4m A\t\t\t\t\tshift_amt\t|\tA >>> shift_amt\t\t\tDiff from true? \033[24m\033[0m");
        for (integer i = 0; i < 32; i = i+ 1) begin
            shiftamt = i;
            a = $urandom;
            #20;
            diff_with_act = $signed(out) - $signed($signed(A)>>>i);
            $display("%b\t%d\t|\t%b\t%d", A, shiftamt[4:0], out, diff_with_act);
        end

        //Testing SUBTRACT
        $display("\n\nOPCODE: 00001 (SUBTRACT)");
        opcode = 1;
        $display("\033[1m\033[4m A\t\tB\t\t|\to-flow\tisNotEq\tA<B\tA - B\t\tactual \033[24m\033[0m");
        for (integer i = 0; i < 25; i = i+ 1) begin
            a = $random;
            b = $random;
            #20;
            $display("%.2e\t%.2e\t|\t%d\t%d\t%d\t%.2e\t%.2e\t%b\t%b", a,b, overflow, isNotEqual, isLessThan, $signed(out), $signed(a-b), out, a-b);
        end

        a = -1000000;
        b = 255;
        #20;
        $display("%.2e\t%.2e\t|\t%d\t%d\t%d\t%.2e\t%.2e\t%b\t%b", a,b, overflow, isNotEqual, isLessThan, $signed(out), $signed(a-b), out, a-b);

        a = 2_147_483_647;
        b = -2_147_483_648;
        #20;
        $display("%.2e\t%.2e\t|\t%d\t%d\t%d\t%.2e\t%.2e\t%b\t%b", a,b, overflow, isNotEqual, isLessThan, $signed(out), $signed(a-b), out, a-b);

        a = -2_147_483_648;
        b = -1;
        #20;
        $display("%.2e\t%.2e\t|\t%d\t%d\t%d\t%.2e\t%.2e\t%b\t%b", a,b, overflow, isNotEqual, isLessThan, $signed(out), $signed(a-b), out, a-b);

        a = 858993459;
        b = 1431655765;
        #20;
        $display("%.2e\t%.2e\t|\t%d\t%d\t%d\t%.2e\t%.2e\t%b\t%b", a,b, overflow, isNotEqual, isLessThan, $signed(out), $signed(a-b), out, a-b);
        
        $finish;
    end

    // iverilog -c FileList.txt tb/alu_tb.v && vvp a.out && rm a.out
endmodule
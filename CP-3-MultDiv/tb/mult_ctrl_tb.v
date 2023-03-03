`timescale 1ns/100ps
module mult_ctrl_tb();
    // module inputs
    reg [2:0] lsb;
    // module outputs
    wire do_nothing, sub, sl;

    // instantiate the regfile
    mult_ctrl tester (do_nothing, sub, sl, lsb);

    integer i;
    initial begin
        $display("\033[1m\033[4m lsb\t|\tnada\tSub?\tSL? \033[24m\033[0m");
        for (i = 0; i < 8; i = i + 1) begin
            lsb = i[2:0];
            #20;
            $display("%b\t|\t%b\t%b\t%b", lsb, do_nothing, sub, sl);
        end
        
    end
    // iverilog -c FileList.txt tb/mult_ctrl_tb.v && vvp a.out && rm a.out
endmodule
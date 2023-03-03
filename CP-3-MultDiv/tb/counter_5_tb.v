`timescale 1ns/100ps
module counter_5_tb();
    reg clock = 0, clr = 0;
    wire [4:0] count;

    counter_5 Tester(count, clr, clock);

    integer i;
    initial begin
        $dumpfile("counter_5.vcd");
        $dumpvars(0, counter_5_tb);
        clr = 1;
        #80
        clr = 0;
        for (i = 0; i < 40; i = i + 1) begin
            $display("%b (%d)", count, count);
            #40;
        end
        $finish;
    end


    always 
    	#20 clock = !clock;

    // iverilog dffe_rev.v counter_4.v tb/counter_4_tb.v && vvp a.out && rm a.out

    endmodule
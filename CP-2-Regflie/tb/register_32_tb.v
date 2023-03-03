`timescale 1ns/100ps
module register_32_tb();
    reg clock = 0, in_enable = 0, clr = 0;
    reg [31:0] data_in;
    wire [31:0] data_out;

    register_32 Tester(data_out, data_in, clock, in_enable, clr);

    integer d_in;

    initial begin
        $dumpfile("register_32.vcd");
        $dumpvars(0, register_32_tb);
        d_in = 25;
        #5;
        assign data_in = d_in[31:0];
        #5;
        assign in_enable = 1'b1;
        #5;
        d_in = 28;
        #5;
        assign clr = 1'b0;
        #20 
        $finish;
    end

    always 
    	#5 clock = !clock;

    // iverilog -c FileList.txt register_32_tb.v && vvp a.out && rm a.out
endmodule
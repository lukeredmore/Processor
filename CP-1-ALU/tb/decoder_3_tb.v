`timescale 1 ns/100 ps
module decoder_3_tb;
    wire [2:0] in;
    wire d0, d1, d2, d3, d4, d5, d6, d7;

    integer i;

    decoder_3 decode(.d0(d0), .d1(d1), .d2(d2), .d3(d3), .d4(d4), .d5(d5), .d6(d6), .d7(d7), .in(in));

    assign {in} = i[2:0];

    initial begin
        $display("\033[1m\033[4min\t|\td0\td1\td2\td3\td4\td5\td6\td7\033[24m\033[0m");
        for (i = 0; i < 8; i = i + 1) begin
            #20;
            $display("%b\t|\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", in, d0, d1, d2, d3, d4, d5, d6, d7);
        end
        
        $finish;
    end

    // iverilog -o DC_3 decoder_3.v decoder_3_tb.v && vvp DC_3 && rm DC_3
endmodule
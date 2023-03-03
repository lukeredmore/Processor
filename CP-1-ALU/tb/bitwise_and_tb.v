`timescale 1 ns/100 ps
module bitwise_and_tb;
    wire [31:0] in0, in1, out;

    bitwise_and ba(out, in0, in1);

    integer u, v, i;

    assign {in0} = u[31:0];
    assign {in1} = v[31:0];

    initial begin
        $display("\033[1m\033[4m in0\tin1\t|\tout \033[24m\033[0m");
        for (i = 0; i < 8; i = i+ 1) begin
            u = $urandom;
            v = $urandom;
            #20;
            $display("%b\t%b\t|\t%b", in0, in1, out);
        end
        
        $finish;
    end

    // iverilog -c FileList.txt tb/bitwise_and_tb.v -Wimplicit && vvp a.out && rm a.out
endmodule
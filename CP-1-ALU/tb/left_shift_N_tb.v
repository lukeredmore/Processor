`timescale 1 ns/100 ps
module left_shift_N_tb;
    wire [31:0] in, out;

    left_shift_N  #(.N(16)) ls (out, in, 1'b1);

    integer u, i;

    assign {in} = u[31:0];
    assign {enabled} = 1;

    initial begin
        $display("\033[1m\033[4m in\t|\tout \033[24m\033[0m");
        for (i = 0; i < 8; i = i+ 1) begin
            u = $urandom;
            #20;
            $display("%b\t|\t%b", in, out);
        end
        
        $finish;
    end

    // iverilog -o LS_N left_shift_N_tb.v left_shift_N.v && vvp LS_N && rm LS_N
endmodule
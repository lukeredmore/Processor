`timescale 1 ns/100 ps
module right_shift_tb;
    wire [31:0] in, out;
    wire [4:0] amt;

    right_shift rs(out, in, amt);

    integer u, i;

    assign {in} = u[31:0];
    assign {amt} = i;

    initial begin
        $display("\033[1m\033[4m in\t|\tout \033[24m\033[0m");
        u = 32'b00101010101010101010101010101010;
        for (i = 0; i < 32; i = i+ 1) begin
            #20;
            $display("%b\t|\t%b", in, out);
        end
        
        $finish;
    end

    // iverilog -c FileList.txt tb/right_shift_tb.v && vvp a.out && rm a.out
endmodule
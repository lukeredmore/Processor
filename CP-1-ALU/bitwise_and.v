module bitwise_and(out, in0, in1);
    input [31:0] in0, in1;
    output [31:0] out;

    and single_and [31:0] (out, in0, in1);
endmodule
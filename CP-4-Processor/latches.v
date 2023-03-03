module FD(
    output [31:0] IR,
    output [31:0] PC,

    input [31:0] IR_in,
    input [31:0] PC_in,

    input clock,
    input reset);

    assign IR = IR_in;
    assign PC = PC_in;
endmodule

module DX(
    output [31:0] IR,
    output [31:0] PC,
    output [31:0] A,
    output [31:0] B,
    output X_i_type,

    input [31:0] IR_in,
    input [31:0] PC_in,
    input [31:0] A_in,
    input [31:0] B_in,

    input clock,
    input reset);

    assign IR = IR_in;
    assign PC = PC_in;

    assign A = A_in;
    assign B = B_in;

    assign X_i_type = IR[31:27] == 5;
endmodule

module XM(
    output [31:0] IR,
    output [31:0] O,
    output [31:0] B,

    input [31:0] IR_in,
    input [31:0] O_in,
    input [31:0] B_in,

    input clock,
    input reset);

    assign IR = IR_in;

    assign B = B_in;
    assign O = O_in;
endmodule

module MW(
    output [31:0] IR,
    output [31:0] O,
    output [31:0] D,

    input [31:0] IR_in,
    input [31:0] O_in,
    input [31:0] D_in,

    input clock,
    input reset);

    assign IR = IR_in;

    assign D = D_in;
    assign O = O_in;
endmodule
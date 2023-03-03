module FD(
    output [31:0] IR,
    output [31:0] PC,

    input [31:0] IR_in,
    input [31:0] PC_in,

    input clock,
    input reset);

    register_32 FD_InstructionRegister(
        .data_out(IR), 
        .data_in(IR_in), 
        .clk(~clock), // Falling edge
        .in_enable(1'b1), 
        .clr(reset));

    register_32 FD_ProgramCounter(
        .data_out(PC), 
        .data_in(PC_in), 
        .clk(~clock), // Falling edge
        .in_enable(1'b1), 
        .clr(reset));
endmodule

module DX(
    output [31:0] IR,
    output [31:0] PC,
    output [31:0] A,
    output [31:0] B,
    output ctrlX_ALUsImm,

    input [31:0] IR_in,
    input [31:0] PC_in,
    input [31:0] A_in,
    input [31:0] B_in,

    input clock,
    input reset);

    register_32 DX_InstructionRegister(
        .data_out(IR), 
        .data_in(IR_in), 
        .clk(~clock), // Falling edge
        .in_enable(1'b1), 
        .clr(reset));

    register_32 DX_ProgramCounter(
        .data_out(PC), 
        .data_in(PC_in), 
        .clk(~clock), // Falling edge
        .in_enable(1'b1), 
        .clr(reset));

    register_32 DX_ARegister(
        .data_out(A), 
        .data_in(A_in), 
        .clk(~clock), // Falling edge
        .in_enable(1'b1), 
        .clr(reset));

    register_32 DX_BRegister(
        .data_out(B), 
        .data_in(B_in), 
        .clk(~clock), // Falling edge
        .in_enable(1'b1), 
        .clr(reset));

    wire addi, sw, lw;
    instruction_decoder DX_Decoder(
        .instruction(IR),
        .addi(addi),
        .sw(sw),
        .lw(lw));

    assign ctrlX_ALUsImm = addi | sw | lw;
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

    register_32 XM_InstructionRegister(
        .data_out(IR), 
        .data_in(IR_in), 
        .clk(~clock), // Falling edge
        .in_enable(1'b1), 
        .clr(reset));

    register_32 XM_ORegister(
        .data_out(O), 
        .data_in(O_in), 
        .clk(~clock), // Falling edge
        .in_enable(1'b1), 
        .clr(reset));

    register_32 XM_BRegister(
        .data_out(B), 
        .data_in(B_in), 
        .clk(~clock), // Falling edge
        .in_enable(1'b1), 
        .clr(reset));
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

    register_32 MW_InstructionRegister(
        .data_out(IR), 
        .data_in(IR_in), 
        .clk(~clock), // Falling edge
        .in_enable(1'b1), 
        .clr(reset));

    register_32 MW_DRegister(
        .data_out(D), 
        .data_in(D_in), 
        .clk(~clock), // Falling edge
        .in_enable(1'b1), 
        .clr(reset));

    register_32 MW_ORegister(
        .data_out(O), 
        .data_in(O_in), 
        .clk(~clock), // Falling edge
        .in_enable(1'b1), 
        .clr(reset));
endmodule
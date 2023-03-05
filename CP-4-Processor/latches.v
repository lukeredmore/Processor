module FD(
    output [31:0] IR,
    output [31:0] PC,
    output ctrlD_FetchRdInsteadOfRt,
    
    input write_enable,
    input [31:0] IR_in,
    input [31:0] PC_in,

    input clock,
    input reset);

    register_32 FD_InstructionRegister(
        .data_out(IR), 
        .data_in(IR_in), 
        .clk(~clock), // Falling edge
        .in_enable(write_enable), 
        .clr(reset));

    register_32 FD_ProgramCounter(
        .data_out(PC), 
        .data_in(PC_in), 
        .clk(~clock), // Falling edge
        .in_enable(write_enable), 
        .clr(reset));

    wire sw;
    instruction_decoder DX_Decoder(
        .instruction(IR),
        .sw(sw));

    assign ctrlD_FetchRdInsteadOfRt = sw;
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
    output ctrlM_DmemWe,

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

    wire sw;
    instruction_decoder XM_Decoder(
        .instruction(IR),
        .sw(sw));
    assign ctrlM_DmemWe = sw;
endmodule

module MW(
    output [31:0] IR,
    output [31:0] O,
    output [31:0] D,
    output ctrlW_RegInToMemOut,
    output ctrlW_RegfileWe,

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

    wire lw, alu, jal, setx, addi;
    instruction_decoder MW_Decoder(
        .instruction(IR),
        .alu(alu),
        .addi(addi),
        .jal(jal),
        .setx(setx),
        .lw(lw));

    assign ctrlW_RegInToMemOut = lw;
    assign ctrlW_RegfileWe = lw || alu || jal || setx || addi;
endmodule
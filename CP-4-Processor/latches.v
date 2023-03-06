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
    output ctrlX_startMult,
    output ctrlX_startDiv,

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

    wire addi, sw, lw, mul, div;
    instruction_decoder DX_Decoder(
        .instruction(IR),
        .addi(addi),
        .sw(sw),
        .mul(mul),
        .div(div),
        .lw(lw));

    assign ctrlX_ALUsImm = addi | sw | lw;
    assign ctrlX_startMult = mul;
    assign ctrlX_startDiv = div;
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

module PW(
    output [31:0] IR,
    output [31:0] P,
    output ctrlPW_RegInToPOut,
    output ctrlPW_RegfileWe,
    output isOperating,

    input [31:0] IR_in,
    input [31:0] P_in,
    input dataReady,

    input clock,
    input reset);

    wire dataReadyDelayed;
    dffe_ref DelayReady(
        .q(dataReadyDelayed), 
        .d(dataReady), .clk(clock), .en(1'b1), .clr(1'b0));


    register_32 PW_InstructionRegister(
        .data_out(IR), 
        .data_in(IR_in), 
        .clk(~clock), // Falling edge
        .in_enable(~isOperating | dataReadyDelayed), 
        .clr(reset));

    register_32 PW_PRegister(
        .data_out(P), 
        .data_in(P_in), 
        .clk(~clock), // Falling edge
        .in_enable(1'b1), 
        .clr(reset));

    wire mul, div;
    instruction_decoder MW_Decoder(
        .instruction(IR),
        .mul(mul),
        .div(div));

    assign ctrlPW_RegInToPOut = mul | div;
    assign ctrlPW_RegfileWe = mul | div;
    assign isOperating = mul | div;
endmodule
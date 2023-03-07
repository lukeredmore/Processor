module bypass(
    input [31:0] IR_X,
    input [31:0] IR_M,
    input [31:0] IR_W,

    input [31:0] Regfile_in,
    input [31:0] M_O,
    input [31:0] M_B,
    input [31:0] X_A,
    input [31:0] X_B,

    output [31:0] DX_out_A,
    output [31:0] DX_out_B,
    output [31:0] XM_out_B
);

    wire [1:0] X_type; // 0 = R, 1 = I, 2 = JI, 3 = JII
    wire [4:0] X_Rs, X_Rd, X_Rt;
    instruction_decoder XDecoder(
        .instruction(IR_X),
        .type(X_type),
        .Rs(X_Rs),
        .Rd(X_Rd),
        .Rt(X_Rt)
    );

    wire [1:0] M_type; // 0 = R, 1 = I, 2 = JI, 3 = JII
    wire [4:0] M_Rs, M_Rd, M_Rt;
    instruction_decoder MDecoder(
        .instruction(IR_M),
        .type(M_type),
        .Rs(M_Rs),
        .Rd(M_Rd),
        .Rt(M_Rt)
    );

    wire [1:0] W_type; // 0 = R, 1 = I, 2 = JI, 3 = JII
    wire [4:0] W_Rs, W_Rd, W_Rt;
    wire W_sw;
    instruction_decoder WDecoder(
        .instruction(IR_W),
        .type(W_type),
        .sw(W_sw),
        .Rs(W_Rs),
        .Rd(W_Rd),
        .Rt(W_Rt)
    );

    assign DX_out_A = X_Rs == M_Rd && X_Rs != 0
        ? M_O :
        (X_Rs == W_Rd && X_Rs > 0 && ~W_sw // input to alu is currently being written to regfile, intercept it
            ? Regfile_in : X_A);

    assign DX_out_B = X_Rt == M_Rd && X_Rt != 0
        ? M_O :
        (X_Rt == W_Rd && X_Rs > 0 && ~W_sw
            ? Regfile_in : X_B);

    //only matters for sw instruction
    assign XM_out_B = W_Rd == M_Rd && M_Rd != 0 ? Regfile_in : M_B;
endmodule
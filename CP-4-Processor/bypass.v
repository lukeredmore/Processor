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
    wire [4:0] X_Rs, X_Rd, X_Rt, X_dep_1, X_dep_2;
    wire X_blt, X_needsAluOpA, X_needsAluOpB;
    instruction_decoder XDecoder(
        .instruction(IR_X),
        .type(X_type),
        .blt(X_blt),
        .needsAluOpA(X_needsAluOpA),
        .needsAluOpB(X_needsAluOpB),
        .dependency_reg_A(X_dep_1), // Rs
        .dependency_reg_B(X_dep_2), // Rt or Rd, depending on what is dependent
        .Rs(X_Rs),
        .Rd(X_Rd),
        .Rt(X_Rt)
    );

    wire [1:0] M_type; // 0 = R, 1 = I, 2 = JI, 3 = JII
    wire [4:0] M_Rs, M_Rd, M_Rt, M_mod;
    wire M_blt, M_modifies;
    instruction_decoder MDecoder(
        .instruction(IR_M),
        .type(M_type),
        .modifying_reg(M_mod),
        .modifies_reg(M_modifies),
        .Rs(M_Rs),
        .blt(M_blt),
        .Rd(M_Rd),
        .Rt(M_Rt)
    );

    wire [1:0] W_type; // 0 = R, 1 = I, 2 = JI, 3 = JII
    wire [4:0] W_Rs, W_Rd, W_Rt, W_mod;
    wire W_sw, W_blt, W_modifies;
    instruction_decoder WDecoder(
        .instruction(IR_W),
        .type(W_type),
        .modifying_reg(W_mod),
        .modifies_reg(W_modifies),
        .sw(W_sw),
        .blt(W_blt),
        .Rs(W_Rs),
        .Rd(W_Rd),
        .Rt(W_Rt)
    );

    assign DX_out_A = X_needsAluOpA 
        ? (X_dep_1 == M_mod & M_modifies // input to alu is currently in M stage, intercept it
            ? M_O
            : X_dep_1 == W_mod & W_modifies // input to alu is currently being written to regfile, intercept it
                ? Regfile_in
                : X_A)
        : X_A;
    
    assign DX_out_B = X_needsAluOpB
        ? (X_dep_2 == M_mod & M_modifies // input to alu is currently in M stage, intercept it
            ? M_O
            : X_dep_2 == W_mod & W_modifies // input to alu is currently being written to regfile, intercept it
                ? Regfile_in
                : X_B)
        : X_B;

    //only matters for sw instruction
    assign XM_out_B = W_Rd == M_Rd && M_Rd != 0 ? Regfile_in : M_B;
endmodule
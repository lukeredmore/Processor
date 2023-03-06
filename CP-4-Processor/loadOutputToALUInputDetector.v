module loadOutputToALUInputDetector(
    input [31:0] IR_X,
    input [31:0] IR_D,
    output loadOutputToALUInput
);

    wire [1:0] D_type; // 0 = R, 1 = I, 2 = JI, 3 = JII
    wire [4:0] D_Rs, D_Rd, D_Rt;
    wire D_sw;
    instruction_decoder DDecoder(
        .instruction(IR_D),
        .sw(D_sw),
        .type(D_type),
        .Rs(D_Rs),
        .Rd(D_Rd),
        .Rt(D_Rt)
    );

    wire [1:0] X_type; // 0 = R, 1 = I, 2 = JI, 3 = JII
    wire [4:0] X_Rs, X_Rd, X_Rt;
    wire X_lw;
    instruction_decoder XDecoder(
        .instruction(IR_X),
        .lw(X_lw),
        .type(X_type),
        .Rs(X_Rs),
        .Rd(X_Rd),
        .Rt(X_Rt)
    );

    assign loadOutputToALUInput = X_lw && (D_Rs == X_Rd || (D_Rt == X_Rd && ~D_sw));
endmodule
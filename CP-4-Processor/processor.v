/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

    // Program Counter
	wire [31:0] PC, PC_inc;
    assign address_imem = PC;
    wire stall, ctrlD_PCinToRegFileOut;
	register_32 ProgramCounter(
        // out
       .data_out(PC), 
       // in
       .data_in(q_imem[31:27] == 1 ? q_imem[26:0] : (ctrlD_PCinToRegFileOut ? data_readRegB : PC_inc)), 
       .clk(~clock), // falling edge
       .in_enable(~stall), 
       .clr(reset)
    );
    cla_32 PCIncrementer(
        // out
        .S(PC_inc), 
        // in
        .A(PC),
        .B(32'b1),
        .Cin(1'b0)
    );

    // FD Latch
    wire [31:0] IR_D, PC_D;
    wire ctrlD_FetchRdInsteadOfRt, ctrlD_insertNopInF;
    FD FDLatch(
        // Out
        .IR(IR_D),
        .PC(PC_D),
        .ctrlD_FetchRdInsteadOfRt(ctrlD_FetchRdInsteadOfRt),
        .ctrlD_PCinToRegFileOut(ctrlD_PCinToRegFileOut),
        .ctrlD_insertNopInF(ctrlD_insertNopInF),
        // In
        .write_enable(~stall),
        .IR_in(ctrlD_insertNopInF ? {32'b0} : q_imem),
        .PC_in(PC_inc),
        .clock(clock),
        .reset(reset)
    );
    assign ctrl_readRegA = IR_D[21:17]; // $rs
    assign ctrl_readRegB = ctrlD_FetchRdInsteadOfRt ? IR_D[26:22] : IR_D[16:12]; // $rd || $rt

    wire RdBeingWrittenToAhead, RtBeingWrittenToAhead, RsBeingWrittenToAhead;
    assign RdBeingWrittenToAhead = (IR_X > 0 && IR_D[26:22] == IR_X[26:22]) || (IR_M > 0 && IR_D[26:22] == IR_M[26:22]);
    assign RtBeingWrittenToAhead = (IR_X > 0 && IR_D[16:12] == IR_X[26:22]) || (IR_M > 0 && IR_D[16:12] == IR_M[26:22]);
    assign RsBeingWrittenToAhead = (IR_X > 0 && IR_D[21:17] == IR_X[26:22]) || (IR_M > 0 && IR_D[21:17] == IR_M[26:22]);

    assign stall = (ctrlD_PCinToRegFileOut && RdBeingWrittenToAhead) | ctrlX_startMult | ctrlX_startDiv | multdiv_operating | RtBeingWrittenToAhead | RsBeingWrittenToAhead;

    // DX Latch
    wire [31:0] A_X, B_X, IR_X, PC_X, ALU_out;
    wire ctrlX_ALUsImm, ctrlX_startMult,ctrlX_startDiv;
    DX DXLatch(
        // Out
        .IR(IR_X),
        .PC(PC_X),
        .A(A_X),
        .B(B_X),
        .ctrlX_ALUsImm(ctrlX_ALUsImm),
        .ctrlX_startMult(ctrlX_startMult),
        .ctrlX_startDiv(ctrlX_startDiv),
        // In
        .IR_in(stall ? {32'b0} : IR_D),
        .PC_in(PC_D),
        .A_in(data_readRegA),
        .B_in(data_readRegB),
        .clock(clock),
        .reset(reset)
    );
    wire [31:0] Imm_SE_X;
    sign_extender_17 SE_X(.extended(Imm_SE_X), .in_17(IR_X[16:0]));
    alu ALU(
        .data_operandA(A_X), 
        .data_operandB(ctrlX_ALUsImm ? Imm_SE_X : B_X), 
        .ctrl_ALUopcode(ctrlX_ALUsImm ? 5'b0 : IR_X[6:2]), 
        .ctrl_shiftamt(IR_X[11:7]),
        .data_result(ALU_out)
    );
    wire temp_ready, temp_exception;
    wire [31:0] temp_result;
    multdiv Multiplier(
        .data_operandA(A_X), 
        .data_operandB(B_X),
        .ctrl_MULT(ctrlX_startMult), 
        .ctrl_DIV(ctrlX_startDiv), 
	    .clock(clock),
        .data_resultRDY(temp_ready),
        .data_exception(temp_exception),
        .data_result(temp_result)
    );
    wire [31:0] P_PW, IR_PW;
    wire ctrlPW_RegInToPOut, ctrlPW_RegfileWe, multdiv_operating;
    PW PWLatch(
        // Out
        .IR(IR_PW),
        .P(P_PW),
        .ctrlPW_RegInToPOut(ctrlPW_RegInToPOut),
        .ctrlPW_RegfileWe(ctrlPW_RegfileWe),
        .isOperating(multdiv_operating),
        // In
        .IR_in(IR_X),
        .P_in(temp_result),
        .dataReady(temp_ready),
        .clock(clock),
        .reset(reset)
    );

    // XM Latch
    wire [31:0] O_M, B_M, IR_M;
    XM XMLatch(
        // Out
        .IR(IR_M),
        .O(O_M),
        .B(B_M),
        .ctrlM_DmemWe(wren),
        // In
        .IR_in(IR_X),
        .O_in(ALU_out),
        .B_in(B_X),
        .clock(clock),
        .reset(reset)
    );
    assign address_dmem = O_M;
    assign data = B_M;

    // MW Latch
    wire [31:0] O_W, D_W, IR_W;
    wire ctrlW_RegInToMemOut, ctrlW_RegfileWe;
    MW MWLatch(
        // Out
        .IR(IR_W),
        .O(O_W),
        .D(D_W),
        .ctrlW_RegInToMemOut(ctrlW_RegInToMemOut),
        .ctrlW_RegfileWe(ctrlW_RegfileWe),
        // In
        .IR_in(IR_M),
        .O_in(O_M),
        .D_in(q_dmem),
        .clock(clock),
        .reset(reset)
    );
    assign ctrl_writeReg = ctrlPW_RegInToPOut ? IR_PW[26:22] : IR_W[26:22];
    assign data_writeReg = ctrlPW_RegInToPOut ? P_PW : (ctrlW_RegInToMemOut ? D_W : O_W);
    assign ctrl_writeEnable = ctrlW_RegfileWe | ctrlPW_RegfileWe;

endmodule

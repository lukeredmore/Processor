module instruction_decoder(
    input [31:0] instruction,
    output alu, addi, mul, div, sw, lw, j, bne, jal, jr, blt, bex, setx);

    wire [4:0] opcode, alu_op;
    assign opcode = instruction[31:27];
    assign alu_op = instruction[6:2];

    assign alu = opcode == 0;
    assign mul = alu & alu_op == 6;
    assign div = alu & alu_op == 7;
    assign j = opcode == 1;
    assign bne = opcode == 2;
    assign jal = opcode == 3;
    assign jr = opcode == 4;
    assign addi = opcode == 5;
    assign blt = opcode == 6;
    assign sw = opcode == 7;
    assign lw = opcode == 8;
    assign bex = opcode == 22;
    assign setx = opcode == 21;

endmodule
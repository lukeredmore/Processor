# Project Checkpoint 1 (ALU)
Luke Redmore (lr197)&emsp;|&emsp;ECE 350&emsp;|&emsp;Spring 2023

This 32-bit ALU is capable of `ADD`, `SUBTRACT`, `AND`, `OR`, `SLL`, and `SRA` operations according to the specification provided in Checkpoint 1. It operates at the word-size, where all (or almost all) operations are performed on the inputs, and the operation result specified by the opcode is selected in the output mux.

The adder is a two-level carry-lookahead adder, with 4 8-bit CLAs used to implement the full, 32-bit CLA. Since CLA requires the bitwise `AND` and `OR` of A and B to use as G and P, respectively, the adder also provides the A `AND` B and A `OR` B operations to the output mux.

For subtraction operations, the same adder is used since it this ALU utilizes a twos complement number system. Because of that, A - B = A + (-B) = A + ~B + 1, so subtraction is enabled simply by providing an inverted B to the adder as well as a carry-in of 1 (instead of the usual 0).

The adder can also detect overflow for both addition and subtraction, as well as whether or not its output is zero. Some simple operations are done on these two outputs in the ALU to return values for A < B and A != B, provided the opcode is set to `SUBTRACT`.

The only two ALU ops that completely bypass the adder are `SLL` and `SRA`, which each have their own modules of a logical left barrel shifter and arithmetic right barrel shifter, respectively. Each fixed shifter (1, 2, 4, 8, and 16) was created using the Verilog `generate` function for a parameter `N` = amount to shift.
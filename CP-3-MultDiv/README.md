# Project Checkpoint 3 (Mult/Div)
Luke Redmore (lr197)&emsp;|&emsp;ECE 350&emsp;|&emsp;Spring 2023

This multiplier/divider module is capable of multiplying or dividing 2 32-bit numbers over multiple clock cycles. Only one operation may be performed at a time, which is started by asserting a `ctrl_MULT` or `ctrl_DIV` bit for multiplication or division, respectively. The `data_result` value is guaranteed to contain the correct output of the multiplication/division *only* when the `data_resultRDY` bit is asserted and `data_exception` (indicating multiplication/division overflow or division by 0) is not.

Regardless of which start signal is asserted, the expected sign of the result will be latched during the first clock cycle by comparing the signs of the operands. A positive output results from identical signs (that is, MSBs) or one of the operands (not the dividend in the case of division) being zero. 

This module is intended to run with a 50 MHz clock. However, I suspect that the gate delays may be slightly too long as incorrect answers are common when running a timing simulation in Vivado that are all correct in a functional simulation. This is something I will need to investigate further in order to run this module on real hardware, but I was told in office hours that ideal functionality is fine for now.

### Multiplication

The multiplier implements modified Booth's algorithm to complete the 32-bit multiplication in ~18 clock cycles. To start, the multiplicand (operand A) is latched to a 32-bit register and the multiplier (operand B) is latched to bits [32:1] of a 66-bit shift register with zeroes everywhere else. Using a 32-bit carry-lookahead adder (from Checkpoint 1), the doubled/not multiplicand is added/subtracted to bits [64:33] of the product register based on the output of the `mult_ctrl` module. Among other things, the `mult_ctrl` module takes the lower 3 bits of the product register and uses the logic of modified Booth's algorithm to decide how to add/subtract the multiplicand each cycle.

After each addition, the value in the product register is arithmetically shifted right by 2 and latched again. The 3 new least significant bits are passed to the `mult_ctrl` to decide how to add/subtract the multiplicand to the new upper product bits, and the cycle repeats. 

After 16 cycles, the ready bit is asserted with the correct answer as the [32:1] bits of the product register. The exception bit is asserted if there are any significant bits in the upper 32 bits of the product register or if the expected sign computed at the beginning does not match the sign of the result.

### Division
Division utilizes the same hardware as multiplication, with the exception of a `div_ctrl` module acting as the controller. This module implements 32-bit integer division using a non-restoring division algorithm in ~34 clock cycles. 

On init, the dividend (operand A) is stored in bits [32:1] of the product register (Q register), while the upper bits (A register) and bit 0 are 0. The divisor (operand B) is stored in the multiplicand (M) register. If the divisor is zero, an exception is asserted. After the expected sign of the answer is calculated based on the inputs, both inputs are set to be positive.

Each cycle, the value in AQ is logically left shifted by 1 before adding or subtracting M from A, based on whether the bit that was just shifted out (stored in AQ[64]) is 1 or 0, respectively (this is what the `div_ctrl` module is for, along with keeping count). If the result of this sum/difference is positive, the least significant bit of Q is set to 1, otherwise it's set to 0 to store the result of the trial subtraction. Then, AQ is shifted and the cycle repeats.

After 32 cycles, the ready bit is asserted and the quotient is now present in the Q register. The data result is the output of Q after sign correcting based on the expected sign. The exception bit is asserted if the sign is unexpected after this correction, as is the case in unary overflow (-2^31/-1).
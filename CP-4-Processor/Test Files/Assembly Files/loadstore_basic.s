nop # Basic ls Test with no Hazards
nop
nop
nop
nop
nop 
addi $r1, $r0, 12 # r1 = 12
addi $r3, $r0, 3 # r2 = 3
nop
nop
sw $r1, 0($r0) # MEM[0] = 12
sw $r3, 1($r0) # MEM[1] = 3
nop
nop
nop
lw $r10, 0($r0) # r10 = MEM[0] = 12
lw $r5, 1($r0) # r5 = MEM[1] = 3
nop
nop
nop
add $r11, $r10, $r1 # r11 = 24
nop
nop
nop
sub $r12, $r11, $r5 # r12 = 21
nop
nop
nop
nop


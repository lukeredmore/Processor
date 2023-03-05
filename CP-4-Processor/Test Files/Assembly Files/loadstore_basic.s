nop # Basic ls Test with no Hazards
nop
nop
nop
nop
nop 
addi $r1, $r1, 12
addi $r3, $r0, 3
nop
nop
sw $r1, 0($r0)
sw $r3, 1($r0)
nop
nop
nop
lw $r10, 0($r0)
lw $r5, 1($r0)
nop
nop
nop
add $r11, $r10, $r1
nop
nop
sub $r12, $r11, $r5
nop
nop

# r1= 12, r3 = 3, r5 = 3, $r10=12, $r11=24, r12=21

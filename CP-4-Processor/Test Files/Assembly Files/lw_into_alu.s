nop
nop
nop
nop
addi $r1, $r1, 8
sw $r1, 0($r0)
nop
nop
nop
lw $r2, 0($r0)
add $r3, $r2, $r1
sw $r3, 1($r0)
nop
nop
nop
lw $r4, 1($r0)
bne $r0, $r4, success
fail:
addi $r6, $r6, 1
j next
success:
addi $r5, $r5, 1
next:
nop
nop
nop
lw $r7, 0($r0)
bne $r0, $r7, success1
fail:
addi $r9, $r9, 1
j stop
success1:
addi $r8, $r8, 1
stop: 
nop
nop
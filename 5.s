	.text
	.globl main
main:
	li		$v0, 4
	la 		$a0, msg1
	syscall

	li      $v0, 8						# read string					
	la		$a0, string
	li		$a1, 64
    syscall
	
	li		$v0, 4
	la 		$a0, msg2
	syscall
	
	li      $v0, 8						# read pattern
	la		$a0, pattern
	li		$a1, 64
    syscall
	
	la		$a0, string
	la		$a1, pattern
	jal		find

	j 		end

find:
	addi	$sp, $sp, -4
	sw		$s0, 0($sp)
	addi	$sp, $sp, -4
	sw		$s1, 0($sp)

	move	$s0, $a0
	
	li 		$t2, 0						# initialize index = 0
	
loop1:
	lb		$t0, ($s0)
	move	$s2, $s0
	
	beq		$t0, $zero, exit1

	move 	$s1, $a1
	
loop2:
	lb		$t3, ($s2)
	lb		$t1, ($s1)
	
	bne		$t3, $t1, exit2
	beq		$t1, $zero, index
	
	addi	$s1, $s1, 1
	addi	$s2, $s2, 1
	j		loop2

exit2:
	addi 	$t1, $t1, -10
	beq		$t1, $zero, index
	addi 	$t2, $t2, 1
	addi	$s0, $s0, 1
	j		loop1
	
index:
	li		$v0, 4
	la 		$a0, msg3
	syscall
	
	li		$v0, 1
	move	$a0, $t2
	syscall
	
	j		continue
	
exit1:
	li		$v0, 4
	la 		$a0, msg4
	syscall

continue:
	li		$v0, 4
	la		$a0, newline
	syscall
	
	lw		$s1, 0($sp)
	addi	$sp, $sp, 4
	lw		$s0, 0($sp)
	addi	$sp, $sp, 4
	
	jr		$ra
	
end:
	li		$v0, 10
	syscall
	
	.data
msg1:		.asciiz "Enter string : "
msg2:		.asciiz "Enter pattern : "
msg3:		.asciiz "present at index : "
msg4:		.asciiz "not present"
newline:	.asciiz "\n"
space: 		.asciiz " "

string:		.space	64
pattern:	.space	64
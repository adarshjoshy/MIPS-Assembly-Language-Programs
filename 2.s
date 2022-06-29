	.text
	.globl main
main:
	li		$v0, 4
	la 		$a0, msg1
	syscall
	
	li		$v0, 5						# read integer a
	syscall
	move	$s0, $v0
	
	li		$v0,  4
	la		$a0, msg2
	syscall
	
	li		$v0, 5						# read integer b
	syscall
	move	$s1, $v0
	
	li		$v0,  4
	la		$a0, msg3
	syscall
	
	move 	$a0, $s0
	move	$a1, $s1
	jal 	prime

	j 		end
	
prime:
	addi	$sp, $sp, -4
	sw		$s0, 0($sp)
	addi	$sp, $sp, -4
	sw		$s1, 0($sp)	
	
	move	$t0, $a0					# initialize counter (i)
	move 	$s0, $a1
	li 		$t1, 0						# initialize flag
	
loop1:
	bgt		$t0, $s0, exit1				# check if i > b
	
	beq		$t0, 0, continue			# 0 and 1 are not prime
	beq		$t0, 1, continue
	
	li		$t1, 1						# flag = 1
	
	li		$t2, 2						# initialize counter (j)
	div		$t3, $t0, 2					# k = i / 2

loop2:
	bgt 	$t2, $t3, exit2				# check if j > k
	
	rem		$t4, $t0, $t2				# l = i % j
	beq		$t4, $zero, reset_flag		# check if l == 0
	
	addi	$t2, $t2, 1					# j = j + 1
	j		loop2
	
reset_flag:
	li		$t1, 0
	
exit2:
	beq		$t1, $zero, continue
	
	li		$v0, 1						# print i
	move	$a0, $t0
	syscall
	
	li		$v0, 4
	la		$a0, space
	syscall
	
continue:
	addi	$t0, $t0, 1					# i = i + 1			
	j		loop1
	
exit1:
	li		$v0, 4
	la		$a0, newline
	syscall
	
	lw 		$s1, 0($sp)
	addi 	$sp, $sp, 4
	lw		$s0, 0($sp)
	addi	$sp, $sp, 4
	
	jr		$ra

end:
	li		$v0, 10
	syscall

	.data
msg1:		.asciiz "Enter lower bound : "
msg2:		.asciiz "Enter upper bound : "
msg3:		.asciiz "Prime numbers : "
newline:	.asciiz "\n"
space: 		.asciiz " "
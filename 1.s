	.text
	.globl main
main:
	li		$v0, 4
	la 		$a0, msg1
	syscall
	
	li		$v0, 5				# read integer n
	syscall
	move	$s0, $v0
	
	li		$v0,  4
	la		$a0, msg2
	syscall
	
	move 	$a0, $s0
	jal 	fibonacci

	j 		end

fibonacci:
	addi	$sp, $sp, -4
	sw		$s0, 0($sp)
	move	$s0, $a0
	
	li		$t0, 0				# initialize counter (i)
	li		$t1, 0				# F1
	li 		$t2, 1				# F2
	
	blt		$s0, 0, exit		# check if n < 0
	
loop:
	addi	$t0, $t0, 1			# i = i + 1
	
	li		$v0, 1				# print F1
	move	$a0, $t1
	syscall
	
	li		$v0, 4
	la		$a0, space
	syscall
	
	add		$t3, $t1, $t2		# temp = F1 + F2
	move	$t1, $t2			# F1 = F2
	move	$t2, $t3			# F2 = temp
	
	bgt		$t1, $s0, exit		# check if F1 > n			
	j		loop
	
exit:
	li		$v0, 4
	la		$a0, newline
	syscall
	
	lw 		$s0, 0($sp)
	addi 	$sp, $sp, 4
	
	jr 		$ra

end:
	li		$v0, 10
	syscall
	
	.data
msg1:		.asciiz "Enter n : "
msg2:		.asciiz "Fibonacci series : "
newline:	.asciiz "\n"
space: 		.asciiz " "
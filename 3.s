	.text
	.globl main
main:
	li		$v0, 4
	la 		$a0, msg1
	syscall
	
	li		$v0, 5						# read integer n
	syscall
	move	$s0, $v0
	
	move 	$a0, $s0
	jal		check

	j 		end
	
check:
	addi	$sp, $sp, -4
	sw		$s0, 0($sp)
	addi	$sp, $sp, -4
	sw		$ra, 0($sp)
	
	move	$s0, $a0
	
	move	$a0, $s0
	jal		countDigit
	move	$s1, $v0
	
	move	$t2, $s0
	move 	$t3, $zero					# initialize sum = 1
	
loop:
	beq		$t2, $zero, exit
	
	move	$a0, $t2
	rem		$a0, $a0, 10				# argument: n % 10		
	move	$a1, $s1
	jal		power
	add		$t3, $t3, $v0				# sum += power(n % 10, digits)
	div		$t2, $t2, 10				# digits /= 10
	
	j 		loop
	
exit:
	beq		$s0, $t3, print_yes	

print_no:
	li		$v0,  4
	la		$a0, msg3
	syscall
	
	j 		continue
	
print_yes:
	li		$v0,  4
	la		$a0, msg2
	syscall
	
continue:
	li		$v0, 4
	la		$a0, newline
	syscall
	
	lw		$ra, 0($sp)
	addi	$sp, $sp, 4
	lw		$s0, 0($sp)
	addi	$sp, $sp, 4
	
	jr		$ra

# recursive function
countDigit:
	addi	$sp, $sp, -4
	sw		$s0, 0($sp)
	addi	$sp, $sp, -4
	sw		$ra, 0($sp)
	
	move	$s0, $a0

	beq		$s0, $zero, return			# n == 0
	
	move	$a0, $s0
	div 	$a0, $a0, 10				# argument: n / 10
	jal		countDigit
	addi	$v0, $v0, 1					# return 1 + countDigit(n / 10)
	
	j		exit_

return:
	move	$v0, $zero					# return 0
	
exit_:
	lw		$ra, 0($sp)
	addi	$sp, $sp, 4
	lw		$s0, 0($sp)
	addi	$sp, $sp, 4
	
	jr		$ra

power:
	addi	$sp, $sp, -4
	sw		$s0, 0($sp)
	addi	$sp, $sp, -4
	sw		$s1, 0($sp)
	
	move 	$s0, $a0					# base number
	move 	$t0, $a1					# exponent
	
	li		$t1, 1						# initialize result = 1
	
while:
	beq		$t0, $zero, break_			# check if exponent == 0
	
	mul		$t1, $t1, $s0				# result *= base
	sub		$t0, $t0, 1					# exponent--
	
	j		while

break_:
	move	$v0, $t1
	
	lw		$s1, 0($sp)
	addi	$sp, $sp, 4
	lw		$s0, 0($sp)
	addi	$sp, $sp, 4
	
	jr		$ra
	
end:
	li		$v0, 10
	syscall
	
	.data
msg1:		.asciiz "Enter a number : "
msg2:		.asciiz "It is a narcissistic number"
msg3:		.asciiz "It is not a narcissistic number"
newline:	.asciiz "\n"
space: 		.asciiz " "
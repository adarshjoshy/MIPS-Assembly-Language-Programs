	.text
	.globl main
main:
	li		$v0, 4
	la 		$a0, msg1
	syscall

	li      $v0, 8						# read str1					
	la		$a0, str1
	li		$a1, 64
    syscall
	
	li		$v0, 4
	la 		$a0, msg2
	syscall
	
	li      $v0, 8						# read str2
	la		$a0, str2
	li		$a1, 64
    syscall
	
	la		$a0, str1
	la		$a1, str2
	jal		strcmp

	j 		end
	
strcmp:
	move	$s0, $a0
	move 	$s1, $a1

loop:	
	lb		$t0, ($s0)
	lb		$t1, ($s1)
	
    bne     $t0, $t1, cmpne				# str1 != str2

    beq     $t1, $zero, cmpeq			# End of string i.e. str1 = str2

    addi    $s0, $s0, 1
    addi    $s1, $s1, 1
    
	j       loop
	
cmpeq:
	li		$v0,  4
	la		$a0, msg3
	syscall
	
	j continue

cmpne:
	sub		$t2, $t0, $t1
	ble		$t2, $zero, negative		# str1 < str2
	
	li		$v0,  4						# str1 > str2
	la		$a0, msg4
	syscall
	
	j continue

negative:
	li		$v0, 4
	la		$a0, msg5
	syscall
	
continue:
	li		$v0, 4
	la		$a0, newline
	syscall
	
	jr		$ra

end:
	li		$v0, 10
	syscall
	
	.data
msg1:		.asciiz "Enter 1st string : "
msg2:		.asciiz "Enter 2nd string : "
msg3:		.asciiz "strcmp : 0"
msg4: 		.asciiz "strcmp : 1"
msg5: 		.asciiz "strcmp : -1"
newline:	.asciiz "\n"
space: 		.asciiz " "

str1:       .space      64
str2:       .space      64
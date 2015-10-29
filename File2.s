# Computer Organization and Architecture Lab Autumn 2015-2016
# Group 51 
# Name: Lovekesh Garg, Roll: 13CS30020
# Name: Shubham Parekh, Roll: 13CS30022

# Program for evaluating a function

#####Data Segment##########
.data																	# Defining the string constants
	str0: .asciiz "Enter three positive integers s, m and n: "
	str1: .asciiz " "
	str2: .asciiz "\n"										
#####Code Segment###########
.text
.globl main 															# Must be global
main:
	addi $sp, $sp, -4 
	sw $fp, ($sp)	
	
	move $fp, $sp														# Storing starting location in frame pointer 

	li $v0, 4															# Printing the prompt str0
	la $a0, str0
	syscall																# Calling print

	addi $sp, $sp, -12													# allocating space for s, m, n

# Reading user input (s, m, n)
	li $v0, 5															# reading s
	syscall
	sw $v0, -4($fp)														# storing s in stack

	li $v0, 5															# reading m
	syscall
	sw $v0, -8($fp)														# storing m in stack

	li $v0, 5															# reading n
	syscall
	sw $v0, -12($fp)													# storing n in stack

# Calculating memory for 3 matrices (Total memory needed = m*n*12 )
	lw $t7, -8($fp)														# t7 contains m
	lw $t8, -12($fp)													# t8 contains n
	mul $t0, $t7, $t8													# t0 = m * n
	mul $t0, $t0, -12 													# t0 = 12*m*n (total memory required for storing 3 mXn matrices)

# Allocating memory for 3 matrices A, B, C 												
	add $sp, $sp, $t0 													# allocating memory on the stack	

# filling the arrays with the random numbers using seed
	li $t0, 1															# loop row iterator 
	# t2 contains start address of array A 
	# t3 contains start address of array B
	# t4 contains start address of array C 
	add $t2, $fp, -16													# t2 contains starting address of 1st array a								
	lw $t7, -8($fp)														# t7 conatins m
	lw $t8, -12($fp)													# t8 conatins n
	mul $t5, $t7, $t8													# t5 = m * n
	mul $t6, $t5, -4													# t6 = -4*m*n
	add $t3, $t2, $t6													# t3 contains starting address of 2nd matrix B, t3 = t2 + t6 

	add $t4, $t3, $t6													# t4 contains starting address of 2nd matrix B, t4 = t3 + t6
	lw $t7, -4($fp)														# t7 = s 
	sw $t7, 0($t2)														# A[0][0] = s
	
	addi $t6, $t7, 10													# t6 = 10 + s										
	sw $t6,0($t3)														# B[0][0] = s+10;

	lw $t8, 0($t2)														# t8 = s (t8 is random variable for array A)
	lw $t9, 0($t3)														# t9 = s+10 (t9 is random variable for array B)
# Filling the matrices A and B with random variables t8 and t9 respectively
Loop1:																	
	bge $t0, $t5, L1													# loop exit condition if(i >= m) goto L1
	mul $t1, $t0, -4													
	add $t6, $t2, $t1													# now t6 contains the address of required row of matrices

	li $t7, 330															# t7 = 330 
	mult $t8, $t7														# t8 = t8 * 330 --> X[i+1] = X[i]*330
	addi $t8, 100														# t8 = t8 + 100 --> X[i+1] += 100
	rem $t8, $t8, 2303													# t8 = t8 % 2303 --> X[i+1] %= 2303

	sw $t8, 0($t6)														# now put value of X[i+1] in matrix A

	add $t6, $t3, $t1													# t6 contains the address of element in B matrix

	li $t7, 330															# t7 = 330
	mult $t9, $t7														# t8 = t8 * 330 --> X[i+1] = X[i]*330
	addi $t9, $t9, 100													# t8 = t8 + 100 --> X[i+1] += 100
	rem $t9, $t9, 2303													# t8 = t8 % 2303 --> X[i+1] %= 2303

	sw $t9, 0($t6)														# now put value of X[i+1] in matrix B

	addi $t0, $t0, 1													# increment iterator
	b Loop1		
L1:
# we will call printMat function , so pasing its arguments using ai's
	lw $a0, -8($fp)														# first arg, a[0] = m	
	lw $a1, -12($fp)													# second arg, a[1] = n	
	move $a2, $t2														# third arg, a[2] = A (address of 1st array)
	jal printMat														# Calling printMat function

	lw $a0, -8($fp)														# first arg, a[0] = m
	lw $a1, -12($fp)													# second arg, a[1] = n	
	move $a2, $t3														# third arg, a[2] = B (address of 2nd array)
	jal printMat														# Calling printMat function

# we will call matAdd so passing arguments in it
	lw $a0, -8($fp)														# first arg, a[0] = m
	lw $a1, -12($fp)													# second arg, a[1] = n
	move $a2, $t2														# third arg, a[2] = A (address of 1st array)
	move $a3, $t3														# fourth arg, a[3] = B (address of 2nd array)
	# passing 5th argument using stack
	add $sp, $sp, -4													# allocating memory in the stack
	sw $t4, 0($sp)														# 
	jal matAdd

	lw $a0, -8($fp)
	lw $a1, -12($fp)
	move $a2, $t4
	jal printMat
		                      
L2:	
exit:
	li $v0, 10 															#system call code for exit
	syscall

printMat:
	li $t0,0
	move $t5, $a0
	move $t6, $a1
	Loop9:
		bge $t0, $t5, L9
		mul $t1, $t0, $a1
		mul $t1, $t1, -4
		add $t8, $a2, $t1

		li $t1,0
		Loop10:
			bge $t1, $t6, L10
			mul $t9, $t1, -4
			add $t8, $t8, $t9 
			li $v0,1
			lw $a0,0($t8)
			syscall

			li $v0,4
			la $a0,str1
			syscall
			addi $t1, $t1, 1
			b Loop10
		L10:
			li $v0,4
			la $a0,str2
			syscall	
			addi $t0, $t0, 1	
			b Loop9
	L9:
	li $v0,4
	la $a0,str2
	syscall	
	jr $ra


matAdd:
	li $t0,0
	move $t5, $a0
	move $t6, $a1
	lw $s0, 0($sp)

	Loop19:
		bge $t0, $t5, L19
		mul $t1, $t0, $a1
		mul $t1, $t1, -4
		add $t8, $a2, $t1
		add $s1, $a3, $t1
		add $s2, $s0, $t1

		li $t1,0
		Loop20:
			bge $t1, $t6, L20
			mul $t9, $t1, -4
			add $t8, $t8, $t9
			add $s1, $s1, $t9
			add $s2, $s2, $t9			 
			
			lw $s3, 0($t8)
			lw $s4, 0($s1)
			add $s3, $s3, $s4
			sw $s3, 0($s2)

			addi $t1, $t1, 1
			b Loop20
		L20:
			addi $t0, $t0, 1	
			b Loop19
	L19:
		jr $ra
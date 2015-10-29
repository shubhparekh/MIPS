# Computer Organization and Architecture Lab Autumn 2015-2016
# Group 51 
# Name: Lovekesh Garg, Roll: 13CS30020
# Name: Shubham Parekh, Roll: 13CS30022

# Finding 2nd Largest element in an Array

#####Data Segment##########
.data																	# Defining the string constants
	str0: .asciiz "Enter the count of elements to be read:"							
	str1: .asciiz "Enter the next element:"				
	str2: .asciiz "The second largest number among " 							
	str3: .asciiz " is "
	str4: .asciiz "," 							
#####Code Segment###########
.text
.globl main 															# Must be global
main:
	addi $sp,$sp,-4 
	sw $fp, ($sp)	
	
	move $fp, $sp															#storing starting location in frame pointer 

	li $v0,4 #string print code
	la $a0,str0 
	syscall #prints

	li $v0,5 #code for reading input integer i.e. number of elements
	syscall 
	
	addi $sp,$sp,-4 #allocating one integer space on stack to store input
	sw $v0,0($sp) 
	move $t0,$zero #iterator to read input array
	lw $t1,-4($fp) #reading number of elements which was stored in stack

	# starting of loop for reading array elements
	loop:
		bge $t0,$t1,lab0 	# loop exit condition check
		li $v0,4 		# code for printing string
		la $a0,str1
		syscall

		li $v0,5 		# code for reading input integer
		syscall
		
		addi $sp,$sp,-4 # allocating one integer space on stack
		sw $v0,0($sp)	# storing readed input to stack

		addi $t0,$t0,1 #increment iterator
		b loop  		# produces looping


	# end of loop for reding array elements


	# loading first two elements as first max
	# and second max
	lab0:
		lw $t2,-8($fp) 	# store first two
		lw $t3,-12($fp) # elements of array in registers t2 and t3
		bgt $t2,$t3,lab1 	# check to ensure t2 contents are greater than t3 else swap their values 

		move $t5,$t2 	# swapping 
		move $t2,$t3 	# regiter values 
		move $t3,$t5 	# t2 and t3 

	lab1:

		li $t0,2        # iterator starts with 2 because first two elements of array are already compared
		addi $t4,$fp,-8 # array 0th element #stores the stack address of starting element in t4. $fp-8 is done
						# because at $fp-4 number of elements in array is stored 




	# starting of loop in which the second largest element of array
	# will be computed
	loop1:
		bge $t0,$t1,lab4 	# loop exit condition 
		
		mul $t5,$t0,-4 	# these lines compute the stack address for next 
		add $t5,$t4,$t5 # element of array being iterated address is stored in t5
		
		lw $t5,0($t5)   # loading the value in stack to same register


		# compare the element of array with the first max swap if required

		bgt $t2,$t5,lab2 

		move $t6,$t2 	#swapping of values in t2 and t5
		move $t2,$t5
		move $t5,$t6
		
		lab2:

			# compare the updated element with second max and swap if required
			bgt $t3,$t5,lab3	# condition check for requirement of swapping

			move $t6,$t3 	# swapping of t3 and t5 regiter values
			move $t3,$t5
			move $t5,$t6

			#

		lab3:
			addi $t0,$t0,1  #increment of iterator
					
		b loop1           	# produces looping

# end of loop


	lab4:
		li $v0, 4 		# code for printing string
		la $a0,str2	
		syscall			# prints string


		# loop for printing array elements

		move $t0,$zero	# initializing of iterator 
		add $t5,$t1,-1  # print n-1 elements with comma .Then print last element separately outside loop without comma 

	loop2:
		bge $t0,$t5,lab5 # loop exit condition

		mul $t6,$t0,-4 	# computing of next array element address in stack by 
		add $t6,$t4,$t6 # use of previously stored 0th element address in t4
		
		lw $t6,0($t6)   # loading of value from stack
		
		li $v0, 1 		# print integer code
		move $a0,$t6
		syscall

		li $v0, 4 		# print 
		la $a0,str4
		syscall

		addi $t0,$t0,1 	# increments iterator


		b loop2 			# produces looping

	# end of loop

	lab5:
		# print last element
		mul $t6,$t0,-4
		add $t6,$t4,$t6

		lw $t6,0($t6)
		
		li $v0, 1
		move $a0,$t6
		syscall




		li $v0, 4 		# print string code
		la $a0,str3
		syscall

		li $v0, 1 		# printing 2nd largest
		move $a0,$t3	# element stored in t3 
		syscall

		move $sp, $fp
		lw $fp,($sp)
		add $sp,$sp,4

exit:
	li $v0, 10 															#system call code for exit
	syscall

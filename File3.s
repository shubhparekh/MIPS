# Computer Organization and Architecture Lab Autumn 2015-2016
# Group 51 
# Name: Lovekesh Garg, Roll: 13CS30020
# Name: Shubham Parekh, Roll: 13CS30022

                              # Assignment 3

#    | C11  C12 |    =    |  A11  A12  | * |  B11  B12  |  
#    | C21  C22 |         |  A21  A22  |   |  B21  B22  | 
#    C11 = A11 * B11 + A12 * B21
#    C12 = A11 * B12 + A12 * B22
#    C21 = A21 * B11 + A22 * B21
#    C22 = A21 * B12 + A22 * B22

#####Data Segment##########
.data                                                                                     # Defining the string constants
     str0: .asciiz "Enter two positive integers s, b: "
     str1: .asciiz " "
     str2: .asciiz "\n"                                               
#####Code Segment###########
.text
.globl main                                                                          # Must be global
main:
     addi $sp, $sp, -4 
     sw $fp, ($sp)  
     
     move $fp, $sp                                                                   # Storing starting location in frame pointer 

     li $v0, 4                                                                       # Printing the prompt str0
     la $a0, str0
     syscall                                                                              # Calling print

     addi $sp, $sp, -8                                                              # allocating space for s, m, n

# Reading user input (s, b)
     li $v0, 5                                                                       # reading s
     syscall
     sw $v0, -4($fp)                                                                      # storing s in stack

     
     li $v0, 5                                                                       # reading b
     syscall
     li $t1,1
     sll $t1, $t1, $v0
     sw $t1, -8($fp)
     
# Calculating memory for 3 matrices (Total memory needed = m*n*12 )
     lw $t7, -8($fp)                                                                # t8 contains n
     mul $t0, $t7, $t7                                                               # t0 = n * n
     mul $t0, $t0, -12                                                               # t0 = 12*n*n (total memory required for storing 3 mXn matrices)

# Allocating memory for 3 matrices A, B, C                                                          
     add $sp, $sp, $t0                                                               # allocating memory on the stack   

# filling the arrays with the random numbers using seed
     li $t0, 1                                                                       # loop iterator i=1
     # t2 contains start address of array A 
     # t3 contains start address of array B
     # t4 contains start address of array C 
     add $t2, $fp, -12                                                               # t2 contains starting address of 1st array A                                        
     lw $t7, -8($fp)                                                                 # t7 contains n
     mul $t5, $t7, $t7                                                               # t5 = n * n
     mul $t6, $t5, -4                                                                # t6 = -4*n*n
     add $t3, $t2, $t6                                                               # t3 contains starting address of 2nd matrix B, t3 = t2 + t6 

     add $t4, $t3, $t6                                                               # t4 contains starting address of 3rd matrix C, t4 = t3 + t6
     lw $t7, -4($fp)                                                                 # storing seed s in A[0][0]
     sw $t7, 0($t2)
     addi $t6, $t7, 10
     sw $t6,0($t3)                                                                   # storing other seed s+10 in B[0][0]

     lw $t8, 0($t2)                                                                       # loading A[0][0] in t8 and C[0][0] in t9 
     lw $t9, 0($t3)

Loop1:
     bge $t0, $t5, L1                                                                # exit loop i>=m*n t5 contains m * n    
     mul $t1, $t0, -4                                                                # 
     add $t6, $t2, $t1                                                               # t6 contains address of Xi for A matrix

     li $t7, 330


                                                                           #                   
     mul $t8, $t8, $t7                                                               #         
     addi $t8, $t8, 100                                                  #
     rem $t8, $t8, 2303                                                  # t8 contains value of Xi which is calculated
                                                                                          # using (X)i-1 present in same register
     sw $t8, 0($t6)                                                                       # filling in array

     add $t6, $t3, $t1                                                               # t6 contains address of Xi for B matrix 

     li $t7, 330                                                                     #    
     mul $t9, $t9, $t7                                                               #
     addi $t9, $t9, 100                                                              #         
     rem $t9, $t9, 2303                                                              # t9 contains value of Xi which is calculated     
                                                                                          # using (X)i-1 present in same register 
     sw $t9, 0($t6)                                                                       # filling in array

     addi $t0, $t0, 1                                                                # incrementing iterator
     b Loop1                                                                         #              
L1:                                                                                  #    
# printing matrix A
     lw $a0, -8($fp)                                                                 # loading n as second argument 
     move $a1, $t2                                                                   # start address of matrix A as third argument     
     jal printMat                                                                    # call to function  

# printing matrix B 
     lw $a0, -8($fp)                                                                # loading n as second argument     
     move $a1, $t3                                                                   # start address of matrix B as third argument     
     jal printMat                                                                    # call to function


# initialize matrix C to zero
     lw $a0, -8($fp)                                                                 # loading n as second argument 
     move $a1, $t4                                                                   # start address of matrix C as third argument     
     jal initMat                                                           #         




# void mul(mat A, mat B, mat C,int size, int ai,int aj, int bi,int bj, int ci,int cj)
     move $a0, $t2 # first arg A
     move $a1, $t3 # second arg B
     move $a2, $t4 # C
     lw   $a3, -8($fp) # n
     addi $sp,$sp,-24 # 6 arg on stack ai,aj,bi,bj,ci,cj,
     li $s0,0            # all arg ai to cj are 0
     sw $s0,20($sp)
     sw $s0,16($sp)
     sw $s0,12($sp)
     sw $s0,8($sp)
     sw $s0,4($sp)
     sw $s0,0($sp)
     lw $s7,-8($fp)
     jal matMul


 


# printing matrix C
     lw $a0, -8($fp)                                                                 # loading n as second argument 
     move $a1, $t4                                                                   # start address of matrix C as third argument     
     jal printMat                                                           #         
          
L2:                                                                                       #
exit:                                                                                     #
     li $v0, 10                                                                           # system call code for exit
     syscall                                                                         #         





printMat:                                                                                 #
     li $t0,0                                                                        # outer iterator i=0
     move $t5, $a0                                                                   # t5 has m
     move $t6, $a0                                                                   # t6 has n
     Loop9:                                                                               # 
          bge $t0, $t5, L9                                                           # if i>=m break loop
          mul $t1, $t0, $t5                                                          # t1 has n * i           
          mul $t1, $t1, -4                                                           # t1 has -4ni  
          add $t8, $a1, $t1                                                          # t8 contains A[i]            
     
          li $t1,0                                                                   # inner iterator    
          Loop10:                                                                    #    
               bge $t1, $t6, L10                                                     # if j>=n break loop     
               mul $t9, $t1, -4                                                      # 
               add $t7, $t8, $t9                                                     # t7 has A[i][j]
               li $v0,1                                                              # print int code
               lw $a0,0($t7)                                                         # prints A[i][j]      
               syscall                                                               #

               li $v0,4                                                              # prints space
               la $a0,str1                                                           #
               syscall                                                               #

               addi $t1, $t1, 1                                                      # increment iterator j   
               b Loop10                                                              #    
          L10:                                                                            #    
               li $v0,4                                                              # prints newline
               la $a0,str2                                                           #
               syscall                                                                    #

               addi $t0, $t0, 1                                                      # increment iterator i   
               b Loop9                                                               #         
     L9:                                                                             #
     li $v0,4                                                                        # prints newline              
     la $a0,str2                                                                          #         
     syscall                                                                              #

     jr $ra                                                                               # return  

matMul:

bne $a3,1,L19
# C[ci][cj] += A[ai][aj] * B[bi][bj];

lw $s1,20($sp)
lw $s2,16($sp)
lw $s3,12($sp)
lw $s4,8($sp)
lw $s5,4($sp)
lw $s6,0($sp)
move $t5, $s7                                                                   # t5 has m


mul $t1, $s1, $t5                                                          # t1 has n * i           
mul $t1, $t1, -4                                                           # t1 has -4ni  
add $t7, $a0, $t1

mul $t1, $s2, -4                                                      # 
add $t7, $t7, $t1

#
mul $t1, $s3, $t5                                                          # t1 has n * i           
mul $t1, $t1, -4                                                           # t1 has -4ni  
add $t8, $a1, $t1

mul $t1, $s4, -4                                                      # 
add $t8, $t8, $t1

#
mul $t1, $s5, $t5                                                          # t1 has n * i           
mul $t1, $t1, -4                                                           # t1 has -4ni  
add $t9, $a2, $t1

mul $t1, $s6, -4                                                      # 
add $t9, $t9, $t1

lw $t6,0($t7)
lw $t5,0($t8)
mul $t6,$t6,$t5
lw $t5,0($t9)
add $t6,$t6,$t5
sw $t6, 0($t9)

addi $sp,$sp,24
jr $ra

L19:


addi $sp,$sp,-8
sw $s0,0($sp)
div $s0, $a3, 2
sw $ra,4($sp)

# 8 function calls recursive
#mul( A, B, C, k, ai, aj  , bi  , bj, ci, cj );
#mul( A, B, C, k, ai, aj+k, bi+k, bj, ci, cj );

#mul( A, B, C, k, ai, aj  , bi  , bj+k, ci, cj+k );
#mul( A, B, C, k, ai, aj+k, bi+k, bj+k, ci, cj+k );

#mul( A, B, C, k, ai+k, aj  , bi  , bj, ci+k, cj );
#mul( A, B, C, k, ai+k, aj+k, bi+k, bj, ci+k, cj );

#mul( A, B, C, k, ai+k, aj  , bi  , bj+k, ci+k, cj+k);
#mul( A, B, C, k, ai+k, aj+k, bi+k, bj+k, ci+k, cj+k);

#1
addi $sp,$sp,-4
sw $a3,0($sp)

move $a3,$s0

addi $sp,$sp,-24
lw $s1,56($sp)
sw $s1,20($sp)
lw $s1,52($sp)
sw $s1,16($sp)
lw $s1,48($sp)
sw $s1,12($sp)
lw $s1,44($sp)
sw $s1,8($sp)
lw $s1,40($sp)
sw $s1,4($sp)
lw $s1,36($sp)
sw $s1,0($sp)

jal matMul


lw $a3,0($sp)
addi $sp,$sp,4

#2
addi $sp,$sp,-4
sw $a3,0($sp)

move $a3,$s0

addi $sp,$sp,-24

lw $s1,56($sp)
sw $s1,20($sp)

lw $s1,52($sp)
add $s1,$s1,$s0
sw $s1,16($sp)

lw $s1,48($sp)
add $s1,$s1,$s0
sw $s1,12($sp)

lw $s1,44($sp)
sw $s1,8($sp)

lw $s1,40($sp)
sw $s1,4($sp)

lw $s1,36($sp)
sw $s1,0($sp)

jal matMul


lw $a3,0($sp)
addi $sp,$sp,4

#3
addi $sp,$sp,-4
sw $a3,0($sp)

move $a3,$s0

addi $sp,$sp,-24

lw $s1,56($sp)
sw $s1,20($sp)

lw $s1,52($sp)
sw $s1,16($sp)

lw $s1,48($sp)
sw $s1,12($sp)

lw $s1,44($sp)
add $s1,$s1,$s0
sw $s1,8($sp)

lw $s1,40($sp)
sw $s1,4($sp)

lw $s1,36($sp)
add $s1,$s1,$s0
sw $s1,0($sp)

jal matMul


lw $a3,0($sp)
addi $sp,$sp,4

#4
addi $sp,$sp,-4
sw $a3,0($sp)

move $a3,$s0

addi $sp,$sp,-24

lw $s1,56($sp)
sw $s1,20($sp)

lw $s1,52($sp)
add $s1,$s1,$s0
sw $s1,16($sp)

lw $s1,48($sp)
add $s1,$s1,$s0
sw $s1,12($sp)

lw $s1,44($sp)
add $s1,$s1,$s0
sw $s1,8($sp)

lw $s1,40($sp)
sw $s1,4($sp)

lw $s1,36($sp)
add $s1,$s1,$s0
sw $s1,0($sp)

jal matMul


lw $a3,0($sp)
addi $sp,$sp,4

#5
addi $sp,$sp,-4
sw $a3,0($sp)

move $a3,$s0

addi $sp,$sp,-24

lw $s1,56($sp)
add $s1,$s1,$s0
sw $s1,20($sp)

lw $s1,52($sp)
sw $s1,16($sp)

lw $s1,48($sp)
sw $s1,12($sp)

lw $s1,44($sp)
sw $s1,8($sp)

lw $s1,40($sp)
add $s1,$s1,$s0
sw $s1,4($sp)

lw $s1,36($sp)
sw $s1,0($sp)

jal matMul


lw $a3,0($sp)
addi $sp,$sp,4

#6
addi $sp,$sp,-4
sw $a3,0($sp)

move $a3,$s0

addi $sp,$sp,-24

lw $s1,56($sp)
add $s1,$s1,$s0
sw $s1,20($sp)

lw $s1,52($sp)
add $s1,$s1,$s0
sw $s1,16($sp)

lw $s1,48($sp)
add $s1,$s1,$s0
sw $s1,12($sp)

lw $s1,44($sp)
sw $s1,8($sp)

lw $s1,40($sp)
add $s1,$s1,$s0
sw $s1,4($sp)

lw $s1,36($sp)
sw $s1,0($sp)

jal matMul


lw $a3,0($sp)
addi $sp,$sp,4

#7
addi $sp,$sp,-4
sw $a3,0($sp)

move $a3,$s0

addi $sp,$sp,-24

lw $s1,56($sp)
add $s1,$s1,$s0
sw $s1,20($sp)

lw $s1,52($sp)
sw $s1,16($sp)

lw $s1,48($sp)
sw $s1,12($sp)

lw $s1,44($sp)
add $s1,$s1,$s0
sw $s1,8($sp)

lw $s1,40($sp)
add $s1,$s1,$s0
sw $s1,4($sp)

lw $s1,36($sp)
add $s1,$s1,$s0
sw $s1,0($sp)

jal matMul


lw $a3,0($sp)
addi $sp,$sp,4

#8
addi $sp,$sp,-4
sw $a3,0($sp)

move $a3,$s0

addi $sp,$sp,-24

lw $s1,56($sp)
add $s1,$s1,$s0
sw $s1,20($sp)

lw $s1,52($sp)
add $s1,$s1,$s0
sw $s1,16($sp)

lw $s1,48($sp)
add $s1,$s1,$s0
sw $s1,12($sp)

lw $s1,44($sp)
add $s1,$s1,$s0
sw $s1,8($sp)

lw $s1,40($sp)
add $s1,$s1,$s0
sw $s1,4($sp)

lw $s1,36($sp)
add $s1,$s1,$s0
sw $s1,0($sp)

jal matMul


lw $a3,0($sp)
addi $sp,$sp,4

#


lw $s0, 0($sp)
addi $sp, $sp, 4

lw $ra,0($sp)
addi $sp, $sp, 4

addi $sp,$sp,24


jr $ra




initMat:                                                                                 #
     li $t0,0                                                                        # outer iterator i=0
     move $t5, $a0                                                                   # t5 has m
     move $t6, $a0                                                                   # t6 has n
     Loop29:                                                                               # 
          bge $t0, $t5, L29                                                           # if i>=m break loop
          mul $t1, $t0, $t5                                                          # t1 has n * i           
          mul $t1, $t1, -4                                                           # t1 has -4ni  
          add $t8, $a1, $t1                                                          # t8 contains C[i]            
     
          li $t1,0                                                                   # inner iterator    
          Loop30:                                                                    #    
               bge $t1, $t6, L30                                                     # if j>=n break loop     
               mul $t9, $t1, -4                                                      # 
               add $t7, $t8, $t9                                                     # t7 has C[i][j]
               
               sw $zero,0($t7) # C[i][j] becomes 0
               addi $t1, $t1, 1                                                      # increment iterator j   
               b Loop30                                                              #    
          L30:                                                                            #    
               
               addi $t0, $t0, 1                                                      # increment iterator i   
               b Loop29                                                               #         
     L29:                                                                             #
     
     jr $ra                                                                               # return  

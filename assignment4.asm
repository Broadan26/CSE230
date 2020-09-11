#Brandon
#Assignment4
#30 September

.data
.asciiz "Enter a number: "	#0x10010000 to 0x10010011
.asciiz "The sum is: "		#0x10010011 to 0x1001001D
.asciiz "\n"			#0x1001001E to 0x10010020

.text
.globl main

#Driver Program Provided
main:
	addi $a0, $0, 2		#set minimum value of loop to 2
	addi $a1, $0, 5		#set maximum value of loop to 5
	jal getinput		#get positive number for the loop
	addi $s0, $v0, 0	#save input value
	
repeat:
	beq $s0, $0, end	#while there are more repeats
	
	addi $a0, $0, 1		#set minimum value to 1
	addi $a1, $0, 15	#set maximum value to 15
	jal getinput		#get value from 1 ... 15
	ori $s1, $v0, 0		#save the result
	
	addi $a0, $0, 3		#set minimum value to 4
	addi $a1, $0, 18	#set maximum value to 18
	jal getinput		#get value from 4 ... 18
	
	ori $a1, $v0, 0		#set second parameter for printsum
	ori $a0, $s1, 0		#set the first parameter for printsum
	jal printsum		#call function to print sum of input
	
	addi $s0, $s0, -1	#decrement counter
	j repeat		#do the loop again
	
end:
	ori $v0, $0, 10		#Set command to stop program
	syscall			#End Program
	
#getinput
#Returns a value in $v0
#$sp is used to temporarily store data in stack
#$t0, $t1 are used to compare inputs
#$a0 and $a1 are returned intact
#$ra used to return to main code
getinput:
	addi $sp, $sp, -8	#Shift the stack pointer over 8 bytes
repeat2:	
	sw $a0, 0($sp)		#Save $a0 to memory
	sw $a1, 4($sp)		#Save $a1 to memory
	
	addi $v0, $0, 4		#Load print string into syscall
	lui $a0, 0x1001		#Load the base address of the string to $a0
	syscall			#Print the word
	
	addi $v0, $0, 5		#Load read int into syscall
	syscall			#Read Integer
	
	lw $a0, 0($sp)		#Recover value for $a0
	lw $a1, 4($sp)		#Recover value for $a1
	
	slt $t0, $v0, $a0	#If $v0 is >= $a0 return a 0 to $t0
	slt $t1, $a1, $v0	#If $a1 is >= $v0 return a 0 to $t1
	bne $t0, $t1, repeat2	#If the value entered doesn't work, jump to beginning
	
	addi $sp, $sp, 8	#Recover $sp value
	addi $t0, $0, 0		#Reset $t1
	addi $t1, $0, 0		#Reset $t2
	
	jr $ra			#Return to spot in main code
	
#printsum
#Prints the sum of $a0 and $a1 from $a0
#$sp is used to temporarily store data in stack
#$ra is used to return to main code
printsum:
	addi $sp, $sp, -8	#Shift the stack pointer over 8 bytes
	sw $a0, 0($sp)		#Save $a0 to memory
	sw $a1, 4($sp)		#Save $a1 to memory

	addi $v0, $0, 4		#Load print string into syscall
	lui $a0, 0x1001		#Load the base address of the string to $a0
	addi $a0, $a0, 17	#Locate string to call in memory
	syscall			#Print the string
	
	lw $a0, 0($sp)		#Recover the value in $a0
	add $a0, $a0, $a1	#Sum the two values together and store in $a0
	addi $v0, $0, 1		#Load print integer into syscall
	syscall			#Print the integer value
	
	addi $v0, $0, 4		#Load print string into syscall
	lui $a0, 0x1001		#Load the base address of the string to $a0
	addi $a0, $a0, 30	#Locate string to call in memory
	syscall			#Print the string newline
	
	lw $a0, 0($sp)		#Recover value for $a0
	lw $a1, 4($sp)		#Recover value for $a1
	addi $sp, $sp, 8	#Recover the $sp value
	addi $v0, $0, 0		#Reset $v0
	
	jr $ra			#Return to spot in main code

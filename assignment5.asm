#Brandon
#Assignment5
#8 October

.data
.asciiz "Brandon Pazzazz" 	#0x10010000 to 0x1001000F 
.asciiz "\n"			#0x10010010 to 0x10010011
.asciiz "Enter a number: "	#0x10010012 to 0x10010022
.space 40			#0x10010024 Reserve 4 bytes * 10 spaces for array 40
.asciiz " Sum of Evens: "	#0x1001004C

.text
.globl main

#Driver Program
main:
	addi $v0, $0, 4		#Load print string into syscall
	lui $a0, 0x1001		#Load the base address of the string to $a0
	syscall			#Print string "Brandon Pazzazz"
	addi $a0, $a0, 16	#Load base address of string to $a0
	syscall			#Print the string "\n"
	
	addi $a0, $a0, 20	#Move $a0 to the array start
	jal readvals		#Call function readvals
	
	jal print		#Call function print
	
	ori $v0, $0, 10		#Set command to stop program
	syscall			#End Program

#ReadVals
#Takes 1 parameter $a0 as an address to the start of array & returns the address
#Reads values into an array of size 10	
#$t0 holds the address of the array start and iterates thru it
#$t1 holds the address of array end
#$t2 is used to check condition of loop
#$t3 is used to store an extra copy of $a0
readvals:
	addi $sp, $sp, -4	#Shift the stack pointer 4 bytes
	sw $a0, 0($sp)		#Save the array start address to the stack
	add $t0, $a0, $0	#Store array start in $t0
	addi $t1, $t0, 40	#Store top end of array in $t1
	add $t3, $t0, $0	#Copy address of start of array to $t3
	
top1:				#Top of Loop
	slt $t2, $t0, $t1	#If the current spot in array < array + 40 keep going
	beq $t2, $0, end1	#Break if outside the array
	
	addi $a0, $t3, -18	#Shift to address prompting number input
	addi $v0, $0, 4		#Load print string into syscall
	syscall			#Print string "Enter a number: "
	
	addi $v0, $0, 5		#Load read integer into syscall
	syscall			#Read Integer
	
	sw $v0, 0($t0)		#Store the user input in the array
	add $t0, $t0, 4		#Shift the pointer over 1 spot in array
	j top1			#Jump to top of the loop
	
end1:				#End of Loop
	lw $a0, 0($sp)		#Recover array start from stack
	addi $sp, $sp, 4	#Recover the $sp value
	and $t0, $0, $0		#Reset $t0
	and $t1, $0, $0		#Reset $t1
	and $t2, $0, $0		#Reset $t2
	and $t3, $0, $0		#Reset $t3
	jr $ra			#Return to spot in main code

#isEven
#Takes 1 parameter $a0 as an integer value
#Checks if a value is even
#Returns $v0 as result, 1 is even, 0 is odd
isEven:
	andi $v0, $a0, 1	#Check if last bit is 1 or 0
	addi $t0, $0, 1		#Set $t0 to 1
	slt $v0, $v0, $t0	#If $v0 equal to 1, set to 0, otherwise set to 1
	add $t0, $0, $0		#Reset $t0
	jr $ra			#Return to print function

#Print
#Takes 1 parameter $a0 as an address to the start of array
#Prints values from an array of size 10
#$t0 holds the address of the array start and iterates thru it
#$t1 holds the address of array end
#$t2 is used to check condition of loop
#$s0 holds the sum of the even values
print:
	addi $sp, $sp, -8	#Shift the stack pointer 8 bytes
	sw $a0, 0($sp)		#Save the array start address to the stack
	sw $ra, 4($sp)		#Save the return address to the stack
	
	add $t0, $a0, $0	#Store array start in $t0
	addi $t1, $t0, 40	#Store top end of array in $t1
	add $t3, $t0, $0	#Copy address of start of array to $t3
	
top2:				#Top of Loop
	slt $t2, $t0, $t1	#If the current spot in array < array + 40 keep going
	beq $t2, $0, end2	#Break if outside the array
	
	addi $sp, $sp, -16	#Shift stack pointer 16 bytes
	sw $t0, 0($sp)		#Store $t0 on stack
	sw $t1, 4($sp)		#Store $t1 on stack
	sw $t2, 8($sp)		#Store $t2 on stack
	sw $t3, 12($sp)		#Store $t3 on stack
	lw $a0, 0($t0)		#Assign value in array to $a0 to pass to isEven
	
	jal isEven		#Call function isEven
	
	lw $t3, 12($sp)		#Recover $t3 from stack
	lw $t2, 8($sp)		#Recover $t2 from stack
	lw $t1, 4($sp)		#Recover $t1 from stack
	lw $t0, 0($sp)		#Recover $t0 from stack
	addi $sp, $sp, 16	#Recover $sp value
	
	beq $v0, $0, next	#Jump to next if not even
	add $s0, $s0, $a0	#Sum = Sum + Even Value
	
next:				#Skip even summation for odds
	add $t0, $t0, 4		#Shift the pointer over 1 spot in array
	j top2			#Jump to top of the loop
	
end2:				#End of Loop	
	lw $a0, 0($sp)		#Recover array start from stack
	lw $ra, 4($sp)		#Recover the return address from stack
	addi $sp, $sp, 8	#Recover the $sp value
	
	addi $v0, $0, 4		#Load print String into syscall
	addi $a0, $a0, 40	#Locate start of string
	syscall			#Print string "Sum of Evens: "
	addi $v0, $0, 1		#Load command to print integer
	add $a0, $s0, $0	#Load the sum into $a0 to print
	syscall			#Print the sum of even values
	
	and $t0, $0, $0		#Reset $t0
	and $t1, $0, $0		#Reset $t1
	and $t2, $0, $0		#Reset $t2
	and $t3, $0, $0		#Reset $t3
	and $s0, $0, $0		#Reset $s0
	
	jr $ra			#Return to spot in main code

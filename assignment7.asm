#Brandon
#Assignment7
#31 October

.data
.asciiz "Brandon Pazzazz" 	#0x10010000 to 0x1001000F 
.asciiz "\n"			#0x10010010 to 0x10010011
.asciiz "Enter a number: "	#0x10010012 to 0x10010022
.space 20			#0x10010024 Reserve 4 bytes * 5 spaces for array 20

.text
.globl main

#Driver Program
main:
	addi $v0, $0, 4		#Load command to print string
	lui $a0, 0x1001		#Store address of name string in $a0 to print
	syscall			#Print string with name
	addi $a0, $a0, 16	#Store address of newline in $a0
	syscall			#Print a string with newline
	addi $s0, $0, 3		#Store number of times to run loop
	add $s1, $0, $0		#Set $s1 to 0, counter for loop
	
top:				#Top of driver loop
	beq $s0, $s1, end	#If loop has run 3 times, jump to end
	addi $a0, $0, 5		#Set $a0 to 5 for arith parameter
	jal arith		#Jump to arithmetic function
	addi $s1, $s1, 1	#Increment $s1 by 1
	j top			#Return to top of loop
	
end:				#End of driver loop
	addi $v0, $0, 10	#Store command to end program
	syscall			#End program

#Reads values from the user and stores them in an array
#Parameters: $a0 holds number of items to work with
#$t0 holds number of loop runs, $t1 holds loop counter, $t2 holds array start
#Returns no values
arith:
	addi $sp, $sp, -4	#Shift the stack pointer over 4 bytes
	sw $ra, 0($sp)		#Store the $ra in the stack 
	
	add $t0, $a0, $0	#Store number of times to run loop
	add $t1, $0, $0		#Set $t1 to 0, counter for loop
	lui $t2, 0x1001		#Store address of 0x10010000 in $t2
	addi $t2, $t2, 36	#$t2 holds the start of the array
	
topA:				#Top of Loop
	beq $t0, $t1, endA	#If loop has run 5 times, jump to endA
	
	addi $v0, $0, 4		#Load command to print string
	lui $a0, 0x1001		#Store address of 0x10010000 in $a0
	addi $a0, $a0, 18	#Store address of string enter num in $a0
	syscall			#Print string with enter num
	
	addi $v0, $0, 5		#Store command to read integer in $v0
	syscall			#Read integer from user
	
	sw $v0, 0($t2)		#Store the value in the array
	addi $t2, $t2, 4	#Shift array index over 4 bytes / 1 spot
	addi $t1, $t1, 1	#Increment $t1 by 1
	j topA			#Return to top of loop
endA:
	addi $t2, $t2, -20	#Reset the array to the beginning
	add $a1, $0, $t2	#Set $a1 to hold the array start
	add $a2, $0, $t0	#Set $a2 to hold array size
	jal sum			#Jump to sum function
	
	add $v0, $0, 4		#Store command to print string
	lui $a0, 0x1001		#Load address 0x10010000 into $a0
	addi $a0, $a0, 16	#Store address of newline in $a0
	syscall			#Print a string with newline
	
	add $a1, $0, $v1	#Store the sum in $a1
	add $v1, $0, $0		#Empty $v0
	jal average		#Jump to average function
	
	add $v0, $0, 4		#Store command to print string
	lui $a0, 0x1001		#Load address 0x10010000 into $a0
	addi $a0, $a0, 16	#Store address of newline in $a0
	syscall			#Print a string with newline
	
	lw $ra, 0($sp)		#Recover the return address from the stack
	addi $sp, $sp, 4	#Reset the stack pointer
	jr $ra			#Return to spot in main code

#Calculates the sum of an array and prints it
#Parameters: $a1 holds array start, $a2 holds array size
#$t0 is the loop counter, $t1 iterates thru the array
#Returns the sum of the array in $v1
sum:
	add $t0, $0, $0		#Set $t0 to 0 for loop counter
	add $t1, $0, $a1	#Set $t1 to hold the array start
topS:	
	beq $t0, $a2, endS	#Jump to end
	lw $t2, 0($t1)		#Load value from array to $t2
	add $v1, $v1, $t2	#Add loaded value to $v1
	addi $t1, $t1, 4	#Shift array index over 4 bytes / 1 spot
	addi $t0, $t0, 1	#Increment $t0
	j topS			#Return to the top of the loop
endS:
	addi $v0, $0, 1		#Store command print integer into $v0
	add $a0, $0, $v1	#Store sum to print
	syscall			#Print the sum of the array
	jr $ra			#Return to arith function

#Calculates the average as an integer and as a single point float
#Parameters: $a1 holds the sum, $a2 holds the array size
#Returns no values
average:
	div $a1, $a2		#Divide the sum by the number of elements in the array
	mflo $a0		#Store the quotient in $a0
	addi $v0, $0, 1		#Store command to print integer
	syscall			#Print the average (int)
	
	add $v0, $0, 4		#Store command to print string
	lui $a0, 0x1001		#Load address 0x10010000 into $a0
	addi $a0, $a0, 16	#Store address of newline in $a0
	syscall			#Print a string with newline
	
	mtc1 $a1, $f5		#Move sum to coprocessor
	cvt.s.w $f4, $f5	#Convert sum from int to float
	mtc1 $a2, $f7		#Move array size to coprocessor
	cvt.s.w $f6, $f7	#Convert array size from int to float
	
	div.s $f12, $f4, $f6	#Divide sum by array size, store result in $f12
	add $v0, $0, 2		#Load command to print float
	syscall			#Print the average (float)
	
	jr $ra			#Return to arith function

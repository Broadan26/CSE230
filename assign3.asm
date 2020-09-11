#Brandon
#
#Assignment 3
.data
.word 0 					#0x10010000 (32bits / 4bytes)
.word 0						#0x10010004 (32bits / 4bytes)
.word 0						#0x10010008 (32bits / 4bytes)
.asciiz "Brandon"			#0x1001000C (7 char + 1 \0 = 8 bytes total)
.asciiz "Enter a number: "	#0x10010014 (16 char + 1 \0 = 17 bytes total)
.asciiz "\n"				#0x10010025 (1 char + 1 \0 = 2 bytes total)
.globl main
.text
main:
	#Action 1 (Prompt user to enter a number, read the number and place it in memory 0x10010000)
	lui $t0, 0x1001			#Load $t0 with 0x10010000 for later convenience

	lui $a0, 0x1001			#Load $a0 with 0x10010000
	addi $a0, $a0, 0x0014	#Assign address of string "Enter a number" to #a0
	addi $v0, $0, 0x0004	#Load command 4, print string, into $v0
	syscall					#Syscall print string

	addi $v0, $v0, 0x0001	#Load command 5, read integer, into $v0
	syscall					#Syscall read integer
	sw $v0, 0($t0)			#Dump the value in $v0 to 0x10010000

	#Action 2 (Prompt user to enter a number, read the number and place it in memory 0x10010004)
	addi $v0, $0, 0x0004	#Load command 4, print string, into $v0
	syscall					#Syscall print string, $a0 was unchanged

	addi $v0, $v0, 0x0001	#Load command 5, read integer, into $v0
	syscall					#Syscall read integer
	sw $v0, 4($t0)			#Dump the value in $v0 to 0x10010004

	#Action 3 (Compare the two numbers and place the larger number into memory at address 0x10010008)
	lw $t1, 0($t0)			#Load $t1 with value at 0x10010000
	lw $t2, 4($t0)			#Load $t2 with value at 0x10010004
	slt $t3, $t1, $t2		#Compare $t1 and $t2 and assign value to $t3
	beq $t3, $0, numEq		#If slt returns 0, jump to label numEq
	sw $t2, 8($t0)			#Dump value in $t2 in 0x10010008
	j End					#Jump to End of if-else conditional
	numEq:
	sw $t1, 8($t0)			#Dump value in $t1 in 0x10010008
	End:					#Merge label for conditions
	
	#Action 4 (Print the following output each on its own line)
	addi $v0, $0, 0x0004	#Load command 4, print string, into $v0
	lui $a0, 0x1001			#Load $a0 with 0x10010000
	addi $a0, $a0, 0x000C	#Assign address of string "Brandon" to $a0
	syscall					#Syscall print string

	lui $a0, 0x1001			#Load $a0 with 0x10010000
	addi $a0, $a0, 0x0025	#Assign address of string "\n" to $a0
	syscall					#Syscall print string

	lw $a0, 0($t0)			#Assign $a0 with value at 0x10010000
	addi $v0, $0, 0x0001	#Load command 1, print integer, into $v0
	syscall					#Print integer at 0x10010000

	lui $a0, 0x1001			#Load $a0 with 0x10010000
	addi $a0, $a0, 0x0025	#Assign address of string "\n" to $a0
	addi $v0, $0, 0x0004	#Load command 4, print string, into $v0
	syscall					#Syscall print string

	lw $a0, 4($t0)			#Assign $a0 with value at 0x10010004
	addi $v0, $0, 0x0001	#Load command 1, print integer, into $v0
	syscall					#Print integer at 0x10010004

	lui $a0, 0x1001			#Load $a0 with 0x10010000
	addi $a0, $a0, 0x0025	#Assign address of string "\n" to $a0
	addi $v0, $0, 0x0004	#Load command 4, print string, into $v0
	syscall					#Syscall print string

	lw $a0, 8($t0)			#Assign $a0 with value at 0x10010008
	addi $v0, $0, 0x0001	#Load command 1, print integer, into $v0
	syscall					#Print integer at 0x10010008
	
	#Safely End the Program
	addi $v0, $0, 10		#Load syscall for program end
	syscall					#Program end

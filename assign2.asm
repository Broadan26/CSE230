#Brandon
#Assignment 2
.data
.globl main
.text
main:
	#(Actions 1-3: Assign values)
	addi $s0, $zero, 25 	#(Action 1) Assign 25 to register0
	addi $s1, $zero, 18 	#(Action 2) Assign 18 to register1
	addi $s2, $zero, -6 	#(Action 3) Assign -6 to register2
	
	#(Action 4: Set $s3 to $s1 - $s0 + $s2)
	add $t0, $s0, $s2		#(Action 4.1) Assign register0 + register2 to temporary0
	sub $s3, $s1, $t0		#(Action 4.2) Assign register1 - temporary0 to register3
	
	#(Action 5: Set $s4 to $s3 + $s2 - 7)
	add $t0, $s3, $s2		#(Action 5.1) Assign register3 + reigster 2 to temporary0
	addi $s4, $t0, -7		#(Action 5.2) Assign temporary0 + (-7) to register4
	
	#(Action 6: Set $s5 to 10 + $s1 - $s2)
	sub $t0, $s1, $s2		#(Action 6.1) Assign register1 - register2 to temporary0
	addi $s5, $t0, 10		#(Action 6.2) Assign temporary0 + (10) to register5
	
	#(Action 7: Exchange or swap the values in $s0 and $s1)
	add $t0, $zero, $s0		#(Action 7.1) Swap Start, Assign (0) + register0 to temporary0
	add $s0, $zero, $s1		#(Action 7.2) Assign (0) + register1 to register0
	add $s1, $zero, $t0		#(Action 7.3) Swap End, Assign (0) + temporary0 to register1

	#(Action 8: Set $s2 to -$s2)
	sub $s2, $zero, $s2		#(Action 8) Assign (0) - register2 to register2

.data

.global main
.text
main:
	addi $t1, $0, 20	#Assign 20 to $t1
	and $t2, $0, $0		#Set $t2 to 0
label1:	add $t2, $t2, $t1	#Add $t1 to $t2 and assign it to $t2
	sll $t1, $t1, 1		#Shift $t1 1 bit to the left
	bne $t1, $0, label1	#If $t1 equal to 0 continue, otherwise jump back up
	lui $t0, 0x1001		#Load 0x1001 into $t0
	sw $t1, 0($t0)		#Store word at location into $t1
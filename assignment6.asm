.data
	.half 7, 3
num:	.word 9				#0x10010004

.global main
.text
main:					#0x00400400
	lui $t0, 0x1001			#Base Addressing, 0x3C081001
top:					#Label 0x00400404
	lw $t1, -4($t0)			#Base Addressing, 0x8D09FFFC
	beq $s0, $s2, end		#PC-Relative Addressing, 0x12120005
	jal func			#Pseuo-Direct Addressing, 0x0C10008
	add $s0, $s1, $t0		#Register Addressing, 0x02288020
	andi $s0, $0, 0xFFFF		#Immediate Addressing, 0x3010FFFF
	j top				#Pseudo-Direct Addressing, 0x08100001
	bne $s0, $0 top			#PC-Relative Addressing, 0x1600FFF9
end:					#0x00400420
func:					#0x00400420
	sll $v0, $t1, 4			#Register Addressing, 0x00091100
	jr $ra				#Register Addressing, 0x03E00008

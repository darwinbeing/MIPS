.section .init
        .set noreorder
	la $25,main	
	li $29,0x1ffc
	jalr $31,$25
	nop
here:	j here
	nop
	

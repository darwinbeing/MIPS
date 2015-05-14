0:	lui	t9,0x0
4:	addiu	t9,t9,32
8:	li	sp,8188
c:	jalr	t9
10:	nop	
14:	j	0x14
18:	nop	
1c:	nop
20:	lui	gp,0x0
24:	addiu	gp,gp,112
28:	addu	gp,gp,t9
2c:	addiu	sp,sp,-64
30:	sw	s8,56(sp)
34:	move	s8,sp
38:	sw	zero,8(s8)
3c:	lw	v0,8(s8)
40:	slti	v0,v0,10
44:	beqz	v0,0x70
48:	lw	v0,8(s8)
4c:	sll	v1,v0,0x2
50:	addiu	v0,s8,8
54:	addu	v1,v1,v0
58:	lw	v0,8(s8)
5c:	sw	v0,8(v1)
60:	lw	v0,8(s8)
64:	addiu	v0,v0,1
68:	sw	v0,8(s8)
6c:	b	0x3c
70:	move	v0,zero
74:	move	sp,s8
78:	lw	s8,56(sp)
7c:	addiu	sp,sp,64
80:	jr	ra
84:	nop	
88:	nop	
8c:	nop	

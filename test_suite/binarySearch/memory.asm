0:	lui	t9,0x0
4:	addiu	t9,t9,264
8:	li	sp,8188
c:	jalr	t9
10:	nop	
14:	j	0x14
18:	nop	
1c:	nop
20:	lui	gp,0x0
24:	addiu	gp,gp,400
28:	addu	gp,gp,t9
2c:	addiu	sp,sp,-24
30:	sw	s8,16(sp)
34:	move	s8,sp
38:	sw	a0,24(s8)
3c:	sw	a1,28(s8)
40:	sw	a2,32(s8)
44:	sw	a3,36(s8)
48:	lw	v0,28(s8)
4c:	lw	v1,32(s8)
50:	slt	v0,v1,v0
54:	bnez	v0,0xe4
58:	lw	v1,28(s8)
5c:	lw	v0,32(s8)
60:	addu	v1,v1,v0
64:	sra	v0,v1,0x1f
68:	srl	v0,v0,0x1f
6c:	addu	v0,v1,v0
70:	sra	v0,v0,0x1
74:	sw	v0,8(s8)
78:	lw	v0,8(s8)
7c:	sll	v1,v0,0x2
80:	lw	v0,24(s8)
84:	addu	v0,v1,v0
88:	lw	v1,0(v0)
8c:	lw	v0,36(s8)
90:	slt	v0,v1,v0
94:	beqz	v0,0xa8
98:	lw	v0,8(s8)
9c:	addiu	v0,v0,1
a0:	sw	v0,28(s8)
a4:	b	0x48
a8:	lw	v0,8(s8)
ac:	sll	v1,v0,0x2
b0:	lw	v0,24(s8)
b4:	addu	v0,v1,v0
b8:	lw	v1,0(v0)
bc:	lw	v0,36(s8)
c0:	slt	v0,v0,v1
c4:	beqz	v0,0xd8
c8:	lw	v0,8(s8)
cc:	addiu	v0,v0,-1
d0:	sw	v0,32(s8)
d4:	b	0x48
d8:	lw	v0,8(s8)
dc:	sw	v0,12(s8)
e0:	b	0xf4
e4:	lw	v0,28(s8)
e8:	addiu	v0,v0,1
ec:	negu	v0,v0
f0:	sw	v0,12(s8)
f4:	lw	v0,12(s8)
f8:	move	sp,s8
fc:	lw	s8,16(sp)
100:	addiu	sp,sp,24
104:	jr	ra
108:	lui	gp,0x0
10c:	addiu	gp,gp,168
110:	addu	gp,gp,t9
114:	addiu	sp,sp,-552
118:	sw	ra,548(sp)
11c:	sw	s8,544(sp)
120:	move	s8,sp
124:	sw	gp,16(sp)
128:	sw	zero,536(s8)
12c:	lw	v0,536(s8)
130:	slti	v0,v0,128
134:	beqz	v0,0x160
138:	lw	v0,536(s8)
13c:	sll	v1,v0,0x2
140:	addiu	v0,s8,24
144:	addu	v1,v1,v0
148:	lw	v0,536(s8)
14c:	sw	v0,0(v1)
150:	lw	v0,536(s8)
154:	addiu	v0,v0,1
158:	sw	v0,536(s8)
15c:	b	0x12c
160:	addiu	a0,s8,24
164:	move	a1,zero
168:	li	a2,127
16c:	li	a3,128
170:	lui	t9,0x0
174:	addu	t9,t9,gp
178:	lw	t9,28(t9)
17c:	nop	
180:	jalr	t9
184:	nop	
188:	lw	gp,16(s8)
18c:	sw	v0,540(s8)
190:	move	v0,zero
194:	move	sp,s8
198:	lw	ra,548(sp)
19c:	lw	s8,544(sp)
1a0:	addiu	sp,sp,552
1a4:	jr	ra
1a8:	nop	
1ac:	nop	
1b0:	nop	
1b4:	lb	zero,0(zero)
1b8:	nop	
1bc:	nop	
1c0:	nop	
1c4:	nop	
1c8:	nop	
1cc:	add	zero,zero,zero

0:	lui	t9,0x0
4:	addiu	t9,t9,384
8:	li	sp,8188
c:	jalr	t9
10:	nop	
14:	j	0x14
18:	nop	
1c:	nop
20:	lui	gp,0x0
24:	addiu	gp,gp,512
28:	addu	gp,gp,t9
2c:	addiu	sp,sp,-48
30:	sw	ra,40(sp)
34:	sw	s8,36(sp)
38:	sw	s0,32(sp)
3c:	move	s8,sp
40:	sw	gp,16(sp)
44:	sw	a0,48(s8)
48:	lw	v0,48(s8)
4c:	slti	v0,v0,2
50:	beqz	v0,0x60
54:	li	v0,1
58:	sw	v0,24(s8)
5c:	b	0xbc
60:	lw	v0,48(s8)
64:	addiu	v0,v0,-1
68:	move	a0,v0
6c:	lui	t9,0x0
70:	addu	t9,t9,gp
74:	lw	t9,28(t9)
78:	nop	
7c:	jalr	t9
80:	nop	
84:	lw	gp,16(s8)
88:	move	s0,v0
8c:	lw	v0,48(s8)
90:	addiu	v0,v0,-2
94:	move	a0,v0
98:	lui	t9,0x0
9c:	addu	t9,t9,gp
a0:	lw	t9,28(t9)
a4:	nop	
a8:	jalr	t9
ac:	nop	
b0:	lw	gp,16(s8)
b4:	addu	s0,s0,v0
b8:	sw	s0,24(s8)
bc:	lw	v0,24(s8)
c0:	move	sp,s8
c4:	lw	ra,40(sp)
c8:	lw	s8,36(sp)
cc:	lw	s0,32(sp)
d0:	addiu	sp,sp,48
d4:	jr	ra
d8:	lui	gp,0x0
dc:	addiu	gp,gp,328
e0:	addu	gp,gp,t9
e4:	addiu	sp,sp,-40
e8:	sw	s8,32(sp)
ec:	move	s8,sp
f0:	sw	a0,40(s8)
f4:	lw	v0,40(s8)
f8:	slti	v0,v0,2
fc:	beqz	v0,0x10c
100:	li	v0,1
104:	sw	v0,24(s8)
108:	b	0x16c
10c:	li	v0,1
110:	sw	v0,16(s8)
114:	li	v0,1
118:	sw	v0,12(s8)
11c:	li	v0,2
120:	sw	v0,8(s8)
124:	lw	v0,8(s8)
128:	lw	v1,40(s8)
12c:	slt	v0,v1,v0
130:	bnez	v0,0x164
134:	lw	v1,12(s8)
138:	lw	v0,16(s8)
13c:	addu	v0,v1,v0
140:	sw	v0,20(s8)
144:	lw	v0,12(s8)
148:	sw	v0,16(s8)
14c:	lw	v0,20(s8)
150:	sw	v0,12(s8)
154:	lw	v0,8(s8)
158:	addiu	v0,v0,1
15c:	sw	v0,8(s8)
160:	b	0x124
164:	lw	v0,20(s8)
168:	sw	v0,24(s8)
16c:	lw	v0,24(s8)
170:	move	sp,s8
174:	lw	s8,32(sp)
178:	addiu	sp,sp,40
17c:	jr	ra
180:	lui	gp,0x0
184:	addiu	gp,gp,160
188:	addu	gp,gp,t9
18c:	addiu	sp,sp,-48
190:	sw	ra,40(sp)
194:	sw	s8,36(sp)
198:	sw	s0,32(sp)
19c:	move	s8,sp
1a0:	sw	gp,16(sp)
1a4:	li	a0,7
1a8:	lui	t9,0x0
1ac:	addu	t9,t9,gp
1b0:	lw	t9,28(t9)
1b4:	nop	
1b8:	jalr	t9
1bc:	nop	
1c0:	lw	gp,16(s8)
1c4:	move	s0,v0
1c8:	li	a0,7
1cc:	lui	t9,0x0
1d0:	addu	t9,t9,gp
1d4:	lw	t9,32(t9)
1d8:	nop	
1dc:	jalr	t9
1e0:	nop	
1e4:	lw	gp,16(s8)
1e8:	beq	s0,v0,0x1f8
1ec:	li	v0,1
1f0:	sw	v0,24(s8)
1f4:	b	0x1fc
1f8:	sw	zero,24(s8)
1fc:	lw	v0,24(s8)
200:	move	sp,s8
204:	lw	ra,40(sp)
208:	lw	s8,36(sp)
20c:	lw	s0,32(sp)
210:	addiu	sp,sp,48
214:	jr	ra
218:	nop	
21c:	nop	
220:	nop	
224:	lb	zero,0(zero)
228:	nop	
22c:	nop	
230:	nop	
234:	nop	
238:	nop	
23c:	add	zero,zero,zero
240:	0xd8	

0:	lui	t9,0x0
4:	addiu	t9,t9,32
8:	li	sp,8188
c:	jalr	t9
10:	nop	
14:	j	0x14
18:	nop	
1c:	nop
20:	lui	gp,0x0
24:	addiu	gp,gp,624
28:	addu	gp,gp,t9
2c:	addiu	sp,sp,-104
30:	sw	ra,100(sp)
34:	sw	s8,96(sp)
38:	move	s8,sp
3c:	sw	gp,16(sp)
40:	sw	zero,88(s8)
44:	lw	v0,88(s8)
48:	slti	v0,v0,16
4c:	beqz	v0,0x80
50:	lw	v0,88(s8)
54:	sll	v1,v0,0x2
58:	addiu	v0,s8,24
5c:	addu	a0,v1,v0
60:	li	v1,15
64:	lw	v0,88(s8)
68:	subu	v0,v1,v0
6c:	sw	v0,0(a0)
70:	lw	v0,88(s8)
74:	addiu	v0,v0,1
78:	sw	v0,88(s8)
7c:	b	0x44
80:	addiu	a0,s8,24
84:	li	a1,16
88:	lui	t9,0x0
8c:	addu	t9,t9,gp
90:	lw	t9,32(t9)
94:	nop	
98:	jalr	t9
9c:	nop	
a0:	lw	gp,16(s8)
a4:	sw	zero,88(s8)
a8:	lw	v0,88(s8)
ac:	slti	v0,v0,16
b0:	beqz	v0,0xec
b4:	lw	v0,88(s8)
b8:	sll	v1,v0,0x2
bc:	addiu	v0,s8,24
c0:	addu	v0,v1,v0
c4:	lw	v1,0(v0)
c8:	lw	v0,88(s8)
cc:	beq	v1,v0,0xdc
d0:	li	v0,1
d4:	sw	v0,92(s8)
d8:	b	0xf0
dc:	lw	v0,88(s8)
e0:	addiu	v0,v0,1
e4:	sw	v0,88(s8)
e8:	b	0xa8
ec:	sw	zero,92(s8)
f0:	lw	v0,92(s8)
f4:	move	sp,s8
f8:	lw	ra,100(sp)
fc:	lw	s8,96(sp)
100:	addiu	sp,sp,104
104:	jr	ra
108:	lui	gp,0x0
10c:	addiu	gp,gp,392
110:	addu	gp,gp,t9
114:	addiu	sp,sp,-24
118:	sw	s8,16(sp)
11c:	move	s8,sp
120:	sw	a0,24(s8)
124:	sw	a1,28(s8)
128:	sw	a2,32(s8)
12c:	lw	v0,28(s8)
130:	sll	v1,v0,0x2
134:	lw	v0,24(s8)
138:	addu	v0,v1,v0
13c:	lw	v0,0(v0)
140:	sw	v0,8(s8)
144:	lw	v0,28(s8)
148:	sll	v1,v0,0x2
14c:	lw	v0,24(s8)
150:	addu	a0,v1,v0
154:	lw	v0,32(s8)
158:	sll	v1,v0,0x2
15c:	lw	v0,24(s8)
160:	addu	v0,v1,v0
164:	lw	v0,0(v0)
168:	sw	v0,0(a0)
16c:	lw	v0,32(s8)
170:	sll	v1,v0,0x2
174:	lw	v0,24(s8)
178:	addu	v1,v1,v0
17c:	lw	v0,8(s8)
180:	sw	v0,0(v1)
184:	move	sp,s8
188:	lw	s8,16(sp)
18c:	addiu	sp,sp,24
190:	jr	ra
194:	lui	gp,0x0
198:	addiu	gp,gp,252
19c:	addu	gp,gp,t9
1a0:	addiu	sp,sp,-48
1a4:	sw	ra,44(sp)
1a8:	sw	s8,40(sp)
1ac:	move	s8,sp
1b0:	sw	gp,16(sp)
1b4:	sw	a0,48(s8)
1b8:	sw	a1,52(s8)
1bc:	lw	v0,52(s8)
1c0:	addiu	v0,v0,-1
1c4:	sw	v0,24(s8)
1c8:	sw	zero,32(s8)
1cc:	sw	zero,28(s8)
1d0:	lw	v0,28(s8)
1d4:	lw	v1,24(s8)
1d8:	slt	v0,v0,v1
1dc:	beqz	v0,0x258
1e0:	lw	v0,28(s8)
1e4:	sll	v1,v0,0x2
1e8:	lw	v0,48(s8)
1ec:	addu	a0,v1,v0
1f0:	lw	v0,28(s8)
1f4:	sll	v1,v0,0x2
1f8:	lw	v0,48(s8)
1fc:	addu	v0,v1,v0
200:	lw	v1,0(a0)
204:	lw	v0,4(v0)
208:	slt	v0,v0,v1
20c:	beqz	v0,0x248
210:	lw	v0,28(s8)
214:	addiu	v0,v0,1
218:	lw	a0,48(s8)
21c:	lw	a1,28(s8)
220:	move	a2,v0
224:	lui	t9,0x0
228:	addu	t9,t9,gp
22c:	lw	t9,28(t9)
230:	nop	
234:	jalr	t9
238:	nop	
23c:	lw	gp,16(s8)
240:	li	v0,1
244:	sw	v0,32(s8)
248:	lw	v0,28(s8)
24c:	addiu	v0,v0,1
250:	sw	v0,28(s8)
254:	b	0x1d0
258:	lw	v0,24(s8)
25c:	addiu	v0,v0,-1
260:	sw	v0,24(s8)
264:	lw	v0,32(s8)
268:	beqz	v0,0x270
26c:	b	0x1c8
270:	move	sp,s8
274:	lw	ra,44(sp)
278:	lw	s8,40(sp)
27c:	addiu	sp,sp,48
280:	jr	ra
284:	nop	
288:	nop	
28c:	nop	
290:	nop	
294:	lb	zero,0(zero)
298:	nop	
29c:	nop	
2a0:	nop	
2a4:	nop	
2a8:	nop	
2ac:	0x108	
2b0:	0x194	

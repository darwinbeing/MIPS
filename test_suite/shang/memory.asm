0:	lui	t9,0x0
4:	addiu	t9,t9,1688
8:	li	sp,8188
c:	jalr	t9
10:	nop	
14:	j	0x14
18:	nop	
1c:	nop
20:	lui	gp,0x0
24:	addiu	gp,gp,2656
28:	addu	gp,gp,t9
2c:	addiu	sp,sp,-24
30:	sw	s8,16(sp)
34:	move	s8,sp
38:	sw	a0,24(s8)
3c:	sw	a1,28(s8)
40:	sw	zero,8(s8)
44:	lw	v0,8(s8)
48:	slti	v0,v0,40
4c:	beqz	v0,0xd8
50:	sw	zero,12(s8)
54:	lw	v0,12(s8)
58:	slti	v0,v0,21
5c:	beqz	v0,0xc8
60:	lw	a0,28(s8)
64:	lw	v1,8(s8)
68:	move	v0,v1
6c:	sll	v0,v0,0x2
70:	addu	v0,v0,v1
74:	sll	v0,v0,0x2
78:	addu	v0,v0,v1
7c:	addu	v1,v0,a0
80:	lw	v0,12(s8)
84:	addu	a1,v1,v0
88:	lw	a0,24(s8)
8c:	lw	v1,8(s8)
90:	move	v0,v1
94:	sll	v0,v0,0x2
98:	addu	v0,v0,v1
9c:	sll	v0,v0,0x2
a0:	addu	v0,v0,v1
a4:	addu	v1,v0,a0
a8:	lw	v0,12(s8)
ac:	addu	v0,v1,v0
b0:	lbu	v0,0(v0)
b4:	sb	v0,0(a1)
b8:	lw	v0,12(s8)
bc:	addiu	v0,v0,1
c0:	sw	v0,12(s8)
c4:	b	0x54
c8:	lw	v0,8(s8)
cc:	addiu	v0,v0,1
d0:	sw	v0,8(s8)
d4:	b	0x44
d8:	sw	zero,8(s8)
dc:	lw	v0,8(s8)
e0:	slti	v0,v0,20
e4:	beqz	v0,0x120
e8:	lw	v1,28(s8)
ec:	lw	v0,8(s8)
f0:	sll	v0,v0,0x2
f4:	addu	a0,v0,v1
f8:	lw	v1,24(s8)
fc:	lw	v0,8(s8)
100:	sll	v0,v0,0x2
104:	addu	v0,v0,v1
108:	lw	v0,840(v0)
10c:	sw	v0,840(a0)
110:	lw	v0,8(s8)
114:	addiu	v0,v0,1
118:	sw	v0,8(s8)
11c:	b	0xdc
120:	sw	zero,8(s8)
124:	lw	v0,8(s8)
128:	slti	v0,v0,40
12c:	beqz	v0,0x168
130:	lw	v1,28(s8)
134:	lw	v0,8(s8)
138:	sll	v0,v0,0x2
13c:	addu	a0,v0,v1
140:	lw	v1,24(s8)
144:	lw	v0,8(s8)
148:	sll	v0,v0,0x2
14c:	addu	v0,v0,v1
150:	lw	v0,920(v0)
154:	sw	v0,920(a0)
158:	lw	v0,8(s8)
15c:	addiu	v0,v0,1
160:	sw	v0,8(s8)
164:	b	0x124
168:	move	sp,s8
16c:	lw	s8,16(sp)
170:	addiu	sp,sp,24
174:	jr	ra
178:	lui	gp,0x0
17c:	addiu	gp,gp,2312
180:	addu	gp,gp,t9
184:	addiu	sp,sp,-24
188:	sw	s8,16(sp)
18c:	move	s8,sp
190:	sw	a0,24(s8)
194:	sw	a1,28(s8)
198:	sw	a2,32(s8)
19c:	sw	zero,12(s8)
1a0:	sw	zero,8(s8)
1a4:	lw	v0,8(s8)
1a8:	lw	v1,32(s8)
1ac:	slt	v0,v0,v1
1b0:	beqz	v0,0x22c
1b4:	lw	v1,24(s8)
1b8:	lw	v0,8(s8)
1bc:	addu	a0,v1,v0
1c0:	lw	v1,28(s8)
1c4:	lw	v0,8(s8)
1c8:	addu	v0,v1,v0
1cc:	lb	v1,0(a0)
1d0:	lb	v0,0(v0)
1d4:	slt	v0,v1,v0
1d8:	beqz	v0,0x1e8
1dc:	li	v0,-1
1e0:	sw	v0,12(s8)
1e4:	b	0x22c
1e8:	lw	v1,24(s8)
1ec:	lw	v0,8(s8)
1f0:	addu	a0,v1,v0
1f4:	lw	v1,28(s8)
1f8:	lw	v0,8(s8)
1fc:	addu	v0,v1,v0
200:	lb	v1,0(a0)
204:	lb	v0,0(v0)
208:	slt	v0,v0,v1
20c:	beqz	v0,0x21c
210:	li	v0,1
214:	sw	v0,12(s8)
218:	b	0x22c
21c:	lw	v0,8(s8)
220:	addiu	v0,v0,1
224:	sw	v0,8(s8)
228:	b	0x1a4
22c:	lw	v0,12(s8)
230:	move	sp,s8
234:	lw	s8,16(sp)
238:	addiu	sp,sp,24
23c:	jr	ra
240:	lui	gp,0x0
244:	addiu	gp,gp,2112
248:	addu	gp,gp,t9
24c:	addiu	sp,sp,-24
250:	sw	s8,16(sp)
254:	move	s8,sp
258:	sw	a0,24(s8)
25c:	sw	a1,28(s8)
260:	sw	zero,8(s8)
264:	lw	v1,24(s8)
268:	lw	v0,8(s8)
26c:	addu	a0,v1,v0
270:	lw	v1,28(s8)
274:	lw	v0,8(s8)
278:	addu	v0,v1,v0
27c:	lbu	v0,0(v0)
280:	sb	v0,0(a0)
284:	lw	v0,8(s8)
288:	addiu	v0,v0,1
28c:	sw	v0,8(s8)
290:	lw	v1,28(s8)
294:	lw	v0,8(s8)
298:	addu	v0,v1,v0
29c:	lb	v0,0(v0)
2a0:	beqz	v0,0x2a8
2a4:	b	0x264
2a8:	move	sp,s8
2ac:	lw	s8,16(sp)
2b0:	addiu	sp,sp,24
2b4:	jr	ra
2b8:	lui	gp,0x0
2bc:	addiu	gp,gp,1992
2c0:	addu	gp,gp,t9
2c4:	addiu	sp,sp,-608
2c8:	sw	ra,604(sp)
2cc:	sw	s8,600(sp)
2d0:	move	s8,sp
2d4:	sw	gp,16(sp)
2d8:	sw	a0,608(s8)
2dc:	sw	a1,612(s8)
2e0:	sw	zero,424(s8)
2e4:	lw	v0,424(s8)
2e8:	slti	v0,v0,20
2ec:	beqz	v0,0x374
2f0:	sw	zero,428(s8)
2f4:	lw	v0,428(s8)
2f8:	slti	v0,v0,20
2fc:	beqz	v0,0x364
300:	lw	v1,424(s8)
304:	move	v0,v1
308:	sll	v0,v0,0x2
30c:	addu	v0,v0,v1
310:	sll	v1,v0,0x2
314:	addiu	v0,s8,24
318:	addu	v1,v1,v0
31c:	lw	v0,428(s8)
320:	addu	a1,v1,v0
324:	lw	a0,608(s8)
328:	lw	v1,428(s8)
32c:	move	v0,v1
330:	sll	v0,v0,0x2
334:	addu	v0,v0,v1
338:	sll	v0,v0,0x2
33c:	addu	v0,v0,v1
340:	addu	v1,v0,a0
344:	lw	v0,424(s8)
348:	addu	v0,v1,v0
34c:	lbu	v0,0(v0)
350:	sb	v0,0(a1)
354:	lw	v0,428(s8)
358:	addiu	v0,v0,1
35c:	sw	v0,428(s8)
360:	b	0x2f4
364:	lw	v0,424(s8)
368:	addiu	v0,v0,1
36c:	sw	v0,424(s8)
370:	b	0x2e4
374:	sw	zero,424(s8)
378:	lw	v0,424(s8)
37c:	slti	v0,v0,40
380:	beqz	v0,0x3bc
384:	lw	v0,424(s8)
388:	sll	v1,v0,0x2
38c:	addiu	v0,s8,24
390:	addu	a0,v1,v0
394:	lw	v1,608(s8)
398:	lw	v0,424(s8)
39c:	sll	v0,v0,0x2
3a0:	addu	v0,v0,v1
3a4:	lw	v0,920(v0)
3a8:	sw	v0,408(a0)
3ac:	lw	v0,424(s8)
3b0:	addiu	v0,v0,1
3b4:	sw	v0,424(s8)
3b8:	b	0x378
3bc:	sw	zero,424(s8)
3c0:	lw	v0,424(s8)
3c4:	slti	v0,v0,20
3c8:	beqz	v0,0x4b8
3cc:	sw	zero,428(s8)
3d0:	lw	v0,428(s8)
3d4:	slti	v0,v0,40
3d8:	beqz	v0,0x494
3dc:	lw	v0,428(s8)
3e0:	sll	v1,v0,0x2
3e4:	addiu	v0,s8,24
3e8:	addu	v0,v1,v0
3ec:	lw	v0,408(v0)
3f0:	bnez	v0,0x3f8
3f4:	b	0x484
3f8:	lw	v1,428(s8)
3fc:	move	v0,v1
400:	sll	v0,v0,0x2
404:	addu	v0,v0,v1
408:	sll	v0,v0,0x2
40c:	addu	v0,v0,v1
410:	lui	v1,0x0
414:	addu	v1,v1,gp
418:	lw	v1,44(v1)
41c:	addu	a0,v0,v1
420:	lw	v1,424(s8)
424:	move	v0,v1
428:	sll	v0,v0,0x2
42c:	addu	v0,v0,v1
430:	sll	v1,v0,0x2
434:	addiu	v0,s8,24
438:	addu	v1,v0,v1
43c:	lw	v0,612(s8)
440:	addiu	v0,v0,1
444:	move	a1,v1
448:	move	a2,v0
44c:	lui	t9,0x0
450:	addu	t9,t9,gp
454:	lw	t9,28(t9)
458:	nop	
45c:	jalr	t9
460:	nop	
464:	lw	gp,16(s8)
468:	bnez	v0,0x484
46c:	lw	v0,428(s8)
470:	sll	v1,v0,0x2
474:	addiu	v0,s8,24
478:	addu	v0,v1,v0
47c:	sw	zero,408(v0)
480:	b	0x494
484:	lw	v0,428(s8)
488:	addiu	v0,v0,1
48c:	sw	v0,428(s8)
490:	b	0x3d0
494:	lw	v0,428(s8)
498:	slti	v0,v0,40
49c:	bnez	v0,0x4a8
4a0:	sw	zero,592(s8)
4a4:	b	0x4c0
4a8:	lw	v0,424(s8)
4ac:	addiu	v0,v0,1
4b0:	sw	v0,424(s8)
4b4:	b	0x3c0
4b8:	li	v0,1
4bc:	sw	v0,592(s8)
4c0:	lw	v0,592(s8)
4c4:	move	sp,s8
4c8:	lw	ra,604(sp)
4cc:	lw	s8,600(sp)
4d0:	addiu	sp,sp,608
4d4:	jr	ra
4d8:	lui	gp,0x0
4dc:	addiu	gp,gp,1448
4e0:	addu	gp,gp,t9
4e4:	addiu	sp,sp,-1128
4e8:	sw	ra,1124(sp)
4ec:	sw	s8,1120(sp)
4f0:	move	s8,sp
4f4:	sw	gp,16(sp)
4f8:	sw	a0,1128(s8)
4fc:	sw	a1,1132(s8)
500:	lw	v1,1132(s8)
504:	li	v0,20
508:	bne	v1,v0,0x518
50c:	li	v0,1
510:	sw	v0,1112(s8)
514:	b	0x680
518:	sw	zero,24(s8)
51c:	lw	v0,24(s8)
520:	slti	v0,v0,40
524:	beqz	v0,0x67c
528:	lw	v1,1128(s8)
52c:	lw	v0,24(s8)
530:	sll	v0,v0,0x2
534:	addu	v0,v0,v1
538:	lw	v0,920(v0)
53c:	beqz	v0,0x66c
540:	addiu	v0,s8,32
544:	lw	a0,1128(s8)
548:	move	a1,v0
54c:	lui	t9,0x0
550:	addu	t9,t9,gp
554:	lw	t9,40(t9)
558:	nop	
55c:	jalr	t9
560:	nop	
564:	lw	gp,16(s8)
568:	lw	v0,1132(s8)
56c:	sll	v1,v0,0x2
570:	addiu	v0,s8,24
574:	addu	v1,v1,v0
578:	lw	v0,24(s8)
57c:	sw	v0,848(v1)
580:	lw	v0,24(s8)
584:	sll	v1,v0,0x2
588:	addiu	v0,s8,24
58c:	addu	v0,v1,v0
590:	sw	zero,928(v0)
594:	addiu	a0,s8,32
598:	lw	v1,1132(s8)
59c:	move	v0,v1
5a0:	sll	v0,v0,0x2
5a4:	addu	v0,v0,v1
5a8:	sll	v0,v0,0x2
5ac:	addu	v0,v0,v1
5b0:	addu	a0,a0,v0
5b4:	lw	v1,24(s8)
5b8:	move	v0,v1
5bc:	sll	v0,v0,0x2
5c0:	addu	v0,v0,v1
5c4:	sll	v0,v0,0x2
5c8:	addu	v0,v0,v1
5cc:	lui	v1,0x0
5d0:	addu	v1,v1,gp
5d4:	lw	v1,44(v1)
5d8:	addu	v0,v0,v1
5dc:	move	a1,v0
5e0:	lui	t9,0x0
5e4:	addu	t9,t9,gp
5e8:	lw	t9,32(t9)
5ec:	nop	
5f0:	jalr	t9
5f4:	nop	
5f8:	lw	gp,16(s8)
5fc:	addiu	v0,s8,32
600:	move	a0,v0
604:	lw	a1,1132(s8)
608:	lui	t9,0x0
60c:	addu	t9,t9,gp
610:	lw	t9,36(t9)
614:	nop	
618:	jalr	t9
61c:	nop	
620:	lw	gp,16(s8)
624:	bnez	v0,0x62c
628:	b	0x66c
62c:	addiu	v1,s8,32
630:	lw	v0,1132(s8)
634:	addiu	v0,v0,1
638:	move	a0,v1
63c:	move	a1,v0
640:	lui	t9,0x0
644:	addu	t9,t9,gp
648:	lw	t9,48(t9)
64c:	nop	
650:	jalr	t9
654:	nop	
658:	lw	gp,16(s8)
65c:	beqz	v0,0x66c
660:	li	v0,1
664:	sw	v0,1112(s8)
668:	b	0x680
66c:	lw	v0,24(s8)
670:	addiu	v0,v0,1
674:	sw	v0,24(s8)
678:	b	0x51c
67c:	sw	zero,1112(s8)
680:	lw	v0,1112(s8)
684:	move	sp,s8
688:	lw	ra,1124(sp)
68c:	lw	s8,1120(sp)
690:	addiu	sp,sp,1128
694:	jr	ra
698:	lui	gp,0x0
69c:	addiu	gp,gp,1000
6a0:	addu	gp,gp,t9
6a4:	addiu	sp,sp,-1120
6a8:	sw	ra,1116(sp)
6ac:	sw	s8,1112(sp)
6b0:	move	s8,sp
6b4:	sw	gp,16(sp)
6b8:	sw	zero,1104(s8)
6bc:	lw	v0,1104(s8)
6c0:	slti	v0,v0,40
6c4:	beqz	v0,0x6f0
6c8:	lw	v0,1104(s8)
6cc:	sll	v1,v0,0x2
6d0:	addiu	v0,s8,24
6d4:	addu	v1,v1,v0
6d8:	li	v0,1
6dc:	sw	v0,920(v1)
6e0:	lw	v0,1104(s8)
6e4:	addiu	v0,v0,1
6e8:	sw	v0,1104(s8)
6ec:	b	0x6bc
6f0:	addiu	a0,s8,24
6f4:	move	a1,zero
6f8:	lui	t9,0x0
6fc:	addu	t9,t9,gp
700:	lw	t9,48(t9)
704:	nop	
708:	jalr	t9
70c:	nop	
710:	lw	gp,16(s8)
714:	sw	v0,1108(s8)
718:	lw	v0,1108(s8)
71c:	move	sp,s8
720:	lw	ra,1116(sp)
724:	lw	s8,1112(sp)
728:	addiu	sp,sp,1120
72c:	jr	ra
730:	addi	zero,at,8224
734:	addi	zero,at,8224
738:	addi	zero,at,8224
73c:	addi	zero,at,8224
740:	addi	zero,at,8234
744:	add	a0,at,zero
748:	addi	zero,at,8224
74c:	addi	zero,at,8224
750:	addi	zero,at,8224
754:	addi	zero,at,8234
758:	slti	zero,s0,8224
75c:	addi	zero,at,8224
760:	addi	t2,at,8224
764:	addi	zero,at,8234
768:	addi	zero,at,10784
76c:	addi	zero,at,32
770:	addi	zero,at,8224
774:	addi	zero,at,8224
778:	addi	zero,at,10784
77c:	addi	zero,at,10794
780:	slti	zero,s1,8192
784:	slti	zero,s1,8224
788:	slti	zero,s1,8224
78c:	addi	zero,at,8224
790:	addi	zero,at,8234
794:	addi	zero,at,10784
798:	add	a0,at,zero
79c:	addi	zero,at,8224
7a0:	addi	zero,at,8224
7a4:	slti	t2,s1,8224
7a8:	addi	zero,at,10784
7ac:	slti	zero,s0,8224
7b0:	slti	zero,s1,10794
7b4:	addi	zero,at,10784
7b8:	addi	zero,at,8224
7bc:	slti	zero,s1,8224
7c0:	addi	zero,at,32
7c4:	addi	zero,at,8224
7c8:	addi	zero,at,8224
7cc:	addi	zero,at,8234
7d0:	slti	t2,s1,10794
7d4:	addi	zero,at,8192
7d8:	addi	zero,at,8234
7dc:	slti	zero,s1,8224
7e0:	addi	t2,at,8224
7e4:	addi	t2,at,8234
7e8:	addi	zero,at,8224
7ec:	add	a0,at,zero
7f0:	addi	zero,at,8224
7f4:	addi	zero,at,8234
7f8:	addi	t2,at,8224
7fc:	addi	t2,at,10794
800:	addi	zero,zero,8234
804:	addi	t2,at,8224
808:	addi	t2,at,8224
80c:	addi	t2,at,8224
810:	slti	zero,s1,8224
814:	addi	zero,at,32
818:	addi	zero,at,8224
81c:	addi	t2,at,10784
820:	addi	zero,at,8234
824:	addi	t2,at,8224
828:	slti	zero,s1,8192
82c:	addi	zero,at,10784
830:	addi	t2,at,8224
834:	slti	zero,s1,8224
838:	addi	zero,at,10784
83c:	slti	zero,s1,8224
840:	add	a0,at,zero
844:	addi	zero,at,8224
848:	addi	zero,at,8234
84c:	addi	zero,at,10784
850:	addi	t2,at,10784
854:	slti	zero,s0,8234
858:	slti	t2,s1,8224
85c:	addi	t2,at,8224
860:	addi	zero,at,8224
864:	addi	zero,at,8234
868:	addi	zero,at,32
86c:	slti	zero,s1,8234
870:	addi	t2,at,8234
874:	addi	zero,at,8234
878:	addi	t2,at,8224
87c:	addi	zero,at,8192
880:	addi	zero,at,8234
884:	slti	zero,s1,8234
888:	addi	t2,at,8224
88c:	addi	zero,at,10784
890:	slti	zero,s1,8224
894:	slt	a0,at,zero
898:	slti	t2,s1,10794
89c:	addi	zero,at,8224
8a0:	addi	zero,at,8224
8a4:	addi	zero,at,8234
8a8:	addi	zero,zero,8224
8ac:	slti	zero,s1,8234
8b0:	addi	zero,at,8234
8b4:	addi	t2,at,10784
8b8:	addi	t2,at,8224
8bc:	addi	zero,at,32
8c0:	addi	zero,at,8234
8c4:	addi	zero,at,10784
8c8:	addi	t2,at,8234
8cc:	addi	t2,at,8234
8d0:	addi	zero,at,8192
8d4:	addi	zero,at,8224
8d8:	addi	zero,at,8224
8dc:	addi	t2,at,8234
8e0:	slti	t2,s1,8224
8e4:	addi	t2,at,10784
8e8:	add	a0,at,zero
8ec:	addi	zero,at,10794
8f0:	addi	t2,at,8224
8f4:	slti	zero,s1,8224
8f8:	slti	zero,s1,10784
8fc:	addi	zero,zero,8224
900:	addi	zero,at,8224
904:	addi	zero,at,10794
908:	slti	zero,s1,10784
90c:	slti	zero,s1,8224
910:	slti	zero,s1,32
914:	addi	t2,at,10794
918:	addi	zero,at,8234
91c:	addi	zero,at,10784
920:	addi	t2,at,8224
924:	addi	zero,at,8192
928:	addi	zero,at,8224
92c:	addi	zero,at,8234
930:	addi	zero,at,10794
934:	addi	t2,at,8234
938:	addi	zero,at,10784
93c:	add	a0,at,zero
940:	slti	t2,s1,8234
944:	addi	t2,at,8234
948:	addi	zero,at,10784
94c:	slti	zero,s1,8224
950:	addi	zero,zero,8224
954:	addi	zero,at,10784
958:	addi	t2,at,8224
95c:	slti	zero,s1,10794
960:	slti	zero,s1,10784
964:	addi	zero,at,42
968:	slti	t2,s1,10794
96c:	addi	zero,at,8224
970:	addi	zero,at,8224
974:	addi	t2,at,8224
978:	addi	zero,at,10752
97c:	addi	zero,at,8234
980:	slti	zero,s1,8224
984:	addi	t2,at,8234
988:	addi	t2,at,10794
98c:	addi	zero,at,8224
990:	add	a0,at,t2
994:	slti	zero,s1,10784
998:	slti	t2,s1,10784
99c:	addi	zero,at,8234
9a0:	addi	zero,at,8224
9a4:	addi	zero,zero,8224
9a8:	addi	zero,at,8224
9ac:	addi	zero,at,8234
9b0:	slti	t2,s1,8224
9b4:	slti	t2,s1,8234
9b8:	addi	t2,at,32
9bc:	addi	zero,at,8224
9c0:	slti	t2,s1,8234
9c4:	addi	zero,at,8234
9c8:	slti	zero,s1,10784
9cc:	slti	zero,s1,8192
9d0:	slti	t2,s1,10784
9d4:	addi	zero,at,10784
9d8:	slti	zero,s1,8224
9dc:	addi	zero,at,8234
9e0:	slti	t2,s1,8224
9e4:	add	a0,at,zero
9e8:	addi	zero,at,8234
9ec:	slti	zero,s1,8224
9f0:	slti	t2,s1,8234
9f4:	slti	t2,s1,8234
9f8:	addi	zero,zero,8234
9fc:	addi	t2,at,8234
a00:	slti	zero,s1,8234
a04:	slti	t2,s1,8234
a08:	addi	zero,at,8224
a0c:	addi	zero,at,42
a10:	addi	t2,at,10794
a14:	addi	t2,at,10794
a18:	addi	zero,at,8234
a1c:	slti	zero,s1,8224
a20:	addi	zero,at,8192
a24:	addi	zero,at,8224
a28:	addi	zero,at,8224
a2c:	slti	t2,s1,10784
a30:	slti	zero,s1,10794
a34:	addi	t2,at,10794
a38:	0x202a2a	
a3c:	slti	t2,s1,8234
a40:	slti	zero,s1,8224
a44:	addi	zero,at,8224
a48:	slti	t2,s1,10784
a4c:	addi	zero,zero,10794
a50:	addi	zero,at,8234
a54:	slti	t2,s1,8234
a58:	addi	zero,at,8234
a5c:	slti	zero,s1,8234
a60:	slti	zero,s1,42
a64:	addi	zero,at,8234
a68:	addi	t2,at,8234
a6c:	slti	t2,s1,10794
a70:	addi	zero,at,10794
a74:	addi	zero,at,10752
a78:	nop	
a7c:	nop	
a80:	nop	
a84:	lb	zero,0(zero)
a88:	nop	
a8c:	nop	
a90:	nop	
a94:	nop	
a98:	nop	
a9c:	0x178	
aa0:	sll	zero,zero,0x9
aa4:	0x2b8	
aa8:	add	zero,zero,zero
aac:	0x730	
ab0:	0x4d8	

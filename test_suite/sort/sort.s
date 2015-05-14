	.file	1 "sort.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.data
	.align	1
	.type	next.0, @object
	.size	next.0, 2
next.0:
	.half	1
	.text
	.align	2
	.globl	myrand
	.ent	myrand
	.type	myrand, @function
myrand:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-8
	sw	$fp,0($sp)
	move	$fp,$sp
	lhu	$2,next.0
	sll	$2,$2,7
	lhu	$3,next.0
	addu	$2,$3,$2
	sh	$2,next.0
	lhu	$2,next.0
	srl	$2,$2,7
	andi	$2,$2,0xffff
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	j	$31
	.end	myrand
	.align	2
	.globl	Swap
	.ent	Swap
	.type	Swap, @function
Swap:
	.frame	$fp,24,$31		# vars= 8, regs= 1/0, args= 0, gp= 8
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-24
	sw	$fp,16($sp)
	move	$fp,$sp
	sw	$4,24($fp)
	sw	$5,28($fp)
	lw	$2,24($fp)
	lw	$2,0($2)
	sw	$2,8($fp)
	lw	$3,24($fp)
	lw	$2,28($fp)
	lw	$2,0($2)
	sw	$2,0($3)
	lw	$3,28($fp)
	lw	$2,8($fp)
	sw	$2,0($3)
	move	$sp,$fp
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	j	$31
	.end	Swap
	.align	2
	.globl	InsertionSort
	.ent	InsertionSort
	.type	InsertionSort, @function
InsertionSort:
	.frame	$fp,32,$31		# vars= 16, regs= 1/0, args= 0, gp= 8
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-32
	sw	$fp,24($sp)
	move	$fp,$sp
	sw	$4,32($fp)
	sw	$5,36($fp)
	li	$2,1			# 0x1
	sw	$2,12($fp)
$L4:
	lw	$2,12($fp)
	lw	$3,36($fp)
	slt	$2,$2,$3
	beq	$2,$0,$L3
	lw	$2,12($fp)
	sll	$3,$2,2
	lw	$2,32($fp)
	addu	$2,$3,$2
	lw	$2,0($2)
	sw	$2,16($fp)
	lw	$2,12($fp)
	sw	$2,8($fp)
$L7:
	lw	$2,8($fp)
	blez	$2,$L8
	lw	$2,8($fp)
	sll	$3,$2,2
	lw	$2,32($fp)
	addu	$2,$3,$2
	lw	$3,-4($2)
	lw	$2,16($fp)
	slt	$2,$2,$3
	beq	$2,$0,$L8
	lw	$2,8($fp)
	sll	$3,$2,2
	lw	$2,32($fp)
	addu	$4,$3,$2
	lw	$2,8($fp)
	sll	$3,$2,2
	lw	$2,32($fp)
	addu	$2,$3,$2
	lw	$2,-4($2)
	sw	$2,0($4)
	lw	$2,8($fp)
	addiu	$2,$2,-1
	sw	$2,8($fp)
	b	$L7
$L8:
	lw	$2,8($fp)
	sll	$3,$2,2
	lw	$2,32($fp)
	addu	$3,$3,$2
	lw	$2,16($fp)
	sw	$2,0($3)
	lw	$2,12($fp)
	addiu	$2,$2,1
	sw	$2,12($fp)
	b	$L4
$L3:
	move	$sp,$fp
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	j	$31
	.end	InsertionSort
	.align	2
	.globl	Shellsort
	.ent	Shellsort
	.type	Shellsort, @function
Shellsort:
	.frame	$fp,32,$31		# vars= 16, regs= 1/0, args= 0, gp= 8
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-32
	sw	$fp,24($sp)
	move	$fp,$sp
	sw	$4,32($fp)
	sw	$5,36($fp)
	lw	$3,36($fp)
	sra	$2,$3,31
	srl	$2,$2,31
	addu	$2,$3,$2
	sra	$2,$2,1
	sw	$2,16($fp)
$L11:
	lw	$2,16($fp)
	blez	$2,$L10
	lw	$2,16($fp)
	sw	$2,8($fp)
$L14:
	lw	$2,8($fp)
	lw	$3,36($fp)
	slt	$2,$2,$3
	beq	$2,$0,$L13
	lw	$2,8($fp)
	sll	$3,$2,2
	lw	$2,32($fp)
	addu	$2,$3,$2
	lw	$2,0($2)
	sw	$2,20($fp)
	lw	$2,8($fp)
	sw	$2,12($fp)
$L17:
	lw	$2,12($fp)
	lw	$3,16($fp)
	slt	$2,$2,$3
	bne	$2,$0,$L18
	lw	$3,12($fp)
	lw	$2,16($fp)
	subu	$2,$3,$2
	sll	$3,$2,2
	lw	$2,32($fp)
	addu	$2,$3,$2
	lw	$3,0($2)
	lw	$2,20($fp)
	slt	$2,$2,$3
	beq	$2,$0,$L18
	lw	$2,12($fp)
	sll	$3,$2,2
	lw	$2,32($fp)
	addu	$4,$3,$2
	lw	$3,12($fp)
	lw	$2,16($fp)
	subu	$2,$3,$2
	sll	$3,$2,2
	lw	$2,32($fp)
	addu	$2,$3,$2
	lw	$2,0($2)
	sw	$2,0($4)
	lw	$3,12($fp)
	lw	$2,16($fp)
	subu	$2,$3,$2
	sw	$2,12($fp)
	b	$L17
$L18:
	lw	$2,12($fp)
	sll	$3,$2,2
	lw	$2,32($fp)
	addu	$3,$3,$2
	lw	$2,20($fp)
	sw	$2,0($3)
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L14
$L13:
	lw	$3,16($fp)
	sra	$2,$3,31
	srl	$2,$2,31
	addu	$2,$3,$2
	sra	$2,$2,1
	sw	$2,16($fp)
	b	$L11
$L10:
	move	$sp,$fp
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	j	$31
	.end	Shellsort
	.align	2
	.globl	PercDown
	.ent	PercDown
	.type	PercDown, @function
PercDown:
	.frame	$fp,24,$31		# vars= 8, regs= 1/0, args= 0, gp= 8
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-24
	sw	$fp,16($sp)
	move	$fp,$sp
	sw	$4,24($fp)
	sw	$5,28($fp)
	sw	$6,32($fp)
	lw	$2,28($fp)
	sll	$3,$2,2
	lw	$2,24($fp)
	addu	$2,$3,$2
	lw	$2,0($2)
	sw	$2,12($fp)
$L23:
	lw	$2,28($fp)
	sll	$2,$2,1
	addiu	$3,$2,1
	lw	$2,32($fp)
	slt	$2,$3,$2
	beq	$2,$0,$L24
	lw	$2,28($fp)
	sll	$2,$2,1
	addiu	$2,$2,1
	sw	$2,8($fp)
	lw	$2,32($fp)
	addiu	$3,$2,-1
	lw	$2,8($fp)
	beq	$3,$2,$L26
	lw	$2,8($fp)
	sll	$3,$2,2
	lw	$2,24($fp)
	addu	$4,$3,$2
	lw	$2,8($fp)
	sll	$3,$2,2
	lw	$2,24($fp)
	addu	$2,$3,$2
	lw	$3,4($4)
	lw	$2,0($2)
	slt	$2,$2,$3
	beq	$2,$0,$L26
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
$L26:
	lw	$2,8($fp)
	sll	$3,$2,2
	lw	$2,24($fp)
	addu	$2,$3,$2
	lw	$3,0($2)
	lw	$2,12($fp)
	slt	$2,$2,$3
	beq	$2,$0,$L24
	lw	$2,28($fp)
	sll	$3,$2,2
	lw	$2,24($fp)
	addu	$4,$3,$2
	lw	$2,8($fp)
	sll	$3,$2,2
	lw	$2,24($fp)
	addu	$2,$3,$2
	lw	$2,0($2)
	sw	$2,0($4)
	lw	$2,8($fp)
	sw	$2,28($fp)
	b	$L23
$L24:
	lw	$2,28($fp)
	sll	$3,$2,2
	lw	$2,24($fp)
	addu	$3,$3,$2
	lw	$2,12($fp)
	sw	$2,0($3)
	move	$sp,$fp
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	j	$31
	.end	PercDown
	.align	2
	.globl	Heapsort
	.ent	Heapsort
	.type	Heapsort, @function
Heapsort:
	.frame	$fp,40,$31		# vars= 8, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$fp,32($sp)
	move	$fp,$sp
	.cprestore	16
	sw	$4,40($fp)
	sw	$5,44($fp)
	lw	$3,44($fp)
	sra	$2,$3,31
	srl	$2,$2,31
	addu	$2,$3,$2
	sra	$2,$2,1
	sw	$2,24($fp)
$L30:
	lw	$2,24($fp)
	bltz	$2,$L31
	lw	$4,40($fp)
	lw	$5,24($fp)
	lw	$6,44($fp)
	jal	PercDown
	lw	$2,24($fp)
	addiu	$2,$2,-1
	sw	$2,24($fp)
	b	$L30
$L31:
	lw	$2,44($fp)
	addiu	$2,$2,-1
	sw	$2,24($fp)
$L33:
	lw	$2,24($fp)
	blez	$2,$L29
	lw	$2,24($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$2,$3,$2
	lw	$4,40($fp)
	move	$5,$2
	jal	Swap
	lw	$4,40($fp)
	move	$5,$0
	lw	$6,24($fp)
	jal	PercDown
	lw	$2,24($fp)
	addiu	$2,$2,-1
	sw	$2,24($fp)
	b	$L33
$L29:
	move	$sp,$fp
	lw	$31,36($sp)
	lw	$fp,32($sp)
	addiu	$sp,$sp,40
	j	$31
	.end	Heapsort
	.align	2
	.globl	Merge
	.ent	Merge
	.type	Merge, @function
Merge:
	.frame	$fp,32,$31		# vars= 16, regs= 1/0, args= 0, gp= 8
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-32
	sw	$fp,24($sp)
	move	$fp,$sp
	sw	$4,32($fp)
	sw	$5,36($fp)
	sw	$6,40($fp)
	sw	$7,44($fp)
	lw	$2,44($fp)
	addiu	$2,$2,-1
	sw	$2,12($fp)
	lw	$2,40($fp)
	sw	$2,20($fp)
	lw	$3,48($fp)
	lw	$2,40($fp)
	subu	$2,$3,$2
	addiu	$2,$2,1
	sw	$2,16($fp)
$L37:
	lw	$2,40($fp)
	lw	$3,12($fp)
	slt	$2,$3,$2
	bne	$2,$0,$L41
	lw	$2,44($fp)
	lw	$3,48($fp)
	slt	$2,$3,$2
	bne	$2,$0,$L41
	lw	$2,40($fp)
	sll	$3,$2,2
	lw	$2,32($fp)
	addu	$4,$3,$2
	lw	$2,44($fp)
	sll	$3,$2,2
	lw	$2,32($fp)
	addu	$2,$3,$2
	lw	$3,0($4)
	lw	$2,0($2)
	slt	$2,$2,$3
	bne	$2,$0,$L39
	addiu	$7,$fp,20
	lw	$5,0($7)
	move	$2,$5
	sll	$3,$2,2
	lw	$2,36($fp)
	addu	$8,$3,$2
	addiu	$6,$fp,40
	lw	$3,0($6)
	move	$2,$3
	sll	$4,$2,2
	lw	$2,32($fp)
	addu	$2,$4,$2
	addiu	$3,$3,1
	sw	$3,0($6)
	lw	$2,0($2)
	sw	$2,0($8)
	addiu	$5,$5,1
	sw	$5,0($7)
	b	$L37
$L39:
	addiu	$7,$fp,20
	lw	$5,0($7)
	move	$2,$5
	sll	$3,$2,2
	lw	$2,36($fp)
	addu	$8,$3,$2
	addiu	$6,$fp,44
	lw	$3,0($6)
	move	$2,$3
	sll	$4,$2,2
	lw	$2,32($fp)
	addu	$2,$4,$2
	addiu	$3,$3,1
	sw	$3,0($6)
	lw	$2,0($2)
	sw	$2,0($8)
	addiu	$5,$5,1
	sw	$5,0($7)
	b	$L37
$L41:
	lw	$2,40($fp)
	lw	$3,12($fp)
	slt	$2,$3,$2
	bne	$2,$0,$L43
	addiu	$7,$fp,20
	lw	$5,0($7)
	move	$2,$5
	sll	$3,$2,2
	lw	$2,36($fp)
	addu	$8,$3,$2
	addiu	$6,$fp,40
	lw	$3,0($6)
	move	$2,$3
	sll	$4,$2,2
	lw	$2,32($fp)
	addu	$2,$4,$2
	addiu	$3,$3,1
	sw	$3,0($6)
	lw	$2,0($2)
	sw	$2,0($8)
	addiu	$5,$5,1
	sw	$5,0($7)
	b	$L41
$L43:
	lw	$2,44($fp)
	lw	$3,48($fp)
	slt	$2,$3,$2
	bne	$2,$0,$L44
	addiu	$7,$fp,20
	lw	$5,0($7)
	move	$2,$5
	sll	$3,$2,2
	lw	$2,36($fp)
	addu	$8,$3,$2
	addiu	$6,$fp,44
	lw	$3,0($6)
	move	$2,$3
	sll	$4,$2,2
	lw	$2,32($fp)
	addu	$2,$4,$2
	addiu	$3,$3,1
	sw	$3,0($6)
	lw	$2,0($2)
	sw	$2,0($8)
	addiu	$5,$5,1
	sw	$5,0($7)
	b	$L43
$L44:
	sw	$0,8($fp)
$L45:
	lw	$2,8($fp)
	lw	$3,16($fp)
	slt	$2,$2,$3
	beq	$2,$0,$L36
	lw	$2,48($fp)
	sll	$3,$2,2
	lw	$2,32($fp)
	addu	$4,$3,$2
	lw	$2,48($fp)
	sll	$3,$2,2
	lw	$2,36($fp)
	addu	$2,$3,$2
	lw	$2,0($2)
	sw	$2,0($4)
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	lw	$2,48($fp)
	addiu	$2,$2,-1
	sw	$2,48($fp)
	b	$L45
$L36:
	move	$sp,$fp
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	j	$31
	.end	Merge
	.align	2
	.globl	Median3
	.ent	Median3
	.type	Median3, @function
Median3:
	.frame	$fp,40,$31		# vars= 8, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$fp,32($sp)
	move	$fp,$sp
	.cprestore	16
	sw	$4,40($fp)
	sw	$5,44($fp)
	sw	$6,48($fp)
	lw	$3,44($fp)
	lw	$2,48($fp)
	addu	$3,$3,$2
	sra	$2,$3,31
	srl	$2,$2,31
	addu	$2,$3,$2
	sra	$2,$2,1
	sw	$2,24($fp)
	lw	$2,44($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$4,$3,$2
	lw	$2,24($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$2,$3,$2
	lw	$3,0($4)
	lw	$2,0($2)
	slt	$2,$2,$3
	beq	$2,$0,$L49
	lw	$2,44($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$4,$3,$2
	lw	$2,24($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$2,$3,$2
	move	$5,$2
	jal	Swap
$L49:
	lw	$2,44($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$4,$3,$2
	lw	$2,48($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$2,$3,$2
	lw	$3,0($4)
	lw	$2,0($2)
	slt	$2,$2,$3
	beq	$2,$0,$L50
	lw	$2,44($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$4,$3,$2
	lw	$2,48($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$2,$3,$2
	move	$5,$2
	jal	Swap
$L50:
	lw	$2,24($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$4,$3,$2
	lw	$2,48($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$2,$3,$2
	lw	$3,0($4)
	lw	$2,0($2)
	slt	$2,$2,$3
	beq	$2,$0,$L51
	lw	$2,24($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$4,$3,$2
	lw	$2,48($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$2,$3,$2
	move	$5,$2
	jal	Swap
$L51:
	lw	$2,24($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$4,$3,$2
	lw	$2,48($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$2,$3,$2
	addiu	$2,$2,-4
	move	$5,$2
	jal	Swap
	lw	$2,48($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$2,$3,$2
	lw	$2,-4($2)
	move	$sp,$fp
	lw	$31,36($sp)
	lw	$fp,32($sp)
	addiu	$sp,$sp,40
	j	$31
	.end	Median3
	.align	2
	.globl	Qsort
	.ent	Qsort
	.type	Qsort, @function
Qsort:
	.frame	$fp,48,$31		# vars= 16, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-48
	sw	$31,44($sp)
	sw	$fp,40($sp)
	move	$fp,$sp
	.cprestore	16
	sw	$4,48($fp)
	sw	$5,52($fp)
	sw	$6,56($fp)
	lw	$2,52($fp)
	addiu	$3,$2,3
	lw	$2,56($fp)
	slt	$2,$2,$3
	bne	$2,$0,$L53
	lw	$4,48($fp)
	lw	$5,52($fp)
	lw	$6,56($fp)
	jal	Median3
	sw	$2,32($fp)
	lw	$2,52($fp)
	sw	$2,24($fp)
	lw	$2,56($fp)
	addiu	$2,$2,-1
	sw	$2,28($fp)
$L56:
	lw	$2,24($fp)
	addiu	$2,$2,1
	sw	$2,24($fp)
	sll	$3,$2,2
	lw	$2,48($fp)
	addu	$2,$3,$2
	lw	$3,0($2)
	lw	$2,32($fp)
	slt	$2,$3,$2
	beq	$2,$0,$L58
	b	$L56
$L58:
	lw	$2,28($fp)
	addiu	$2,$2,-1
	sw	$2,28($fp)
	sll	$3,$2,2
	lw	$2,48($fp)
	addu	$2,$3,$2
	lw	$3,0($2)
	lw	$2,32($fp)
	slt	$2,$2,$3
	beq	$2,$0,$L59
	b	$L58
$L59:
	lw	$2,24($fp)
	lw	$3,28($fp)
	slt	$2,$2,$3
	beq	$2,$0,$L55
	lw	$2,24($fp)
	sll	$3,$2,2
	lw	$2,48($fp)
	addu	$4,$3,$2
	lw	$2,28($fp)
	sll	$3,$2,2
	lw	$2,48($fp)
	addu	$2,$3,$2
	move	$5,$2
	jal	Swap
	b	$L56
$L55:
	lw	$2,24($fp)
	sll	$3,$2,2
	lw	$2,48($fp)
	addu	$4,$3,$2
	lw	$2,56($fp)
	sll	$3,$2,2
	lw	$2,48($fp)
	addu	$2,$3,$2
	addiu	$2,$2,-4
	move	$5,$2
	jal	Swap
	lw	$2,24($fp)
	addiu	$2,$2,-1
	lw	$4,48($fp)
	lw	$5,52($fp)
	move	$6,$2
	jal	Qsort
	lw	$2,24($fp)
	addiu	$2,$2,1
	lw	$4,48($fp)
	move	$5,$2
	lw	$6,56($fp)
	jal	Qsort
	b	$L52
$L53:
	lw	$2,52($fp)
	sll	$3,$2,2
	lw	$2,48($fp)
	addu	$4,$3,$2
	lw	$3,56($fp)
	lw	$2,52($fp)
	subu	$2,$3,$2
	addiu	$2,$2,1
	move	$5,$2
	jal	InsertionSort
$L52:
	move	$sp,$fp
	lw	$31,44($sp)
	lw	$fp,40($sp)
	addiu	$sp,$sp,48
	j	$31
	.end	Qsort
	.align	2
	.globl	Quicksort
	.ent	Quicksort
	.type	Quicksort, @function
Quicksort:
	.frame	$fp,32,$31		# vars= 0, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	.cprestore	16
	sw	$4,32($fp)
	sw	$5,36($fp)
	lw	$2,36($fp)
	addiu	$2,$2,-1
	lw	$4,32($fp)
	move	$5,$0
	move	$6,$2
	jal	Qsort
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	j	$31
	.end	Quicksort
	.align	2
	.globl	Permute
	.ent	Permute
	.type	Permute, @function
Permute:
	.frame	$fp,40,$31		# vars= 8, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$fp,32($sp)
	move	$fp,$sp
	.cprestore	16
	sw	$4,40($fp)
	sw	$5,44($fp)
	sw	$0,24($fp)
$L65:
	lw	$2,24($fp)
	lw	$3,44($fp)
	slt	$2,$2,$3
	beq	$2,$0,$L66
	lw	$2,24($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$3,$3,$2
	lw	$2,24($fp)
	sw	$2,0($3)
	lw	$2,24($fp)
	addiu	$2,$2,1
	sw	$2,24($fp)
	b	$L65
$L66:
	li	$2,1			# 0x1
	sw	$2,24($fp)
$L68:
	lw	$2,24($fp)
	lw	$3,44($fp)
	slt	$2,$2,$3
	beq	$2,$0,$L64
	jal	myrand
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$5,$3,$2
	lw	$2,24($fp)
	sll	$3,$2,2
	lw	$2,40($fp)
	addu	$2,$3,$2
	move	$4,$2
	jal	Swap
	lw	$2,24($fp)
	addiu	$2,$2,1
	sw	$2,24($fp)
	b	$L68
$L64:
	move	$sp,$fp
	lw	$31,36($sp)
	lw	$fp,32($sp)
	addiu	$sp,$sp,40
	j	$31
	.end	Permute
	.align	2
	.globl	Checksort
	.ent	Checksort
	.type	Checksort, @function
Checksort:
	.frame	$fp,24,$31		# vars= 8, regs= 1/0, args= 0, gp= 8
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-24
	sw	$fp,16($sp)
	move	$fp,$sp
	sw	$4,24($fp)
	sw	$5,28($fp)
	sw	$0,8($fp)
$L72:
	lw	$2,8($fp)
	lw	$3,28($fp)
	slt	$2,$2,$3
	beq	$2,$0,$L73
	lw	$2,8($fp)
	sll	$3,$2,2
	lw	$2,24($fp)
	addu	$2,$3,$2
	lw	$3,0($2)
	lw	$2,8($fp)
	beq	$3,$2,$L74
	li	$2,1			# 0x1
	sw	$2,12($fp)
	b	$L71
$L74:
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L72
$L73:
	sw	$0,12($fp)
$L71:
	lw	$2,12($fp)
	move	$sp,$fp
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	j	$31
	.end	Checksort
	.align	2
	.globl	Copy
	.ent	Copy
	.type	Copy, @function
Copy:
	.frame	$fp,24,$31		# vars= 8, regs= 1/0, args= 0, gp= 8
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-24
	sw	$fp,16($sp)
	move	$fp,$sp
	sw	$4,24($fp)
	sw	$5,28($fp)
	sw	$6,32($fp)
	sw	$0,8($fp)
$L77:
	lw	$2,8($fp)
	lw	$3,32($fp)
	slt	$2,$2,$3
	beq	$2,$0,$L76
	lw	$2,8($fp)
	sll	$3,$2,2
	lw	$2,24($fp)
	addu	$4,$3,$2
	lw	$2,8($fp)
	sll	$3,$2,2
	lw	$2,28($fp)
	addu	$2,$3,$2
	lw	$2,0($2)
	sw	$2,0($4)
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L77
$L76:
	move	$sp,$fp
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	j	$31
	.end	Copy
	.align	2
	.globl	main
	.ent	main
	.type	main, @function
main:
	.frame	$fp,56,$31		# vars= 24, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$fp,48($sp)
	move	$fp,$sp
	.cprestore	16
	sw	$0,24($fp)
$L81:
	lw	$2,24($fp)
	slt	$2,$2,32
	beq	$2,$0,$L82
	la	$4,Arr2
	li	$5,32			# 0x20
	jal	Permute
	la	$4,Arr1
	la	$5,Arr2
	li	$6,32			# 0x20
	jal	Copy
	la	$4,Arr1
	li	$5,32			# 0x20
	jal	InsertionSort
	la	$4,Arr1
	li	$5,32			# 0x20
	jal	Checksort
	sw	$2,28($fp)
	lw	$2,28($fp)
	beq	$2,$0,$L84
	li	$2,1			# 0x1
	sw	$2,44($fp)
	b	$L80
$L84:
	la	$4,Arr1
	la	$5,Arr2
	li	$6,32			# 0x20
	jal	Copy
	la	$4,Arr1
	li	$5,32			# 0x20
	jal	Shellsort
	la	$4,Arr1
	li	$5,32			# 0x20
	jal	Checksort
	sw	$2,32($fp)
	lw	$2,32($fp)
	beq	$2,$0,$L85
	li	$2,1			# 0x1
	sw	$2,44($fp)
	b	$L80
$L85:
	la	$4,Arr1
	la	$5,Arr2
	li	$6,32			# 0x20
	jal	Copy
	la	$4,Arr1
	li	$5,32			# 0x20
	jal	Heapsort
	la	$4,Arr1
	li	$5,32			# 0x20
	jal	Checksort
	sw	$2,36($fp)
	lw	$2,36($fp)
	beq	$2,$0,$L86
	li	$2,1			# 0x1
	sw	$2,44($fp)
	b	$L80
$L86:
	la	$4,Arr1
	la	$5,Arr2
	li	$6,32			# 0x20
	jal	Copy
	la	$4,Arr1
	li	$5,32			# 0x20
	jal	Quicksort
	la	$4,Arr1
	li	$5,32			# 0x20
	jal	Checksort
	sw	$2,40($fp)
	lw	$2,40($fp)
	beq	$2,$0,$L83
	li	$2,1			# 0x1
	sw	$2,44($fp)
	b	$L80
$L83:
	lw	$2,24($fp)
	addiu	$2,$2,1
	sw	$2,24($fp)
	b	$L81
$L82:
	sw	$0,44($fp)
$L80:
	lw	$2,44($fp)
	move	$sp,$fp
	lw	$31,52($sp)
	lw	$fp,48($sp)
	addiu	$sp,$sp,56
	j	$31
	.end	main

	.comm	Arr1,128,4

	.comm	Arr2,128,4
	.ident	"GCC: (GNU) 3.4.5"

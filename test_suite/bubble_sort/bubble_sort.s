	.file	1 "bubble_sort.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.text
	.align	2
	.globl	main
	.ent	main
	.type	main, @function
main:
	.frame	$fp,104,$31		# vars= 72, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-104
	sw	$31,100($sp)
	sw	$fp,96($sp)
	move	$fp,$sp
	.cprestore	16
	sw	$0,88($fp)
$L2:
	lw	$2,88($fp)
	slt	$2,$2,16
	beq	$2,$0,$L3
	lw	$2,88($fp)
	sll	$3,$2,2
	addiu	$2,$fp,24
	addu	$4,$3,$2
	li	$3,15			# 0xf
	lw	$2,88($fp)
	subu	$2,$3,$2
	sw	$2,0($4)
	lw	$2,88($fp)
	addiu	$2,$2,1
	sw	$2,88($fp)
	b	$L2
$L3:
	addiu	$4,$fp,24
	li	$5,16			# 0x10
	jal	bubblesort
	sw	$0,88($fp)
$L5:
	lw	$2,88($fp)
	slt	$2,$2,16
	beq	$2,$0,$L6
	lw	$2,88($fp)
	sll	$3,$2,2
	addiu	$2,$fp,24
	addu	$2,$3,$2
	lw	$3,0($2)
	lw	$2,88($fp)
	beq	$3,$2,$L7
	li	$2,1			# 0x1
	sw	$2,92($fp)
	b	$L1
$L7:
	lw	$2,88($fp)
	addiu	$2,$2,1
	sw	$2,88($fp)
	b	$L5
$L6:
	sw	$0,92($fp)
$L1:
	lw	$2,92($fp)
	move	$sp,$fp
	lw	$31,100($sp)
	lw	$fp,96($sp)
	addiu	$sp,$sp,104
	j	$31
	.end	main
	.align	2
	.globl	swap
	.ent	swap
	.type	swap, @function
swap:
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
	sw	$2,8($fp)
	lw	$2,28($fp)
	sll	$3,$2,2
	lw	$2,24($fp)
	addu	$4,$3,$2
	lw	$2,32($fp)
	sll	$3,$2,2
	lw	$2,24($fp)
	addu	$2,$3,$2
	lw	$2,0($2)
	sw	$2,0($4)
	lw	$2,32($fp)
	sll	$3,$2,2
	lw	$2,24($fp)
	addu	$3,$3,$2
	lw	$2,8($fp)
	sw	$2,0($3)
	move	$sp,$fp
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	j	$31
	.end	swap
	.align	2
	.globl	bubblesort
	.ent	bubblesort
	.type	bubblesort, @function
bubblesort:
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
	lw	$2,52($fp)
	addiu	$2,$2,-1
	sw	$2,24($fp)
$L11:
	sw	$0,32($fp)
	sw	$0,28($fp)
$L14:
	lw	$2,28($fp)
	lw	$3,24($fp)
	slt	$2,$2,$3
	beq	$2,$0,$L15
	lw	$2,28($fp)
	sll	$3,$2,2
	lw	$2,48($fp)
	addu	$4,$3,$2
	lw	$2,28($fp)
	sll	$3,$2,2
	lw	$2,48($fp)
	addu	$2,$3,$2
	lw	$3,0($4)
	lw	$2,4($2)
	slt	$2,$2,$3
	beq	$2,$0,$L16
	lw	$2,28($fp)
	addiu	$2,$2,1
	lw	$4,48($fp)
	lw	$5,28($fp)
	move	$6,$2
	jal	swap
	li	$2,1			# 0x1
	sw	$2,32($fp)
$L16:
	lw	$2,28($fp)
	addiu	$2,$2,1
	sw	$2,28($fp)
	b	$L14
$L15:
	lw	$2,24($fp)
	addiu	$2,$2,-1
	sw	$2,24($fp)
	lw	$2,32($fp)
	beq	$2,$0,$L10
	b	$L11
$L10:
	move	$sp,$fp
	lw	$31,44($sp)
	lw	$fp,40($sp)
	addiu	$sp,$sp,48
	j	$31
	.end	bubblesort
	.ident	"GCC: (GNU) 3.4.5"

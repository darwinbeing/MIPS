	.file	1 "laplace.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.text
	.align	2
	.globl	fill_grid
	.ent	fill_grid
	.type	fill_grid, @function
fill_grid:
	.frame	$fp,24,$31		# vars= 8, regs= 1/0, args= 0, gp= 8
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-24
	sw	$fp,16($sp)
	move	$fp,$sp
	sw	$0,8($fp)
$L2:
	lw	$2,8($fp)
	slt	$2,$2,16
	beq	$2,$0,$L1
	sw	$0,12($fp)
$L5:
	lw	$2,12($fp)
	slt	$2,$2,16
	beq	$2,$0,$L4
	lw	$2,12($fp)
	bne	$2,$0,$L8
	la	$4,GRID
	lw	$2,8($fp)
	sll	$3,$2,4
	lw	$2,12($fp)
	addu	$2,$3,$2
	sll	$2,$2,1
	addu	$3,$2,$4
	li	$2,5000
	sh	$2,0($3)
	b	$L7
$L8:
	lw	$2,8($fp)
	bne	$2,$0,$L10
	la	$4,GRID
	lw	$2,8($fp)
	sll	$3,$2,4
	lw	$2,12($fp)
	addu	$2,$3,$2
	sll	$2,$2,1
	addu	$3,$2,$4
	li	$2,3000
	sh	$2,0($3)
	b	$L7
$L10:
	lw	$3,8($fp)
	li	$2,15			# 0xf
	bne	$3,$2,$L12
	la	$4,GRID
	lw	$2,8($fp)
	sll	$3,$2,4
	lw	$2,12($fp)
	addu	$2,$3,$2
	sll	$2,$2,1
	addu	$3,$2,$4
	li	$2,6000
	sh	$2,0($3)
	b	$L7
$L12:
	lw	$3,12($fp)
	li	$2,15			# 0xf
	bne	$3,$2,$L14
	la	$4,GRID
	lw	$2,8($fp)
	sll	$3,$2,4
	lw	$2,12($fp)
	addu	$2,$3,$2
	sll	$2,$2,1
	addu	$3,$2,$4
	li	$2,10000
	sh	$2,0($3)
	b	$L7
$L14:
	la	$4,GRID
	lw	$2,8($fp)
	sll	$3,$2,4
	lw	$2,12($fp)
	addu	$2,$3,$2
	sll	$2,$2,1
	addu	$2,$2,$4
	sh	$0,0($2)
$L7:
	lw	$2,12($fp)
	addiu	$2,$2,1
	sw	$2,12($fp)
	b	$L5
$L4:
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L2
$L1:
	move	$sp,$fp
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	j	$31
	.end	fill_grid
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
	jal	fill_grid
	sw	$0,24($fp)
$L17:
	lw	$2,24($fp)
	bgtz	$2,$L18
	li	$2,1			# 0x1
	sw	$2,28($fp)
$L20:
	lw	$2,28($fp)
	slt	$2,$2,15
	beq	$2,$0,$L19
	li	$2,1			# 0x1
	sw	$2,32($fp)
$L23:
	lw	$2,32($fp)
	slt	$2,$2,15
	beq	$2,$0,$L22
	la	$4,GRID
	lw	$2,28($fp)
	sll	$3,$2,4
	lw	$2,32($fp)
	addu	$2,$3,$2
	sll	$2,$2,1
	addu	$2,$2,$4
	sw	$2,36($fp)
	la	$4,GRID
	lw	$2,28($fp)
	sll	$3,$2,4
	lw	$2,32($fp)
	addu	$2,$3,$2
	sll	$2,$2,1
	addu	$2,$2,$4
	lh	$5,-32($2)
	la	$4,GRID
	lw	$2,28($fp)
	sll	$3,$2,4
	lw	$2,32($fp)
	addu	$2,$3,$2
	sll	$2,$2,1
	addu	$2,$2,$4
	lh	$2,32($2)
	addu	$5,$5,$2
	la	$4,GRID
	lw	$2,28($fp)
	sll	$3,$2,4
	lw	$2,32($fp)
	addu	$2,$3,$2
	sll	$2,$2,1
	addu	$2,$2,$4
	lh	$2,-2($2)
	addu	$5,$5,$2
	la	$4,GRID
	lw	$2,28($fp)
	sll	$3,$2,4
	lw	$2,32($fp)
	addu	$2,$3,$2
	sll	$2,$2,1
	addu	$2,$2,$4
	lh	$2,2($2)
	addu	$2,$5,$2
	sw	$2,40($fp)
	lw	$2,40($fp)
	bgez	$2,$L26
	lw	$3,40($fp)
	addiu	$3,$3,3
	sw	$3,40($fp)
$L26:
	lw	$3,40($fp)
	sra	$2,$3,2
	lw	$3,36($fp)
	sh	$2,0($3)
	lw	$2,32($fp)
	addiu	$2,$2,1
	sw	$2,32($fp)
	b	$L23
$L22:
	lw	$2,28($fp)
	addiu	$2,$2,1
	sw	$2,28($fp)
	b	$L20
$L19:
	lw	$2,24($fp)
	addiu	$2,$2,1
	sw	$2,24($fp)
	b	$L17
$L18:
	move	$2,$0
	move	$sp,$fp
	lw	$31,52($sp)
	lw	$fp,48($sp)
	addiu	$sp,$sp,56
	j	$31
	.end	main

	.comm	GRID,512,4
	.ident	"GCC: (GNU) 3.4.5"

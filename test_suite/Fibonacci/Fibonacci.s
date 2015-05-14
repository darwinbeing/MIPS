	.file	1 "Fibonacci.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.text
	.align	2
	.globl	Fib
	.ent	Fib
	.type	Fib, @function
Fib:
	.frame	$fp,48,$31		# vars= 8, regs= 3/0, args= 16, gp= 8
	.mask	0xc0010000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-48
	sw	$31,40($sp)
	sw	$fp,36($sp)
	sw	$16,32($sp)
	move	$fp,$sp
	.cprestore	16
	sw	$4,48($fp)
	lw	$2,48($fp)
	slt	$2,$2,2
	beq	$2,$0,$L2
	li	$2,1			# 0x1
	sw	$2,24($fp)
	b	$L1
$L2:
	lw	$2,48($fp)
	addiu	$2,$2,-1
	move	$4,$2
	jal	Fib
	move	$16,$2
	lw	$2,48($fp)
	addiu	$2,$2,-2
	move	$4,$2
	jal	Fib
	addu	$16,$16,$2
	sw	$16,24($fp)
$L1:
	lw	$2,24($fp)
	move	$sp,$fp
	lw	$31,40($sp)
	lw	$fp,36($sp)
	lw	$16,32($sp)
	addiu	$sp,$sp,48
	j	$31
	.end	Fib
	.align	2
	.globl	Fibonacci
	.ent	Fibonacci
	.type	Fibonacci, @function
Fibonacci:
	.frame	$fp,40,$31		# vars= 24, regs= 1/0, args= 0, gp= 8
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-40
	sw	$fp,32($sp)
	move	$fp,$sp
	sw	$4,40($fp)
	lw	$2,40($fp)
	slt	$2,$2,2
	beq	$2,$0,$L5
	li	$2,1			# 0x1
	sw	$2,24($fp)
	b	$L4
$L5:
	li	$2,1			# 0x1
	sw	$2,16($fp)
	li	$2,1			# 0x1
	sw	$2,12($fp)
	li	$2,2			# 0x2
	sw	$2,8($fp)
$L6:
	lw	$2,8($fp)
	lw	$3,40($fp)
	slt	$2,$3,$2
	bne	$2,$0,$L7
	lw	$3,12($fp)
	lw	$2,16($fp)
	addu	$2,$3,$2
	sw	$2,20($fp)
	lw	$2,12($fp)
	sw	$2,16($fp)
	lw	$2,20($fp)
	sw	$2,12($fp)
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L6
$L7:
	lw	$2,20($fp)
	sw	$2,24($fp)
$L4:
	lw	$2,24($fp)
	move	$sp,$fp
	lw	$fp,32($sp)
	addiu	$sp,$sp,40
	j	$31
	.end	Fibonacci
	.align	2
	.globl	main
	.ent	main
	.type	main, @function
main:
	.frame	$fp,48,$31		# vars= 8, regs= 3/0, args= 16, gp= 8
	.mask	0xc0010000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-48
	sw	$31,40($sp)
	sw	$fp,36($sp)
	sw	$16,32($sp)
	move	$fp,$sp
	.cprestore	16
	li	$4,7			# 0x7
	jal	Fib
	move	$16,$2
	li	$4,7			# 0x7
	jal	Fibonacci
	beq	$16,$2,$L10
	li	$2,1			# 0x1
	sw	$2,24($fp)
	b	$L9
$L10:
	sw	$0,24($fp)
$L9:
	lw	$2,24($fp)
	move	$sp,$fp
	lw	$31,40($sp)
	lw	$fp,36($sp)
	lw	$16,32($sp)
	addiu	$sp,$sp,48
	j	$31
	.end	main
	.ident	"GCC: (GNU) 3.4.5"

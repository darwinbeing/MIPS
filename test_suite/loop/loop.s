	.file	1 "loop.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.text
	.align	2
	.globl	main
	.ent	main
	.type	main, @function
main:
	.frame	$fp,64,$31		# vars= 48, regs= 1/0, args= 0, gp= 8
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-64
	sw	$fp,56($sp)
	move	$fp,$sp
	sw	$0,8($fp)
$L2:
	lw	$2,8($fp)
	slt	$2,$2,10
	beq	$2,$0,$L3
	lw	$2,8($fp)
	sll	$3,$2,2
	addiu	$2,$fp,8
	addu	$3,$3,$2
	lw	$2,8($fp)
	sw	$2,8($3)
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L2
$L3:
	move	$2,$0
	move	$sp,$fp
	lw	$fp,56($sp)
	addiu	$sp,$sp,64
	j	$31
	.end	main
	.ident	"GCC: (GNU) 3.4.5"

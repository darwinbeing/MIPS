	.file	1 "binarySearch.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.text
	.align	2
	.globl	binarySearch
	.ent	binarySearch
	.type	binarySearch, @function
binarySearch:
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
	sw	$7,36($fp)
$L2:
	lw	$2,28($fp)
	lw	$3,32($fp)
	slt	$2,$3,$2
	bne	$2,$0,$L3
	lw	$3,28($fp)
	lw	$2,32($fp)
	addu	$3,$3,$2
	sra	$2,$3,31
	srl	$2,$2,31
	addu	$2,$3,$2
	sra	$2,$2,1
	sw	$2,8($fp)
	lw	$2,8($fp)
	sll	$3,$2,2
	lw	$2,24($fp)
	addu	$2,$3,$2
	lw	$3,0($2)
	lw	$2,36($fp)
	slt	$2,$3,$2
	beq	$2,$0,$L4
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,28($fp)
	b	$L2
$L4:
	lw	$2,8($fp)
	sll	$3,$2,2
	lw	$2,24($fp)
	addu	$2,$3,$2
	lw	$3,0($2)
	lw	$2,36($fp)
	slt	$2,$2,$3
	beq	$2,$0,$L6
	lw	$2,8($fp)
	addiu	$2,$2,-1
	sw	$2,32($fp)
	b	$L2
$L6:
	lw	$2,8($fp)
	sw	$2,12($fp)
	b	$L1
$L3:
	lw	$2,28($fp)
	addiu	$2,$2,1
	subu	$2,$0,$2
	sw	$2,12($fp)
$L1:
	lw	$2,12($fp)
	move	$sp,$fp
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	j	$31
	.end	binarySearch
	.align	2
	.globl	main
	.ent	main
	.type	main, @function
main:
	.frame	$fp,552,$31		# vars= 520, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-552
	sw	$31,548($sp)
	sw	$fp,544($sp)
	move	$fp,$sp
	.cprestore	16
	sw	$0,536($fp)
$L9:
	lw	$2,536($fp)
	slt	$2,$2,128
	beq	$2,$0,$L10
	lw	$2,536($fp)
	sll	$3,$2,2
	addiu	$2,$fp,24
	addu	$3,$3,$2
	lw	$2,536($fp)
	sw	$2,0($3)
	lw	$2,536($fp)
	addiu	$2,$2,1
	sw	$2,536($fp)
	b	$L9
$L10:
	addiu	$4,$fp,24
	move	$5,$0
	li	$6,127			# 0x7f
	li	$7,128			# 0x80
	jal	binarySearch
	sw	$2,540($fp)
	move	$2,$0
	move	$sp,$fp
	lw	$31,548($sp)
	lw	$fp,544($sp)
	addiu	$sp,$sp,552
	j	$31
	.end	main
	.ident	"GCC: (GNU) 3.4.5"

	.file	1 "sdata_loop.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.text
	.align	2
	.globl	main
	.ent	main
	.type	main, @function
main:
	.frame	$fp,72,$31		# vars= 56, regs= 1/0, args= 0, gp= 8
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-72
	sw	$fp,64($sp)
	move	$fp,$sp
	addiu	$2,$fp,16
	sw	$2,56($fp)
	sw	$0,8($fp)
$L2:
	lw	$2,8($fp)
	slt	$2,$2,10
	beq	$2,$0,$L3
	lw	$3,56($fp)
	lw	$2,8($fp)
	addiu	$2,$2,1
	sb	$2,0($3)
	lw	$3,56($fp)
	lw	$2,8($fp)
	addiu	$2,$2,2
	sb	$2,1($3)
	lw	$3,56($fp)
	lw	$2,8($fp)
	addiu	$2,$2,3
	sb	$2,2($3)
	lw	$3,56($fp)
	lw	$2,8($fp)
	addiu	$2,$2,4
	sb	$2,3($3)
	lw	$2,56($fp)
	addiu	$2,$2,4
	sw	$2,56($fp)
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L2
$L3:
	addiu	$2,$fp,16
	sw	$2,56($fp)
	sw	$0,8($fp)
$L5:
	lw	$2,8($fp)
	slt	$2,$2,10
	beq	$2,$0,$L6
	lw	$3,56($fp)
	lw	$2,8($fp)
	addiu	$2,$2,-1
	sh	$2,0($3)
	lw	$3,56($fp)
	lw	$2,8($fp)
	addiu	$2,$2,-2
	sh	$2,2($3)
	lw	$2,56($fp)
	addiu	$2,$2,4
	sw	$2,56($fp)
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L5
$L6:
	addiu	$2,$fp,16
	sw	$2,56($fp)
	sw	$0,8($fp)
$L8:
	lw	$2,8($fp)
	slt	$2,$2,10
	beq	$2,$0,$L9
	lw	$3,56($fp)
	lw	$2,8($fp)
	addiu	$2,$2,-1
	sb	$2,0($3)
	lw	$3,56($fp)
	lw	$2,8($fp)
	addiu	$2,$2,-2
	sb	$2,1($3)
	lw	$3,56($fp)
	lw	$2,8($fp)
	addiu	$2,$2,-3
	sb	$2,2($3)
	lw	$3,56($fp)
	lw	$2,8($fp)
	addiu	$2,$2,-4
	sb	$2,3($3)
	lw	$2,56($fp)
	addiu	$2,$2,4
	sw	$2,56($fp)
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L8
$L9:
	addiu	$2,$fp,16
	sw	$2,56($fp)
	sw	$0,8($fp)
$L11:
	lw	$2,8($fp)
	slt	$2,$2,10
	beq	$2,$0,$L12
	lw	$2,56($fp)
	lb	$3,0($2)
	lw	$2,56($fp)
	lb	$2,1($2)
	addu	$3,$3,$2
	lw	$2,56($fp)
	lb	$2,2($2)
	addu	$3,$3,$2
	lw	$2,56($fp)
	lb	$2,3($2)
	addu	$2,$3,$2
	sw	$2,60($fp)
	lw	$2,56($fp)
	addiu	$2,$2,4
	sw	$2,56($fp)
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L11
$L12:
	addiu	$2,$fp,16
	sw	$2,56($fp)
	sw	$0,8($fp)
$L14:
	lw	$2,8($fp)
	slt	$2,$2,10
	beq	$2,$0,$L15
	lw	$2,56($fp)
	lbu	$3,0($2)
	lw	$2,56($fp)
	lbu	$2,1($2)
	addu	$3,$3,$2
	lw	$2,56($fp)
	lbu	$2,2($2)
	addu	$3,$3,$2
	lw	$2,56($fp)
	lbu	$2,3($2)
	addu	$2,$3,$2
	sw	$2,60($fp)
	lw	$2,56($fp)
	addiu	$2,$2,4
	sw	$2,56($fp)
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L14
$L15:
	addiu	$2,$fp,16
	sw	$2,56($fp)
	sw	$0,8($fp)
$L17:
	lw	$2,8($fp)
	slt	$2,$2,10
	beq	$2,$0,$L18
	lw	$2,56($fp)
	lh	$3,0($2)
	lw	$2,56($fp)
	lh	$2,2($2)
	addu	$2,$3,$2
	sw	$2,60($fp)
	lw	$2,56($fp)
	addiu	$2,$2,4
	sw	$2,56($fp)
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L17
$L18:
	addiu	$2,$fp,16
	sw	$2,56($fp)
	sw	$0,8($fp)
$L20:
	lw	$2,8($fp)
	slt	$2,$2,10
	beq	$2,$0,$L21
	lw	$2,56($fp)
	lhu	$3,0($2)
	lw	$2,56($fp)
	lhu	$2,2($2)
	addu	$2,$3,$2
	sw	$2,60($fp)
	lw	$2,56($fp)
	addiu	$2,$2,4
	sw	$2,56($fp)
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L20
$L21:
	move	$2,$0
	move	$sp,$fp
	lw	$fp,64($sp)
	addiu	$sp,$sp,72
	j	$31
	.end	main
	.ident	"GCC: (GNU) 3.4.5"

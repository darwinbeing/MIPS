	.file	1 "shang.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.globl	g_mainSetting
	.data
	.align	2
	.type	g_mainSetting, @object
	.size	g_mainSetting, 840
g_mainSetting:
	.ascii	"                   *\000"
	.ascii	"                  **\000"
	.ascii	"       *     *  *   \000"
	.ascii	"           *   ***  \000"
	.ascii	"*   *          *  * \000"
	.ascii	"           **    * *\000"
	.ascii	"  * **  *     *     \000"
	.ascii	"            *****   \000"
	.ascii	"   **    *   * *    \000"
	.ascii	"          * *   *** \000"
	.ascii	" * *   *   *  *     \000"
	.ascii	"      **    * *  *  \000"
	.ascii	"  *  *  *     * *   \000"
	.ascii	"          *  *  ** *\000"
	.ascii	" ***   *         *  \000"
	.ascii	" *  * * *   * *     \000"
	.ascii	"   **  * *    * *   \000"
	.ascii	"  *****           * \000"
	.ascii	"  *  *   * **  *    \000"
	.ascii	"    *  *  * * * *   \000"
	.ascii	"         * ***   ** \000"
	.ascii	"     ** *  *   * *  \000"
	.ascii	"        *** * *   * \000"
	.ascii	"  ***   *  *  *     \000"
	.ascii	"       *  ** * *  * \000"
	.ascii	"   ** * * *  * *    \000"
	.ascii	"    *  *  * *** *   \000"
	.ascii	"*****         *    *\000"
	.ascii	"   **    * * ***    \000"
	.ascii	"*  * * ***    *     \000"
	.ascii	"         ***  ** * *\000"
	.ascii	"     ** *   ** * *  \000"
	.ascii	"***   * *      ***  \000"
	.ascii	"      **   ** *** * \000"
	.ascii	" * * **  *** *      \000"
	.ascii	"* *** ***   **      \000"
	.ascii	"        *** * ** ***\000"
	.ascii	" **** **       ***  \000"
	.ascii	"**   *** *   **  ** \000"
	.ascii	"*   * * *****  **  *\000"
	.text
	.align	2
	.globl	initGame
	.ent	initGame
	.type	initGame, @function
initGame:
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
$L2:
	lw	$2,8($fp)
	slt	$2,$2,40
	beq	$2,$0,$L3
	sw	$0,12($fp)
$L5:
	lw	$2,12($fp)
	slt	$2,$2,21
	beq	$2,$0,$L4
	lw	$4,28($fp)
	lw	$3,8($fp)
	move	$2,$3
	sll	$2,$2,2
	addu	$2,$2,$3
	sll	$2,$2,2
	addu	$2,$2,$3
	addu	$3,$2,$4
	lw	$2,12($fp)
	addu	$5,$3,$2
	lw	$4,24($fp)
	lw	$3,8($fp)
	move	$2,$3
	sll	$2,$2,2
	addu	$2,$2,$3
	sll	$2,$2,2
	addu	$2,$2,$3
	addu	$3,$2,$4
	lw	$2,12($fp)
	addu	$2,$3,$2
	lbu	$2,0($2)
	sb	$2,0($5)
	lw	$2,12($fp)
	addiu	$2,$2,1
	sw	$2,12($fp)
	b	$L5
$L4:
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L2
$L3:
	sw	$0,8($fp)
$L8:
	lw	$2,8($fp)
	slt	$2,$2,20
	beq	$2,$0,$L9
	lw	$3,28($fp)
	lw	$2,8($fp)
	sll	$2,$2,2
	addu	$4,$2,$3
	lw	$3,24($fp)
	lw	$2,8($fp)
	sll	$2,$2,2
	addu	$2,$2,$3
	lw	$2,840($2)
	sw	$2,840($4)
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L8
$L9:
	sw	$0,8($fp)
$L11:
	lw	$2,8($fp)
	slt	$2,$2,40
	beq	$2,$0,$L1
	lw	$3,28($fp)
	lw	$2,8($fp)
	sll	$2,$2,2
	addu	$4,$2,$3
	lw	$3,24($fp)
	lw	$2,8($fp)
	sll	$2,$2,2
	addu	$2,$2,$3
	lw	$2,920($2)
	sw	$2,920($4)
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L11
$L1:
	move	$sp,$fp
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	j	$31
	.end	initGame
	.align	2
	.globl	my_strncmp
	.ent	my_strncmp
	.type	my_strncmp, @function
my_strncmp:
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
	sw	$0,12($fp)
	sw	$0,8($fp)
$L15:
	lw	$2,8($fp)
	lw	$3,32($fp)
	slt	$2,$2,$3
	beq	$2,$0,$L16
	lw	$3,24($fp)
	lw	$2,8($fp)
	addu	$4,$3,$2
	lw	$3,28($fp)
	lw	$2,8($fp)
	addu	$2,$3,$2
	lb	$3,0($4)
	lb	$2,0($2)
	slt	$2,$3,$2
	beq	$2,$0,$L18
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,12($fp)
	b	$L16
$L18:
	lw	$3,24($fp)
	lw	$2,8($fp)
	addu	$4,$3,$2
	lw	$3,28($fp)
	lw	$2,8($fp)
	addu	$2,$3,$2
	lb	$3,0($4)
	lb	$2,0($2)
	slt	$2,$2,$3
	beq	$2,$0,$L17
	li	$2,1			# 0x1
	sw	$2,12($fp)
	b	$L16
$L17:
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L15
$L16:
	lw	$2,12($fp)
	move	$sp,$fp
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	j	$31
	.end	my_strncmp
	.align	2
	.globl	my_strcpy
	.ent	my_strcpy
	.type	my_strcpy, @function
my_strcpy:
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
$L22:
	lw	$3,24($fp)
	lw	$2,8($fp)
	addu	$4,$3,$2
	lw	$3,28($fp)
	lw	$2,8($fp)
	addu	$2,$3,$2
	lbu	$2,0($2)
	sb	$2,0($4)
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	lw	$3,28($fp)
	lw	$2,8($fp)
	addu	$2,$3,$2
	lb	$2,0($2)
	beq	$2,$0,$L21
	b	$L22
$L21:
	move	$sp,$fp
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	j	$31
	.end	my_strcpy
	.align	2
	.globl	CheckConstraint
	.ent	CheckConstraint
	.type	CheckConstraint, @function
CheckConstraint:
	.frame	$fp,608,$31		# vars= 576, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-608
	sw	$31,604($sp)
	sw	$fp,600($sp)
	move	$fp,$sp
	.cprestore	16
	sw	$4,608($fp)
	sw	$5,612($fp)
	sw	$0,424($fp)
$L26:
	lw	$2,424($fp)
	slt	$2,$2,20
	beq	$2,$0,$L27
	sw	$0,428($fp)
$L29:
	lw	$2,428($fp)
	slt	$2,$2,20
	beq	$2,$0,$L28
	lw	$3,424($fp)
	move	$2,$3
	sll	$2,$2,2
	addu	$2,$2,$3
	sll	$3,$2,2
	addiu	$2,$fp,24
	addu	$3,$3,$2
	lw	$2,428($fp)
	addu	$5,$3,$2
	lw	$4,608($fp)
	lw	$3,428($fp)
	move	$2,$3
	sll	$2,$2,2
	addu	$2,$2,$3
	sll	$2,$2,2
	addu	$2,$2,$3
	addu	$3,$2,$4
	lw	$2,424($fp)
	addu	$2,$3,$2
	lbu	$2,0($2)
	sb	$2,0($5)
	lw	$2,428($fp)
	addiu	$2,$2,1
	sw	$2,428($fp)
	b	$L29
$L28:
	lw	$2,424($fp)
	addiu	$2,$2,1
	sw	$2,424($fp)
	b	$L26
$L27:
	sw	$0,424($fp)
$L32:
	lw	$2,424($fp)
	slt	$2,$2,40
	beq	$2,$0,$L33
	lw	$2,424($fp)
	sll	$3,$2,2
	addiu	$2,$fp,24
	addu	$4,$3,$2
	lw	$3,608($fp)
	lw	$2,424($fp)
	sll	$2,$2,2
	addu	$2,$2,$3
	lw	$2,920($2)
	sw	$2,408($4)
	lw	$2,424($fp)
	addiu	$2,$2,1
	sw	$2,424($fp)
	b	$L32
$L33:
	sw	$0,424($fp)
$L35:
	lw	$2,424($fp)
	slt	$2,$2,20
	beq	$2,$0,$L36
	sw	$0,428($fp)
$L38:
	lw	$2,428($fp)
	slt	$2,$2,40
	beq	$2,$0,$L39
	lw	$2,428($fp)
	sll	$3,$2,2
	addiu	$2,$fp,24
	addu	$2,$3,$2
	lw	$2,408($2)
	bne	$2,$0,$L41
	b	$L40
$L41:
	lw	$3,428($fp)
	move	$2,$3
	sll	$2,$2,2
	addu	$2,$2,$3
	sll	$2,$2,2
	addu	$2,$2,$3
	la	$3,g_mainSetting
	addu	$4,$2,$3
	lw	$3,424($fp)
	move	$2,$3
	sll	$2,$2,2
	addu	$2,$2,$3
	sll	$3,$2,2
	addiu	$2,$fp,24
	addu	$3,$2,$3
	lw	$2,612($fp)
	addiu	$2,$2,1
	move	$5,$3
	move	$6,$2
	jal	my_strncmp
	bne	$2,$0,$L40
	lw	$2,428($fp)
	sll	$3,$2,2
	addiu	$2,$fp,24
	addu	$2,$3,$2
	sw	$0,408($2)
	b	$L39
$L40:
	lw	$2,428($fp)
	addiu	$2,$2,1
	sw	$2,428($fp)
	b	$L38
$L39:
	lw	$2,428($fp)
	slt	$2,$2,40
	bne	$2,$0,$L37
	sw	$0,592($fp)
	b	$L25
$L37:
	lw	$2,424($fp)
	addiu	$2,$2,1
	sw	$2,424($fp)
	b	$L35
$L36:
	li	$2,1			# 0x1
	sw	$2,592($fp)
$L25:
	lw	$2,592($fp)
	move	$sp,$fp
	lw	$31,604($sp)
	lw	$fp,600($sp)
	addiu	$sp,$sp,608
	j	$31
	.end	CheckConstraint
	.align	2
	.globl	SolveGame
	.ent	SolveGame
	.type	SolveGame, @function
SolveGame:
	.frame	$fp,1128,$31		# vars= 1096, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-1128
	sw	$31,1124($sp)
	sw	$fp,1120($sp)
	move	$fp,$sp
	.cprestore	16
	sw	$4,1128($fp)
	sw	$5,1132($fp)
	lw	$3,1132($fp)
	li	$2,20			# 0x14
	bne	$3,$2,$L45
	li	$2,1			# 0x1
	sw	$2,1112($fp)
	b	$L44
$L45:
	sw	$0,24($fp)
$L46:
	lw	$2,24($fp)
	slt	$2,$2,40
	beq	$2,$0,$L47
	lw	$3,1128($fp)
	lw	$2,24($fp)
	sll	$2,$2,2
	addu	$2,$2,$3
	lw	$2,920($2)
	beq	$2,$0,$L48
	addiu	$2,$fp,32
	lw	$4,1128($fp)
	move	$5,$2
	jal	initGame
	lw	$2,1132($fp)
	sll	$3,$2,2
	addiu	$2,$fp,24
	addu	$3,$3,$2
	lw	$2,24($fp)
	sw	$2,848($3)
	lw	$2,24($fp)
	sll	$3,$2,2
	addiu	$2,$fp,24
	addu	$2,$3,$2
	sw	$0,928($2)
	addiu	$4,$fp,32
	lw	$3,1132($fp)
	move	$2,$3
	sll	$2,$2,2
	addu	$2,$2,$3
	sll	$2,$2,2
	addu	$2,$2,$3
	addu	$4,$4,$2
	lw	$3,24($fp)
	move	$2,$3
	sll	$2,$2,2
	addu	$2,$2,$3
	sll	$2,$2,2
	addu	$2,$2,$3
	la	$3,g_mainSetting
	addu	$2,$2,$3
	move	$5,$2
	jal	my_strcpy
	addiu	$2,$fp,32
	move	$4,$2
	lw	$5,1132($fp)
	jal	CheckConstraint
	bne	$2,$0,$L50
	b	$L48
$L50:
	addiu	$3,$fp,32
	lw	$2,1132($fp)
	addiu	$2,$2,1
	move	$4,$3
	move	$5,$2
	jal	SolveGame
	beq	$2,$0,$L48
	li	$2,1			# 0x1
	sw	$2,1112($fp)
	b	$L44
$L48:
	lw	$2,24($fp)
	addiu	$2,$2,1
	sw	$2,24($fp)
	b	$L46
$L47:
	sw	$0,1112($fp)
$L44:
	lw	$2,1112($fp)
	move	$sp,$fp
	lw	$31,1124($sp)
	lw	$fp,1120($sp)
	addiu	$sp,$sp,1128
	j	$31
	.end	SolveGame
	.align	2
	.globl	main
	.ent	main
	.type	main, @function
main:
	.frame	$fp,1120,$31		# vars= 1088, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	addiu	$sp,$sp,-1120
	sw	$31,1116($sp)
	sw	$fp,1112($sp)
	move	$fp,$sp
	.cprestore	16
	sw	$0,1104($fp)
$L53:
	lw	$2,1104($fp)
	slt	$2,$2,40
	beq	$2,$0,$L54
	lw	$2,1104($fp)
	sll	$3,$2,2
	addiu	$2,$fp,24
	addu	$3,$3,$2
	li	$2,1			# 0x1
	sw	$2,920($3)
	lw	$2,1104($fp)
	addiu	$2,$2,1
	sw	$2,1104($fp)
	b	$L53
$L54:
	addiu	$4,$fp,24
	move	$5,$0
	jal	SolveGame
	sw	$2,1108($fp)
	lw	$2,1108($fp)
	move	$sp,$fp
	lw	$31,1116($sp)
	lw	$fp,1112($sp)
	addiu	$sp,$sp,1120
	j	$31
	.end	main
	.ident	"GCC: (GNU) 3.4.5"

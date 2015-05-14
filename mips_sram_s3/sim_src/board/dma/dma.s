# Test DMA read/write operations
#
# DMA codes are assumed to be preloaded in instruction cache
#

#-----------------------------------------------#
# Device -> DMA -> Memory 
#-----------------------------------------------#

#-----------------------------------------------
# set memory write start address in DMA register  
#-----------------------------------------------
li $s0, 0xAFFFFFF4 
li $t0, 0
sw $t0, 0($s0) 

#-----------------------------------------------
# get number of words to transfer from ISSP
#-----------------------------------------------
li $s1, 0xAFFFFFE0
lw $t1, 0($s1)

#-----------------------------------------------
# set number of words to transfer in DMA register
#-----------------------------------------------
li $s1, 0xAFFFFFF8
sw $t1, 0($s1) 

#-----------------------------------------------
# set go and wr bits in DMA register
#-----------------------------------------------
li $s2, 0xAFFFFFFC
li $t2, 0x00000005
sw $t2, 0($s2) 

#-----------------------------------------------
# set write flag
#-----------------------------------------------
addi $a0, $0, 1

#-----------------------------------------------
# go to poll routine
#-----------------------------------------------
jal poll

#-----------------------------------------------#
# Memory -> DMA -> Device
#-----------------------------------------------#


#-----------------------------------------------
# set memory read start address in DMA register  
#-----------------------------------------------

li $s0, 0xAFFFFFF4 
li $t0, 0
sw $t0, 0($s0) 

#-----------------------------------------------
# get number of words to transfer from Memory
#-----------------------------------------------
li $s1, 0xAFFFFFE0
lw $t1, 0($s1)

#-----------------------------------------------
# set number of words to transfer in DMA register
#-----------------------------------------------
li $s1, 0xAFFFFFF8
sw $t1, 0($s1) 

#-----------------------------------------------
# set go and rd bits in DMA register
#-----------------------------------------------
li $s2, 0xAFFFFFFC
li $t2, 0x00000003
sw $t2, 0($s2) 
addi $a0, $0, 0

#-----------------------------------------------
# DMA receives data from device and send them to 
# memory or DMA receives data from memory and send them to 
# device. 
# CPU polls the done bit in DMA status register. 
# go to user codes when done.
#-----------------------------------------------
poll:  lw   $t3, 0($s2)
       andi $t3, $t3, 0x80
       bne  $t3, $0, exit
       beq  $0, $0, poll

exit:  beqz $a0, user
       jr $ra
      
# We may put instructions starting at zero
user: jr $0 


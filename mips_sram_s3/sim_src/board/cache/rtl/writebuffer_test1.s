######################################
# Test 2
######################################

addi $1, $0, 1
addi $2, $0, 2
addi $3, $0, 3
addi $4, $0, 4
addi $5, $0, 5
addi $6, $0, 6
addi $7, $0, 7
addi $8, $0, 8
addi $9, $0, 0x80

# byte overwrite first instruction 
sb $8, 0($9)

# load merge (b0)
lw $10, 0($9)

# write cache hit
sb $7, 1($9)

# load hit
lw $11, 0($9)

# write cache hit
sb $6, 2($9)

# load hit
lw $12, 0($9)

# store hit in wb
sh $5, 2($9)

# load hit in wb
lw $13, 0($9)

#------------------------------
#
#------------------------------

# write cache miss(8 + 1)
sb $8, 9($9)

# load merge(b1)
lw $10, 8($9)

# write cache miss(16 + 2)
sb $8, 18($9)

# load merge(b2)
lw $11, 16($9)

# store hit in wb(24 + 3)
sb $8, 27($9)

# load merge(b3)
lw $12, 24($9)

#------------------------------
# flush every line of wb
#------------------------------

# flush wb line 0
sw $8, 32($9)

# flush wb line 1
sw $8, 40($9)

# flush wb line 2
sw $8, 48($9)

# flush wb line 3
sw $8, 56($9)

#------------------------------
# wb is full now
#------------------------------

# write cache miss(8)
sh $8, 8($9)

# load merge(b1)
lw $13, 8($9)

# write cache miss(16 + 2)
sh $8, 18($9)

# load merge(b2)
lw $14, 16($9)

# write cache miss (24 + 4)
sh $8, 28($9)

# load merge(b3)
lw $15, 24($9)

# store hit in wb(32 + 6)
sh $8, 38($9)

# load merge(b3)
lw $16, 32($9)

#------------------------------
# flush every line of wb
#------------------------------

# flush wb line 0
sw $8, 0($9)

# flush wb line 1
sw $8, 8($9)

# flush wb line 2
sw $8, 16($9)

# flush wb line 3
sw $8, 24($9)

#------------------------------
# wb is full now
#------------------------------

# write cache miss(8)
sh $8, 8($9)

# load merge(b1)
lh $13, 10($9)

# write cache miss(16 + 2)
sh $8, 18($9)

# load merge(b2)
lb $14, 20($9)

# write cache miss (24 + 4)
sh $8, 28($9)

# load merge(b3)
lh $15, 30($9)

# store hit in wb(32 + 6)
sh $8, 38($9)

# load merge(b3)
lw $16, 32($9)


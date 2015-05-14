#--------------------------------------
# Draw a black box in the white screen 
#--------------------------------------


# center position
li $s0, 0x07A8 

# white 
li $s1, 0x7FFF

# black 
li $s2, 0

# video ram depth
li $s7, 8192 

start:      li $t0, 0 
vram_write: beq $t0, $s7, start
            beq $t0, $s0, black
white:      sw $s1,  0xE000($t0)
            beq $0, $0, next
black:      sw $s2,  0xE000($t0)
next:       addi $t0, $t0, 1 
            beq $0, $0, vram_write


.data
Multiples: .asciiz "2x2", "2x3", "2x4", "2x5", "3x2", "3x3", "3x4", "3x5", "4x2", "4x3", "4x4", "4x5", "5x2", "5x3", "5x4", "5x5"
Resultants: .word 4, 6, 8, 10, 6, 9, 12, 15, 8, 12, 16, 20, 10, 15, 20, 25
cord1: .asciiz "Please enter the coordinates of the first card(Ex:A1): "
cord2: .asciiz "Please enter the coordinates of the second card (Ex: A1): "
error: .asciiz "Please enter the valid coordinate!\n"
matched: .asciiz "This card has already been matched!\n"
inputBuffer: .space 4

.text
.globl initialize

initialize:
	li $v0, 9	# Alocate 64 bytes of mem for array
	li $a0, 64
	syscall
	
	move $s0, $v0	# arr address in $s0
	
	li $t0, 0	# loop counter for filling arr
	la $t1, Multiples	# Load adress for the array for card muls
	la $t2, Resultants	# Load address for the array of card nums
	
arrPopLoop:
	bge $t0, 8, initCounter	# Break loop if all 16 elements in the array
	
	li $v0, 42		# Generate int
	li $a1, 15		# upperbound of int
	syscall
	
	move $t4, $a0		# Make copy of basenum
	move $t6, $a0		
	
	# Grab mul
	mul $t6, $t6, 4
	add $t6, $t6, $t1	# Index
	lw $t3, 0($t6)		# $t3 = arr[Index]
	
	# Grab Coresponding num
	mul $t4, $t4, 4
	add $t4, $t4, $t2	# Index
	lw $t5, 0($t4)		# $t5 = arr[Index]
	
insertMul:
	li $v0, 42		# Generate int
	li $a1, 15		# upperbound of int
	syscall
	
	mul $a0, $a0, 4
	add $a0, $a0, $s0	# Index
	lw $t4, ($a0)		# $t4 = arr[Index]
	
	bgtz $t4, insertMul	# if there is content in there, jump to insertMul and redo
	
	sw $t3, ($a0)		# Save at address
	
insertRes:
	li $v0, 42		# Generate int
	li $a1, 16		# upperbound of int
	syscall
	
	mul $a0, $a0, 4
	add $a0, $a0, $s0	# Index
	lw $t4, 0($a0)		# $t4 = arr[Index]
	
	bgtz $t4, insertRes	# if there is content in there, jump to insertRes and redo
	
	sw $t5, 0($a0)		# Save at address
	
	add $t0, $t0, 1		# Update counter
	
	j arrPopLoop
	
#-----------------------------Game Now----------------------------#
initCounter:
	li $t0, 0	# Counter is zero
	jal topAxis

grabCard1:
	bge $t0, 8, end		# If all collected, end
	
	la $t3, grabCard1	# Get addy for label

	li $v0, 4		# Ask for cord1
	la $a0, cord1
	syscall
	
	li $v0, 8
	la $a0, inputBuffer
	li $a1, 4
	syscall
	move $s2, $a0		# Save address in reg $s3
	move $a0, $zero		# Clear $a0
	
	lb $t1, 1($s2)		# Load second byte
	lb $t2, ($s2)		# Load first byte
	
	bgtu $t2, 68, invalid	# If first cord not within range, jump to invalid
	bltu $t2, 65, invalid
	bgtu $t1, 52, invalid	# If second cord not within range, jump to invalid
	bltu $t1, 49, invalid
	
	add $t2, $t2, -65	# Letter - 65
	mul $t2, $t2, 16 	# Letter * 16
	add $t1, $t1, -49	# Num - 48
	mul $t1, $t1, 4		# Num * 4
	add $t2, $t2, $t1 	# index
	add $t4, $t2, $s0	# Address for Arr[index]
	
	add $t2, $t4, 3
	
	lb $t5, ($t2)		# last first byte
	bgtz $t5, matchedAlrd	# if last byte is bigger than zero, its alrady been matched, jump to try again
	
	add $t5, $t5, 1		# Increment by 1
	sb $t5, ($t2)		# Update the display for it
	
	jal topAxis
	
	add $t2, $t4, 2		#check if third byte is greater than zero, meaning it is a multiple
	lb $t8, ($t2)
	move $t9, $t4
	
	la $t3, resultCard1	# Get addy for label
	bgtz $t8, multiply
	
	lb $t8, ($t4)		# if not multiple get the resultant at first byte
	
	j grabCard2

resultCard1:
	move $t8, $t9
	
grabCard2:
	la $t3, grabCard2	# Get addy for label

	li $v0, 4		# Ask for cord2
	la $a0, cord2
	syscall
	
	li $v0, 8
	la $a0, inputBuffer
	li $a1, 4
	syscall
	move $s2, $a0		# Save address in reg $s3
	move $a0, $zero		# Clear $a0
	
	lb $t1, 1($s2)		# Load second byte
	lb $t2, ($s2)		# Load first byte
	
	bgt $t2, 68, invalid	# If first cord not within range, jump to invalid
	blt $t2, 65, invalid
	bgt $t1, 52, invalid	# If second cord not within range, jump to invalid
	blt $t1, 49, invalid
	
	add $t2, $t2, -65	# Letter - 65
	mul $t2, $t2, 16 	# Letter * 16
	add $t1, $t1, -49	# Num - 48
	mul $t1, $t1, 4		# Num * 4
	add $t2, $t2, $t1 	# index
	add $t7, $t2, $s0	# Address for Arr[index]
	
	add $t3, $t7, 3
	
	lb $t6, ($t3)		# last first byte
	bgtz $t6, matchedAlrd	# if last byte is bigger than zero, its alrady been matched, jump to try again
	
	add $t6, $t6, 1		# Increment by 1
	sb $t6, ($t3)		# Update the display for it
	
	jal topAxis
	
	add $t2, $t7, 2		#check if third byte is greater than zero, meaning it is a multiple
	lb $t1, ($t2)
	move $t9, $t4
	
	la $t3, resultCard2	# Get addy for label
	bgtz $t1, multiply
	
	lb $t9, ($t7)		# if not multiple get the resultant at first byte		
	
resultCard2:
	move $t2, $t9
	
checkMatch:
	bne $t2, $t8, notMatch	# If not equal jump back
	add $t0, $t0, 1		# Incriment Match counter
	la $t2, grabCard1	# get adress to go back to game
	jalr $t2		# Loop again
	
notMatch:
	add $t5, $t5, -1	# Subtract bit to make it into 0
	add $t6, $t6, -1
	
	sb $t5, ($t4)		# Save the change
	sb $t6, ($t7)
	
	la $t2, grabCard1	# get address to go back to game
	
	jalr $t2		# Loop again
	
multiply:
	add $t9, $t9, 2
	lb $t1, ($t9)
	andi $t1,$t1,0x0F	# convert ascii to int
	add $t9, $t9, -2
	lb $t2, ($t9)
	andi $t2,$t2,0x0F	# convert ascii to int
	
	mul $t9, $t1, $t2	# Multiply the nums
	
	jr $t3			# Jump back to calling function

invalid:
	li $v0, 4
	la $a0, error
	syscall
	jr $t3
	
matchedAlrd:
	li $v0, 4
	la $a0, matched
	syscall
	jr $t3

end:
	li $v0, 10
	syscall

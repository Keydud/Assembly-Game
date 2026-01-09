.data
.globl Multiples
.globl Resultants
.globl cord1
.globl cord2
.globl error
.globl matched
.globl inputBuffer
Multiples: .asciiz "2x2", "2x3", "2x4", "2x5", "3x2", "3x3", "3x4", "3x5", "4x2", "4x3", "4x4", "4x5", "5x2", "5x3", "5x4", "5x5"
Resultants: .word 4, 6, 8, 10, 6, 9, 12, 15, 8, 12, 16, 20, 10, 15, 20, 25
cord1: .asciiz "Please enter the coordinates of the first card(Ex:A1): "
cord2: .asciiz "Please enter the coordinates of the second card (Ex: A1): "
error: .asciiz "Please enter the valid coordinate!\n"
matched: .asciiz "This card has already been matched!\n"
inputBuffer: .word
empty: .asciiz "     "
xaxis: .asciiz "   1      2      3      4   \n"
top: .asciiz ".-----..-----..-----..-----.\n"
bot: .asciiz "'-----''-----''-----''-----'\n"
title: .asciiz "'||    ||'     |     |''||''|   ..|'''.| '||'  '||' |''||''| '||'  '||' '||''''|  \n |||  |||     |||       ||    .|'     '   ||    ||     ||     ||    ||   ||  .    \n |'|..'||    |  ||      ||    ||          ||''''||     ||     ||''''||   ||''|    \n | '|' ||   .''''|.     ||    '|.      .  ||    ||     ||     ||    ||   ||       \n.|. | .||. .|.  .||.   .||.    ''|....'  .||.  .||.   .||.   .||.  .||. .||.....| \n                                                                                  \n                                                                                  \n  ..|'''.|     |     '||''|.   '||''|.    .|'''.|   .|'''.|   .|'''.|   .|'''.|   \n.|'     '     |||     ||   ||   ||   ||   ||..  '   ||..  '   ||..  '   ||..  '   \n||           |  ||    ||''|'    ||    ||   ''|||.    ''|||.    ''|||.    ''|||.   \n'|.      .  .''''|.   ||   |.   ||    || .     '|| .     '|| .     '|| .     '||  \n ''|....'  .|.  .||. .||.  '|' .||...|'  |'....|'  |'....|'  |'....|'  |'....|'   \n                                                                                  \n                                                                                  \n"
start: "Start the game? (Y=1/N=0): "

.text
.globl main
.globl init
.globl topAxis
main:
	li $v0, 4
	la $a0, title
	syscall
	
	la $a0, start
	syscall
	
	li $v0, 5
	syscall
	
	beqz $v0, end	# if 0 end program
	li $s4, 0		# True or nah
	
init:
	j initialize
	
topAxis:
	li $s3, 0		# Counter
    li $v0, 4
    la $a0, xaxis
    syscall

cardTop:
    li $v0, 4        # Create top border
    la $a0, top
    syscall

cardFace:
    bge $s3, 16, game  # If $s3 >= 16, exit the game loop and jump to exit point

    li $v0, 11       # Create left wall
    li $a0, 124
    syscall

    la $a0, empty
    li $v0, 4
    syscall

cheat:
    li $v0, 11       # Create left wall again
    li $a0, 124
    syscall

    add $s3, $s3, 1   # Increment counter (this will count up to 16)

    rem $t9, $s3, 4    # Get the remainder when divided by 4
    beqz $t9, indent   # If remainder is 0, jump to indent (happens every 4th iteration)

    j cardFace         # Loop back to cardFace

indent:
    li $v0, 11        # New line (indentation)
    li $a0, 10
    syscall

cardBot:
    li $v0, 4         # Create bottom border
    la $a0, bot
    syscall

    ble $s3, 16, cardTop  # Continue loop if $s3 <= 16, otherwise jump to game exit
    
game:
	jr $ra	# Jump to continue game without initializing over again
	
checkValues:
	mul $s4, $s3, 4
	add $s4, $s4, 3
	add $s4, $s4, $s0
	lb $s5, ($s4)		# Load last byte to check
	beqz $s4, printSpace
	
	mul $s4, $s3, 4
	add $s4, $s4, 2
	add $s4, $s4, $s0
	lb $s5, ($s4)		# Load second to last last byte to check
	beqz $s4, printInt
	
	li $v0, 11
	li $a0, 32
	syscall
	
	li $v0, 11
	mul $s4, $s3, 4		# Print leading numb
	add $s4, $s4, 0
	add $s4, $s4, $s0
	lb $s5, ($s4)
	move $a0, $s5
	syscall
	
	li $a0, 78 		# Print middle
	syscall
	
	mul $s4, $s3, 4		# Print last byte
	add $s4, $s4, 2
	add $s4, $s4, $s0
	lb $s5, ($s4)
	move $a0, $s5
	syscall
	
printSpace:
	la $a0, empty
    	li $v0, 4
   	syscall
   	
   	j cheat
   	
printInt:
	li $v0, 11
	li $a0, 32
	syscall
	syscall
	
	mul $s4, $s3, 4
	add $s4, $s4, $s0
	lb $s5, ($s4)
	
	li $v0, 1
	move $a0, $s5
	syscall
	
	j cheat
end:
	li $v0, 10
	syscall
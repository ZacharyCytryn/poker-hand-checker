.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
addr_arg4: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Output messages
straight_str: .asciiz "STRAIGHT_HAND"
four_str: .asciiz "FOUR_OF_A_KIND_HAND"
pair_str: .asciiz "TWO_PAIR_HAND"
unknown_hand_str: .asciiz "UNKNOWN_HAND"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION"
invalid_args_error: .asciiz "INVALID_ARGS"

# Put your additional .data declarations here, if any.


# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory  
    sw $a0, num_args
    beqz $a0, zero_args
    li $t0, 1
    beq $a0, $t0, one_arg
    li $t0, 2
    beq $a0, $t0, two_args
    li $t0, 3
    beq $a0, $t0, three_args
    li $t0, 4
    beq $a0, $t0, four_args
five_args:
    lw $t0, 16($a1)
    sw $t0, addr_arg4
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here

zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory

start_coding_here:
    # Start the assignment by writing your code here
    lw $a0 addr_arg0			#loads word from addr_arg0
    lbu $t1 1($a0)			#checks if argument is larger than a single character
    bnez $t1 invalid_operation		#if it is longer than one character, it is an invalid operation
    lbu $t1 0($a0)			#loads letter into $t1
    li $t2 'E'				#loads E into $t2
    li $t3 'D'				#loads D into $t3
    li $t4 'P'				#loads P into $t4
    beq $t1 $t2 continue_e		#if first argument is E, continue_e
    beq $t1 $t3 continue_d		#if first argument is D, continue_d
    beq $t1 $t4 continue_p		#if first argument is P, continue_p
    j invalid_operation			#jumps to invalid_operation where error is printed. $t0, $t1, $t2, $t3, $t4 may be used.
    
continue_e:
   lw $t0 num_args			#loads num_args into $t0
   li $t1 5				#loads 5 into $t1 (expected args)
   bne $t0 $t1 invalid_args		#if num_args != 5, invalid_args. $t0 and $t1 are now available

   lw $a0 addr_arg1			#loads address into $a0
   lbu $s0 0($a0)			#loads second argument into $s0
   addi $s0 $s0 -48			#Adjusts ASCII value
   lbu $t1 1($a0)			#loads second digit (if applicable) into $t1
   beqz $t1 e_second_arg_one_digit	#if there is only one digit, skip to e_second_arg_one_digit
   addi $t1 $t1 -48			#Adjusts ASCII value
   li $t2 10				#This is for the place multiplier
   mult $s0 $t2				#Sets 10 place
   mflo $s0				#Moves to $s0
   add $s0 $s0 $t1			#Actual number
   lbu $t1 2($a0)			#Loads third digit if applicable
   bnez $t1 invalid_args		#If there is a third digit, invalid_args
   e_second_arg_one_digit:
   li $t1 63				#loads 63 (upper limit for second arg) into $t1
   bgt $s0 $t1 invalid_args		#checks if second argument is greater than upper limit. $t0 and $t1 are available.
   
   lw $a0 addr_arg2			#loads addr_arg2 into $a0
   lbu $s1 0($a0)			#loads third argument into $s1
   addi $s1 $s1 -48			#Adjusts ASCII value
   lbu $t1 1($a0)			#loads second digit (if applicable) into $t1
   beqz $t1 e_third_arg_one_digit	#if there is only one digit, skip to e_third_arg_one_digit
   addi $t1 $t1 -48			#Adjusts ASCII value
   li $t2 10				#This is for the place multiplier
   mult $s1 $t2				#Sets 10 place
   mflo $s1				#Moves to $s1
   add $s1 $s1 $t1			#Actual number
   lbu $t1 2($a0)			#Loads third digit if applicable
   bnez $t1 invalid_args		#If there is a third digit, invalid_args
   e_third_arg_one_digit:
   li $t1 31				#loads 31 (upper limit for third/fourth arg) into $t1
   bgt $s1 $t1 invalid_args		#checks if third argument is greater than upper limit. $t0 is available, $t1 is kept.
   
   lw $a0 addr_arg3			#loads addr_arg3 into $a0
   lbu $s2 0($a0)			#loads fourth argument in $s2
   addi $s2 $s2 -48			#Adjusts ASCII value
   lbu $t1 1($a0)			#loads second digit into $t1 if applicable
   beqz $t1 e_fourth_arg_one_digit	#if there is only one digit, skip to e_fourth_arg_one_digit
   addi $t1 $t1 -48			#Adjusts ASCII value
   li $t2 10				#This is for the place multiplier
   mult $s2 $t2				#Sets 10 place
   mflo $s2				#Moves to $s2
   add $s2 $s2 $t1			#Actual number
   lbu $t1 2($a0)			#Loads third digit if applicable
   bnez $t1 invalid_args		#If there is a third digit, invalid_args
   e_fourth_arg_one_digit:
   li $t1 31				#loads 31 (upper limit for third/fourth arg) into $t1
   bgt $s2 $t1 invalid_args		#checks if fourth argument is greater than upper limit. $t0 and $t1 are available.
   
   lw $a0 addr_arg4			#loads addr_arg4 into $a0
   li $s3 0				#Zeroes out $s3
   lbu $t1 0($a0)			#loads 10000 place
   addi $t1 $t1 -48			#Adjusts ASCII value
   li $t2 10000				#multiplier
   mult $t1 $t2				#Adjusts place value
   mflo $t1				#Moves product to $t1
   add $s3 $s3 $t1			#Adds adjusted place to $s3
   lbu $t1 1($a0)			#Loads 1000 place
   addi $t1 $t1 -48			#Adjusts ASCII value
   li $t2 1000				#multiplier
   mult $t1 $t2				#Adjusts place value
   mflo $t1				#Moves product to $t1
   add $s3 $s3 $t1			#Adds adjusted place to $s3
   lbu $t1 2($a0)			#Loads 100 place
   addi $t1 $t1 -48			#Adjusts ASCII value
   li $t2 100				#multiplier
   mult $t1 $t2				#Adjusts place value
   mflo $t1				#Moves product to $t1
   add $s3 $s3 $t1			#Adds adjusted place to $s3
   lbu $t1 3($a0)			#Loads 10 place
   addi $t1 $t1 -48			#Adjusts ASCII value
   li $t2 10				#multiplier
   mult $t1 $t2				#Adjusts place value
   mflo $t1				#Moves product to $t1
   add $s3 $s3 $t1			#Adds adjusted place to $s3
   lbu $t1 4($a0)			#Loads 1 place
   addi $t1 $t1 -48			#Adjusts ASCII value
   add $s3 $s3 $t1			#Adds adjusted place to $t1
   li $t1 65535				#loads 65535 (upper limit for fifth arg) into $t1
   bgt $s3 $t1 invalid_args		#checks if fifth argument is greater than upper limit. $t0 and $t1 are available.
   
   li $a0 0				#Zeroes out $s4
   sll $s0 $s0 26			#Shifts opcode to proper spot
   sll $s1 $s1 21			#Shifts rs to proper spot
   sll $s2 $s2 16			#Shifts rt to proper spot
   add $a0 $a0 $s0			#Adds opcode to argument
   add $a0 $a0 $s1			#Adds rs to argument
   add $a0 $a0 $s2			#Adds rt to argument
   add $a0 $a0 $s3			#Adds immediate to argument
   
   li $v0 34				#Loads print hex return value
   syscall
   j exit
   
continue_d:
   lw $a0 addr_arg1			#Loads second arg
   lbu $t1 0($a0)			#This code could cycle through argument
   addi $t1 $t1 -48			#Adjusts ASCII value
   bnez $t1 invalid_args		#If the first character of the first argument is not 0, invalid_args
   lbu $t1 1($a0)			#Loads 'x' into $t1
   li $t2 120				#Loads the ASCII value of 'x' into $t2
   bne $t1 $t2 invalid_args		#If $t1 is not 'x', invalid_args
   lbu $t8 10($a0)			#Should be zero (hex should only be 10 chars long [8 digits])
   bnez $t8 invalid_args		#If hex is longer than 10 chars, invalid_args
   
   li $t3 0				#loop counter
   li $t4 8				#If loop counter == 8, end loop
   addi $a0 $a0 2			#Skips over 0x
   li $t5 54				#upper bound
   li $t6 9				#NUMBER upper bound
   li $t7 49				#LETTER lower bound; Value must be between 0-9 or 49-54 inclusive. Lower bound is 0
   d_loop:
   	beq $t3 $t4 d_loop_exit		#Exit condition
   	lbu $t1 0($a0)			#loads in current digit
   	addi $t1 $t1 -48		#Adjusts ASCII value
   	bltz $t1 invalid_args		#If less than 0, invalid_args
   	bgt $t1 $t5 invalid_args	#If greater than upper bound, invalid_args
   	bge $t1 $t7 continue_d_loop	#jumps to continue_d_loop if $t1 is a letter
   	ble $t1 $t6 continue_d_loop	#jumps to continue_d_loop if $t1 is a digit
   	j invalid_args			#jumps to invalid args if neither letter or digit
   continue_d_loop:
   	addi $t3 $t3 1			#Increments counter
   	addi $a0 $a0 1			#Increments place in hex arg
   	j d_loop			#Jumps back to loop
   
   d_loop_exit:
   lw $t0 num_args			#loads num_args into $t0
   li $t1 2				#loads 2 into $t1 (expected args)
   bne $t0 $t1 invalid_args		#if num_args != 2, invalid_args
   
   lw $a0 addr_arg1			#loads second argument into $a0
   li $s0 0				#Zeroes out $s0
   addi $a0 $a0 2			#Skips over 0x
   lbu $a1 0($a0)			#loads first digit in hex
   jal find_value			#find_value function
   move $t0 $v0				#Moves return value from function to $t0
   sll $t0 $t0 2			#Adjusts hex value
   add $s0 $s0 $t0			#Adds first digit value to $s0
   lbu $a1 1($a0)			#Loads second digit in hex
   jal find_value			#find_value function
   move $t0 $v0				#Moves return value from function to $t0
   srl $t0 $t0 2			#Adjusts hex value
   add $s0 $s0 $t0			#Adds to $s0. $s0 is now opcode
   
   move $t0 $v0				#Move return value of second digit back to $t0
   andi $t0 $t0 0x3			#Only uses rs relevant values
   li $s1 0				#Zeroes out s1 for rs
   sll $t0 $t0 3			#Shifts to proper value
   add $s1 $s1 $t0			#Adds to $s1
   lbu $a1 2($a0)			#Loads third digit
   jal find_value			#find_value function
   move $t0 $v0				#Moves return value from function to $t0
   srl $t0 $t0 1			#Fixes hex for rs
   add $s1 $s1 $t0			#Adds value to $s1
   
   move $t0 $v0				#Moves return value from function to $t0
   andi $t0 $t0 0x1			#Adjusts hex value
   sll $t0 $t0 4			#Shifts hex value
   li $s2 0				#Zeroes out rt field $s2
   add $s2 $s2 $t0			#Adds hex to $s2
   lbu $a1 3($a0)			#Loads fourth digit
   jal find_value			#find_value function
   move $t0 $v0				#Moves return value from function to $t0
   add $s2 $s2 $t0			#Adds value to $s2, no need to shift
   
   lbu $a1 4($a0)			#Loads fifth digit
   jal find_value			#find_value function
   move $t0 $v0				#Moves return value from function to $t0
   li $s3 0				#Zeroes out s3 for immediate
   sll $t0 $t0 12			#Adjusts hex value
   add $s3 $s3 $t0			#Adds to immediate register
   lbu $a1 5($a0)			#Loads sixth digit
   jal find_value			#find_value function
   move $t0 $v0				#Moves return value from function to $t0
   sll $t0 $t0 8			#Adjusts hex value
   add $s3 $s3 $t0			#Adds to immediate register
   lbu $a1 6($a0)			#Loads seventh digit
   jal find_value			#find_value function
   move $t0 $v0				#Moves return value from function to $t0
   sll $t0 $t0 4			#Adjusts hex value
   add $s3 $s3 $t0			#Adds to immediate register
   lbu $a1 7($a0)			#Loads eighth (last) digit
   jal find_value			#find_value function
   move $t0 $v0				#Moves return value from function to $t0
   add $s3 $s3 $t0			#Adds to immediate register (no need to shift)
   j exit_find_value
     
   find_value:
   	addi $sp $sp -4			#make space on stack
   	sw $s0 0($sp)			#preserve $s0
   	li $t7 58			#Above this bound is letters, below is numbers
   	bgt $a1 $t7 letter_value	#If digit is larger than number ASCII, then find letter value
   	blt $a1 $t7 number_value	#Otherwise, find number value
   	letter_value:
   		addi $s0 $a1 -87	#Converts letter ASCII value to actual hex value
   		j end_value		#jump to end_value
   	number_value:
   		addi $s0 $a1 -48  	#Converts number ASCII value
   		j end_value		#jump to end_value
   	end_value:
   	move $v0 $s0			#Set return value
   	lw $s0 0($sp)			#Put original $s0 value back
   	addi $sp $sp 4			#Deallocate stack space
   	jr $ra				#Return to caller
   	
   exit_find_value:
   li $t0 10				#If less than 10, print extra zero
   bgt $s0 $t0 opcode_end		#If greater than 10, skip print zero
   li $a0 0				#load print zero
   li $v0 1				#loads syscall
   syscall
   opcode_end:
   move $a0 $s0				#Moves opcode to arg
   li $v0 1				#loads syscall
   syscall
   
   li $a0 32				#loads space ASCII value
   li $v0 11				#loads syscall
   syscall
   
   bgt $s1 $t0 rs_end			#If greater than 10, skip print zero
   li $a0 0				#loads print zero
   li $v0 1				#loads syscall
   syscall
   rs_end:
   move $a0 $s1				#Moves rs to arg
   li $v0 1				#loads syscall
   syscall
   
   li $a0 32				#Loads space ASCII value
   li $v0 11				#loads syscall
   syscall
   
   bgt $s2 $t0 rt_end			#If greater than 10, skip print zero
   li $a0 0				#loads print zero
   li $v0 1				#loads syscall
   syscall
   rt_end:
   move $a0 $s2				#Moves rt to arg
   li $v0 1				#Loads syscall
   syscall
   
   li $a0 32				#loads space ASCII value
   li $v0 11				#Loads syscall
   syscall
   
   li $t0 10000				#Checker to see if number is greater than 10000
   bge $s3 $t0 print_imm		#if greater than 10000, skip print zero
   li $a0 0				#loads print zero
   li $v0 1				#loads syscall
   syscall
   li $t0 1000				#Checker to see if number is greater than 1000
   bge $s3 $t0 print_imm		#if greater than 1000, skip print zero
   li $a0 0				#loads print zero
   li $v0 1				#loads syscall
   syscall
   li $t0 100				#Checker to see if number is greater than 100
   bge $s3 $t0 print_imm		#If greater than 100, skip print zero
   li $a0 0				#loads print zero
   li $v0 1				#loads syscall
   syscall
   li $t0 10				#checker to see if number greater than 10
   bge $s3 $t0 print_imm		#If greater than 10, skip print zero
   li $a0 0				#loads print zero
   li $v0 1				#loads syscall
   syscall
   
   print_imm:
   move $a0 $s3				#Moves immediate to arg
   li $v0 1				#Loads syscall
   syscall
   j exit

continue_p:
   lw $t0 num_args			#loads num_args into $t0
   li $t1 2				#loads 2 into $t1 (expected args)
   bne $t0 $t1 invalid_args		#if num_args != 2, invalid_args
   lw $a0 addr_arg1			#Loads second argument into $a0
   
   lbu $s0 0($a0)			#Loads first card
   andi $s0 $s0 0x0F			#Card value only
   lbu $s1 1($a0)			#Loads second card
   andi $s1 $s1 0x0F			#Card value only
   lbu $s2 2($a0)			#Loads third card
   andi $s2 $s2 0x0F			#Card value only
   lbu $s3 3($a0)			#Loads fourth card
   andi $s3 $s3 0x0F			#Card value only
   lbu $s4 4($a0)			#Loads fifth card
   andi $s4 $s4 0x0F			#Card value only
   
   #sorter
   move $a1 $s0				#moves $s0 to $a1
   move $a2 $s1				#moves $s1 to $a2
   jal card_switcher			#function call
   move $s0 $v0				#set value
   move $s1 $v1				#set value
   
   move $a1 $s0				#Moves $s0 to $a1
   move $a2 $s2				#moves $s2 to $a2
   jal card_switcher			#function call
   move $s0 $v0				#set value
   move $s2 $v1				#set value
   
   move $a1 $s0				#Moves $s0 to $a1
   move $a2 $s3				#moves $s3 to $a2
   jal card_switcher			#function call
   move $s0 $v0				#set value
   move $s3 $v1				#set value
   
   move $a1 $s0				#Moves $s0 to $a1
   move $a2 $s4				#moves $s4 to $a2
   jal card_switcher			#function call
   move $s0 $v0				#set value
   move $s4 $v1				#set value
   #Done with first element
   
   move $a1 $s1				#moves $s1 to $a1
   move $a2 $s2				#moves $s2 to $a2
   jal card_switcher			#function call
   move $s1 $v0				#set value
   move $s2 $v1				#set value
   
   move $a1 $s1				#moves $s1 to $a1
   move $a2 $s3				#moves $s3 to $a3
   jal card_switcher			#function call
   move $s1 $v0				#set value
   move $s3 $v1				#set value
   
   move $a1 $s1				#moves $s1 to $a1
   move $a2 $s4				#moves $s4 to $a2
   jal card_switcher			#function call
   move $s1 $v0				#set value
   move $s4 $v1				#set value
   #done with second element
   
   move $a1 $s2				#moves $s2 to $a1
   move $a2 $s3				#moves $s3 to $a2
   jal card_switcher			#function call
   move $s2 $v0				#set value
   move $s3 $v1				#set value
   
   move $a1 $s2				#moves $s2 to $a1
   move $a2 $s4				#moves $s4 to $a2
   jal card_switcher			#function call
   move $s2 $v0				#set value
   move $s4 $v1				#set value
   #done with third element
   
   move $a1 $s3				#moves $s3 to $a1
   move $a2 $s4				#moves $s4 to $a2
   jal card_switcher			#function call
   move $s3 $v0				#set value
   move $s4 $v1				#set value
   
   j exit_sort				#Escape sort
   
   card_switcher:
   	addi $sp $sp -4			#Make space on stack
   	sw $s0 0($sp)			#Save $s0 on stack
   	bgt $a1 $a2 mover		#If a1 is greater than a2, switch
   	j no_move			#otherwise, skip moving
   	mover:
   		move $v0 $a2		#Make second card first return
   		move $v1 $a1		#Make first card second return
   		j done_move
   	no_move:
   		move $v0 $a1		#No change
   		move $v1 $a2		#No change
   		j done_move
   	done_move:
   	lw $s0 0($sp)			#Restore $s0 from stack
   	addi $sp $sp 4			#Deallocate stack space
   	jr $ra				#Return to caller
   
   exit_sort:
   li $t1 1				#loads 1 into $t1
   sub $t0 $s4 $s3			#subtracts highest card and second highest card
   bne $t0 $t1 four_search		#If not equal to 1, not a straight
   sub $t0 $s3 $s2			#subtracts second highest card and middle card
   bne $t0 $t1 four_search		#If not equal to 1, not a straight
   sub $t0 $s2 $s1			#subtracts middle card and second lowest card
   bne $t0 $t1 four_search		#If not equal to 1, not a straight
   sub $t0 $s1 $s0			#subtracts second lowest card and lowest card
   bne $t0 $t1 four_search		#If not equal to 1, not a straight
   
   la $a0 straight_str			#loads address of straight_str into $a0
   li $v0 4				#loads print string syscall
   syscall
   j exit
   
   four_search:
   li $t0 1				#counter
   li $t2 1				#counter checker
   move $a0 $s0				#Moves $s0 to $a0
   move $a1 $s1				#Moves $s1 to $a1
   jal same_number_check		#function call
   add $t0 $t0 $v0			#Add function return value
   move $a1 $s2				#Moves $s2 to $a1
   jal same_number_check		#function call
   add $t0 $t0 $v0			#Add function return value
   beq $t0 $t2 increment_card_four	#Change the card
   move $a1 $s3				#Moves $s3 to $a1
   jal same_number_check		#function call
   add $t0 $t0 $v0			#Add function return value
   move $a1 $s4				#Moves $s4 to $a1
   jal same_number_check		#function call
   add $t0 $t0 $v0			#Add function return value
   li $t1 4				#Loads four into $t1
   bne $t0 $t1 exit_four_search		#There is no four pair
   la $a0 four_str			#Loads four string
   li $v0 4				#Loads print string syscall
   syscall
   j exit
   
   increment_card_four:
   li $t0 1				#reset counter
   move $a0 $s1				#Moves $s1 to $a0
   move $a1 $s2				#Moves $s2 to $a1
   jal same_number_check		#function call
   add $t0 $t0 $v0			#add function return value
   move $a1 $s3				#Moves $s3 to $a1
   jal same_number_check		#function call
   add $t0 $t0 $v0			#add function return value
   move $a1 $s4				#Moves $s4 to $a1
   jal same_number_check		#function call
   add $t0 $t0 $v0			#add function return value
   li $t1 4				#Loads four into $t1
   bne $t0 $t1 exit_four_search		#There is no four pair
   la $a0 four_str			#Loads four string
   li $v0 4				#Loads print string syscall
   syscall
   j exit
   
   same_number_check:
   	beq $a0 $a1 four_equal
   	j four_not_equal
   	
   	four_equal:
   		li $v0 1
   		j number_check_end
   	four_not_equal:
   		li $v0 0
   		j number_check_end
   	number_check_end:
   		jr $ra
   
   exit_four_search:
   #Start two pair search here
   li $t0 0				#counter of pairs
   li $t1 0				#current pair (find first pair. value will be placed in here to check for dupes.)
   move $a0 $s0				#move s0 to a0
   move $a1 $s1				#Move s1 to a1
   jal two_card_finder			#function call
   move $a0 $s1				#move s1 to a0
   move $a1 $s2				#move s2 to a1
   jal two_card_finder			#function call
   move $a0 $s2				#move s1 to a0
   move $a1 $s3				#move s2 to a1
   jal two_card_finder			#function call
   move $a0 $s3				#move s3 to a0
   move $a1 $s4				#move s4 to a1
   jal two_card_finder			#function call
   li $t3 2				#amount of pairs required
   beq $t0 $t3 two_pair_success		#If equal, success
   j unknown_hand			#else, unknown_hand
   
   two_pair_success:
   la $a0 pair_str			#loads address of pair_str string into $a0
   li $v0 4				#loads print string syscall
   syscall
   j exit
   
   two_card_finder:
   	beq $a0 $a1 pair_found		#If the cards make a pair
   	j pair_not_found		#If pair is not made
   	
   	pair_found:
   	beq $a0 $t1 pair_not_found	#if duplicate, pair  not found
   	addi $t0 $t0 1			#increments counter
   	add $t1 $t1 $a0			#changes t1 to number that is in a pair
   	j exit_finder			#exit
   	
   	pair_not_found:
   	move $v0 $a0			#Move a0 to v0
   	j exit_finder
   	
   	exit_finder:
   	jr $ra				#return
   	
   unknown_hand:
   la $a0 unknown_hand_str		#loads address of unknown_hand_str string into $a0
   li $v0 4				#loads print string syscall
   syscall
   j exit
   	
invalid_operation:
   la $a0 invalid_operation_error	#loads address of invalid_operation_error string into $a0
   li $v0 4				#loads print string syscall
   syscall
   j exit

invalid_args:
   la $a0 invalid_args_error		#loads address of invalid_args_error string into $a0
   li $v0 4				#loads print string syscall
   syscall
   j exit

exit:
    li $v0, 10
    syscall

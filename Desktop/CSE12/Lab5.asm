#------------------------------------------------------------------------
# Created by:  Charbonneau, Michael
#              macharbo
#              04 December 2019 
#
# Assignment:  Lab 5: Subroutines
#              CSE 12, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2019
# 
# Description: Library of subroutines used to convert an array of
#              numerical ASCII strings to ints, sort them, and print
#              them.
# 
# Notes:       This file is intended to be run from the Lab 5 test file.
#------------------------------------------------------------------------

.text

j  exit_program                # prevents this file from running
                               # independently (do not remove)

#------------------------------------------------------------------------
# MACROS
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# print new line macro

.macro lab5_print_new_line
    addiu $v0 $zero   11
    addiu $a0 $zero   0xA
    syscall
.end_macro

#------------------------------------------------------------------------
# print string

.macro lab5_print_string(%str)

    .data
    string: .asciiz %str

    .text
    li  $v0 4
    la  $a0 string
    syscall
    
.end_macro

#------------------------------------------------------------------------
# add additional macros here
#
#------------------------------------------------------------------------
# main_function_lab5_19q4_fa_ce12:
#
# Calls print_str_array, str_to_int_array, sort_array,
# print_decimal_array.
#
# You may assume that the array of string pointers is terminated by a
# 32-bit zero value. You may also assume that the integer array is large
# enough to hold each converted integer value and is terminated by a
# 32-bit zero value
# 
# arguments:  $a0 - pointer to integer array
#
#             $a1 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    $v0 - minimum element in array (32-bit int)
#             $v1 - maximum element in array (32-bit int)
#-----------------------------------------------------------------------
# REGISTER USE
# $s0 - pointer to int array
# $s1 - double pointer to string array
# $s2 - length of array
#-----------------------------------------------------------------------

.text
main_function_lab5_19q4_fa_ce12: nop
    
    subi  $sp    $sp   16       # decrement stack pointer
    sw    $ra 12($sp)           # push return address to stack
    sw    $s0  8($sp)           # push save registers to stack
    sw    $s1  4($sp)
    sw    $s2   ($sp)
    
    move  $s0    $a0            # save ptr to int array
    move  $s1    $a1            # save ptr to string array
    
    move  $a0    $s1            # load subroutine arguments
    jal   get_array_length      # determine length of array
    move  $s2    $v0            # save array length
    
                                # print input header
                                 
    lab5_print_string("\n----------------------------------------")
    lab5_print_string("\nInput string array\n")
                       
    ########################### # add code (delete this comment)
                                # load subroutine arguments
    jal   print_str_array       # print array of ASCII strings
    
    ########################### # add code (delete this comment)
                                # load subroutine arguments
    jal   str_to_int_array      # convert string array to int array
                                
    ########################### # add code (delete this comment)
                                # load subroutine arguments
    jal   sort_array            # sort int array
                                # save min and max values from array

                                # print output header    
    lab5_print_new_line
    lab5_print_string("\n----------------------------------------")
    lab5_print_string("\nSorted integer array\n")
    
    ########################### # add code (delete this comment)
                                # load subroutine arguments
    jal   print_decimal_array   # print integer array as decimal
                                # save output values
    
    lab5_print_new_line
    
    ########################### # add code (delete this comment)
                                # move min and max values from array
                                # to output registers
                                
            
    lw    $ra 12($sp)           # pop return address from stack
    lw    $s0  8($sp)           # pop save registers from stack
    lw    $s1  4($sp)
    lw    $s2   ($sp)
    addi  $sp    $sp   16       # increment stack pointer
    
    jr    $ra                   # return from subroutine

#-----------------------------------------------------------------------
# print_str_array	
#
# Prints array of ASCII inputs to screen.
#
# arguments:  $a0 - array length (optional)
# 
#             $a1 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------
.data
    space: .asciiz " "
.text
print_str_array: nop

    li $v0, 4
    lw $a0, 0($a1)
    syscall
    li $v0, 4
    la $a0, space
    syscall  
    
    li $v0, 4
    lw $a0, 4($a1)
    syscall
    li $v0, 4
    la $a0, space
    syscall
    
    li $v0, 4
    lw $a0, 8($a1)
    syscall
    li $v0, 4
    la $a0, space
    syscall                             # add code to implement subroutine

    jr  $ra
    
#-----------------------------------------------------------------------
# str_to_int_array
#
# Converts array of ASCII strings to array of integers in same order as
# input array. Strings will be in the following format: '0xABCDEF00'
# 
# i.e zero, lowercase x, followed by 8 hexadecimal digits, with A - F
# capitalized
# 
# arguments:  $a0 - array length (optional)
#
#             $a1 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
#             $a2 - pointer to integer array
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
str_to_int_array: nop
    
    subi $sp, $sp, 24       #sub from the stack pointer
    sw $ra, 12($sp)         #to keep the return address
    sw $s0, 8($sp)          #putting save registers into the array
    sw $s1, 4($sp)
    sw $s2, 0($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    
    move $s0, $a0           #keeping track of the length
    move $s1, $a1           #getting the pointer to the string
    move $s2, $a2           #getting the pointer to the int array
    
    li $s3, 0               #setting the counter to 0
    
    loop_for_str_to_int: nop
    
    mul $s4, $s3, 4
    add $t0, $s1, $s4
    lw $a0, ($t0)           
    
    jal str_to_int
    
    add $t0, $s2, $s4
    sw $v0, ($t1)
    addi $s3, $s3, 1
    blt $s3, $s0, loop_for_str_to_int
    
    lw $s4, 20($sp)         #offset
    lw $s3, 16($sp)         #counter
    lw $ra, 12($sp)         #getting return address
    lw $s0, 8($sp)          #putting the save registers from the array
    lw $s1, 4($sp)
    lw $s2, 0($sp)
    addi $sp, $sp, 24       #add back to the counter

    jr   $ra

#-----------------------------------------------------------------------
# str_to_int	
#
# Converts ASCII string to integer. Strings will be in the following
# format: '0xABCDEF00'
# 
# i.e zero, lowercase x, followed by 8 hexadecimal digits, capitalizing
# A - F.
# 
# argument:   $a0 - pointer to first character of ASCII string
#
# returns:    $v0 - integer conversion of input string
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------
.data
numbers: .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0, 10, 11, 12, 13, 14, 15, 
               0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
               10, 11, 12, 13, 14, 15
               
.text
str_to_int: nop
    li $v0, 0               #adder
    la $t0, numbers         #created the numbers table so that it'll be easeir to find the numbers
    
    lb $t1, 2($a0)          #first byte
    sll $v0, $v0, 4         
    addi $t2, $t1, -48      #subtracting 48 from the byte to get rid of the offset
    sll $t2, $t2, 2         
    addu $t2, $t2, $t0      #getting the address
    lw $t3, 0($t2)          #int value
    addu $v0, $v0, $t3      #adding to the adder
    
    lb $t1, 3($a0)          
    sll $v0, $v0, 4         
    addi $t2, $t1, -48      
    sll $t2, $t2, 2         
    addu $t2, $t2, $t0      
    lw $t3, 0($t2)          
    addu $v0, $v0, $t3      
    
    lb $t1, 4($a0)          
    sll $v0, $v0, 4         
    addi $t2, $t1, -48      
    sll $t2, $t2, 2         
    addu $t2, $t2, $t0      
    lw $t3, 0($t2)          
    addu $v0, $v0, $t3
    
    lb $t1, 5($a0)          
    sll $v0, $v0, 4         
    addi $t2, $t1, -48      
    sll $t2, $t2, 2         
    addu $t2, $t2, $t0      
    lw $t3, 0($t2)          
    addu $v0, $v0, $t3  
    
    lb $t1, 6($a0)          
    sll $v0, $v0, 4         
    addi $t2, $t1, -48      
    sll $t2, $t2, 2         
    addu $t2, $t2, $t0      
    lw $t3, 0($t2)          
    addu $v0, $v0, $t3  
    
    lb $t1, 7($a0)          
    sll $v0, $v0, 4         
    addi $t2, $t1, -48      
    sll $t2, $t2, 2         
    addu $t2, $t2, $t0      
    lw $t3, 0($t2)          
    addu $v0, $v0, $t3  
    
    lb $t1, 8($a0)          
    sll $v0, $v0, 4         
    addi $t2, $t1, -48      
    sll $t2, $t2, 2         
    addu $t2, $t2, $t0      
    lw $t3, 0($t2)          
    addu $v0, $v0, $t3
    
    lb $t1, 9($a0)          
    sll $v0, $v0, 4         
    addi $t2, $t1, -48      
    sll $t2, $t2, 2         
    addu $t2, $t2, $t0      
    lw $t3, 0($t2)          
    addu $v0, $v0, $t3
    
    lb $t1, 10($a0)          
    sll $v0, $v0, 4         
    addi $t2, $t1, -48      
    sll $t2, $t2, 2         
    addu $t2, $t2, $t0      
    lw $t3, 0($t2)          
    addu $v0, $v0, $t3
    
    jr $ra
    
#-----------------------------------------------------------------------
# sort_array
#
# Sorts an array of integers in ascending numerical order, with the
# minimum value at the lowest memory address. Assume integers are in
# 32-bit two's complement notation.
#
# arguments:  $a0 - array length (optional)
#             $a1 - pointer to first element of array
#
# returns:    $v0 - minimum element in array
#             $v1 - maximum element in array
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
sort_array: nop

    jr   $ra

#-----------------------------------------------------------------------
# print_decimal_array
#
# Prints integer input array in decimal, with spaces in between each
# element.
#
# arguments:  $a0 - array length (optional)
#             $a1 - pointer to first element of array
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
print_decimal_array: nop
    
    jr   $ra
    
#-----------------------------------------------------------------------
# print_decimal
#
# Prints integer in decimal representation.
#
# arguments:  $a0 - integer to print
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
print_decimal: nop


    jr   $ra

#-----------------------------------------------------------------------
# exit_program (given)
#
# Exits program.
#
# arguments:  n/a
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# $v0: syscall
#-----------------------------------------------------------------------

.text
exit_program: nop
    
    addiu   $v0  $zero  10      # exit program cleanly
    syscall
    
#-----------------------------------------------------------------------
# OPTIONAL SUBROUTINES
#-----------------------------------------------------------------------
# You are permitted to delete these comments.

#-----------------------------------------------------------------------
# get_array_length (optional)
# 
# Determines number of elements in array.
#
# argument:   $a0 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    $v0 - array length
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
get_array_length: nop
    
    addiu   $v0  $zero  3       # replace with /code to
                                # determine array length
    jr      $ra
    
#-----------------------------------------------------------------------
# save_to_int_array (optional)
# 
# Saves a 32-bit value to a specific index in an integer array
#
# argument:   $a0 - value to save
#             $a1 - address of int array
#             $a2 - index to save to
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

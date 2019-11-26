######################################################################################
# Created by:  Charbonneau, Michael                                     
#              macharbo
#              16 November 2019
#
# Assignment:  Lab 4: Sorting floats
#              CSE 12, Computer Systems and Assembly Language
#              Fall 2019
#
# Description: This lab will take inputs (strings) in the form of program arguments
#              and turn them into float points and sort them and then print them.
#
# Notes:       This program is inteded to be used on MARS IDE
######################################################################################

######################################################################################
# Pseudocode
#
# Create array big enough to hold floats
# Get the adress of the first program argument
# Read the string
# Turn the string into integers
# Turn the same string into a fraction
#
# Combine integer and fraction to get float point
# Push float point into array
# If there's another program input loop back to 20, else continue
# 
# Take first float and compare to the next one in array
# If first is bigger than second switch
# Loop back to 29 for each float
#
# Print array in order
######################################################################################        
.data
    prgmargu: .asciiz "Program arguments:\n"
    newline: .asciiz "\n"
    space: .asciiz " "
    floatpnt: .asciiz "Sorted values IEEE 754 single precision floating point format):\n"

.text
    main:
    # Reading the program arguments
    program_arguments:
        lw $s0, 0($a1)
        lw $s1, 4($a1)
        lw $s2, 8($a1)
    
    li $v0, 4
    la $a0, prgmargu
    syscall           
        
    sort:
        la $t0, ($s0)               #putting the arguments into temp. registers
        la $t1, ($s1)
        la $t2, ($s2)
        
        if1:
            bge $t0, $t1, if2
            move $t1, $t0
            j if1
        if2:
            bge $t0, $t2, if3
            move $t2, $t0
            j if2
        if3:
            bge $t1, $t2, done
            move $t2, $t1
            j if3
        
        done:
        #putting the sorted arguments back into the registers
        la $s0, ($t0)            
        la $s1, ($t1)
        la $s2, ($t2)
        
    print:    
        li $v0, 4
        la $a0, ($s0)
        syscall
        li $v0, 4
        la $a0, space
        syscall
        
        li $v0, 4
        la $a0, ($s1)
        syscall
        li $v0, 4
        la $a0, space
        syscall
        
        li $v0, 4
        la $a0, ($t2)
        syscall
        
        li $v0, 4
        la $a0, newline
        syscall
        
        li $v0, 4
        la $a0, newline
        syscall
        
        float:
         mtc1 $s0, $f0
         mtc1 $s1, $f1
         mtc1 $s2, $f2     
          
    decimal:
        li $v0, 4
        la $a0, floatpnt
        syscall
        
        li $v0, 2
        mov.s $f12, $f0
        syscall
        li $v0, 4
        la $a0, space
        syscall
        
        li $v0, 2
        mov.s $f12, $f1
        syscall
        li $v0, 4
        la $a0, space
        syscall
        
        li $v0, 2
        mov.s $f12, $f2
        syscall
        li $v0, 4
        
        li $v0, 4
        la $a0, newline
        syscall

        #Exit
        li $v0, 10
        syscall
    
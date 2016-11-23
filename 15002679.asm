#Alfonso Leone, 15002679, all the Options implemented. 

.data

menu:   .ascii "\n"	
	.ascii "1, Enter a number, num1\n"
	.ascii "2, Enter a number, num2\n"
	.ascii "3, Display num1 and num2\n"
	.ascii "4, Display the sum of num1 and num2\n" 
	.ascii "5, Display the product of num1 and num2\n"
	.ascii "6, Divide num 1 by num 2, display quotient and remainder\n"
	.ascii "7, Exchange num1 and num2\n"
	.ascii "8, Display numbers in sequence between num1 and num2\n"
	.ascii "9, Sum numbers between num1 and num2\n"
	.ascii "10, Raise num1 to the power of num2\n"
	.ascii "11, Display prime numbers between num1 and num2\n"					
	.ascii "12, Quit\n" 
	.ascii "\n"
	.ascii "Chose an Option:"
	.asciiz ""

str.space: .asciiz " \n"		
str.input1: .asciiz "digit an integer num 1: "
str.input2: .asciiz "digit an integer num 2: "
str.displayNum1: .asciiz " num1 is: "
str.displayNum2: .asciiz "        num2 is: "
str.sum:  .asciiz "   The sum of num1 and num2 is:  "
str.product: .asciiz "    The product of num1 and num2 is:  "
str.division: .asciiz "   num1 divided by num2 is: "
str.divisionRemainder: .asciiz "  remainder "
str.exchange: .asciiz "----------- num1 and num2 have been exchanged --------- "
str.numbersSum: .asciiz "  The sum of numbers between num1 and num2 is: "
str.power: .asciiz "  num1 raised to the power of num2 is:  "
str.primeNumber: .asciiz "   prime numbers between num1 and num2 are: "
str.divisionZero: .asciiz " division not possible because num2 is 0"
	
.text
addi $s1,$zero, 28 # default Value of num1
addi $s2,$zero, 5  # default Value of num2

main:
la $a0, str.space
jal print_string
jal printMenu
jal get_user_choice
beq $s0,1,opt1
beq $s0,2 opt2
beq $s0,3,opt3
beq $s0,4,opt4
beq $s0,5,opt5
beq $s0,6,opt6
beq $s0,7,opt7
beq $s0,8,opt8
beq $s0,9,opt9
beq $s0,10,opt10
beq $s0,11,opt11
beq $s0,12,quit

#user selected an invalid option so print menu again
j main

opt1:
# enter a number num 1
la $a0, str.input1
jal print_string
jal get_number
add $s1, $zero, $v0     #assign num1 to $s1
j main # jump back and print menu again

opt2:
# enter a number num 2
la $a0, str.input2
jal print_string
jal get_number
add $s2, $v0, $zero # assign num2 to $s2
j main

opt3:
#display num1 and num2
la $a0, str.displayNum1
jal print_string
add $a0, $zero, $s1
jal print_int
la $a0, str.displayNum2
jal print_string
add $a0, $zero, $s2
jal print_int
j main

opt4:
# display the sum of num1 and num2
la $a0, str.sum
jal print_string
add $s4, $s1, $s2   #$s4 is the sum of num1 and num2
add $a0, $zero, $s4
jal print_int
j main

opt5:
# display the product of num1 and num2
la $a0, str.product
jal print_string
mul $s5, $s1, $s2
add $a0, $zero, $s5
jal print_int
j main

opt6:
# display the quotient and remainder of the division between num1 and num2
beqz $s2, divisionZero  # check if num2 is 0..if so, print out an error message
la $a0, str.division
jal print_string
div $a0, $s1, $s2
jal print_int
la $a0, str.divisionRemainder
jal print_string
rem $a0, $s1, $s2
addi $v0, $zero, 1
syscall
j main

opt7:
# exchange num1 to num2
add $s5, $zero, $s2
move $s2, $s1
move $s1, $s5
la $a0, str.exchange
jal print_string
j main

opt8:
# display numbers in sequence between num1 and num2
blt $s1, $s2, num1Minore  #branch if num1 is less than num2

num1Maggiore:
add $s7, $zero, $s1
loopIfNum1Greater:
add $a0, $zero, $s7
jal print_int     # print out the actual value in $s7
li $v0, 11
add $a0, $zero, ','
syscall
sub $s7, $s7, 1
bge $s7, $s2, loopIfNum1Greater   # increase the loop until $s7 is greater or equal than num2 contained in $s2
j main

num1Minore:
add $s6, $zero, $s1
loopIfNum1Less:
add $a0, $zero, $s6
jal print_int
li $v0, 11
add $a0, $zero, ','
syscall
addi $s6, $s6, 1
ble $s6, $s2, loopIfNum1Less
j main

opt9:
# Sum numbers between num1 and num2
blt $s1, $s2, case2  #jump to case2 if num1 is less than num2

case1:
add $s7, $zero, $s1
move $s5, $zero
case1Loop:
add $s5, $s5, $s7  #sum the actual number $s7 with the register for the sum $s5
sub $s7, $s7, 1  #subtract to the loop counter
bge $s7, $s2, case1Loop
la $a0, str.numbersSum
jal print_string
add $a0, $zero, $s5    # print out the value of the sum in $s5
jal print_int
j main

case2:
add $s6, $zero, $s1
move $s5, $zero
case2Loop:
add $s5, $s5, $s6
addi $s6, $s6, 1
ble $s6, $s2, case2Loop
la $a0, str.numbersSum
jal print_string
add $a0, $zero, $s5    # print out the value of the sum in $s5
jal print_int
j main

opt10:
# Raise num1 to the power of num2
beqz $s2, num2IsZero   #control if num2 is 0

addi $s3, $zero, 1
add $s4, $zero, $s1
loopPower:
mul $s4, $s4, $s1 # multiplication of num1 to the power of num2
addi $s3, $s3, 1  # increase the loop
blt $s3, $s2, loopPower
la $a0, str.power
jal print_string
add $a0, $zero, $s4
jal print_int
j main

num2IsZero:   # in case num1 is raised to 0
la $a0, str.power
jal print_string
addi $a0, $zero, 1
jal print_int    # print out 1 if num2 is 0
j main

opt11:
# Display prime numbers between num1 and num2
la $a0, str.primeNumber
jal print_string
blt $s1, $s2, num1Less  #branch if num1 is less than num2

num1Greater:  # decrease and check each time if $s7 is prime number
add $s7, $zero, $s1
loopIfNum1Maggiore:
move $t8, $zero
move $t0, $zero
j checkIfIsPrimeNumber
afterCheckGreater:
afterZeroControlGreater:
sub $s7, $s7, 1
bge $s7, $s2, loopIfNum1Maggiore
j main

num1Less:    # decrease and check each time if $s7 is prime number
add $s7, $zero, $s1
loopIfNum1Minore:
move $t8, $zero
move $t0, $zero
j checkIfIsPrimeNumber
afterCheckLess:
afterZeroControlLess:
addi $s7, $s7, 1
ble $s7, $s2, loopIfNum1Minore
j main

opt12:
# exit the program

get_number:
addi $v0, $zero, 5
syscall
jr $ra

print_string:
addi $v0, $zero, 4
syscall
jr $ra

print_int:
li $v0, 1
syscall
jr $ra

#Print Menu using service num 4
printMenu:    # Label so we can jump/branch back here

la $a0, menu
li $v0, 4
syscall
jr $ra

divisionZero:
la $a0, str.divisionZero
jal print_string
j main

get_user_choice:
# Read user option using service 5 [num goes into $v0]
li $v0, 5
syscall
#move user's choice into $s0
move $s0,$v0
jr $ra

checkIfIsPrimeNumber:
beqz $s7, zeroResolution  #check if num 1 is 0
add $t9, $zero, $s7  # $t9 is the number to be checked if it is prime (local variable inside the sub routine)
move $t8, $zero
loopPrimeNumbers:
addi $t8, $t8, 1  # increase the loop
rem $s5, $t9, $t8
beqz $s5, sumRemainderZero
ble $t8, $t9, loopPrimeNumbers
j primeNumber

sumRemainderZero:
addi $t0, $t0, 1
j loopPrimeNumbers

zeroResolution:  # to avoid the 0 to stop the program
blt $s1, $s2, afterZeroControlLess
j afterZeroControlGreater

primeNumber:
bgt $t0, 2, notPrimeNumber  #control if it is prime number
ble $t9, 1, notPrimeNumber  # to avoid 1 to be recognised as prime numbers
add $a0, $zero, $t9
jal print_int  # print out the prime number
li $v0, 11
add $a0, $zero, ','  # print out a comma
syscall
blt $s1, $s2, afterCheckLess
j afterCheckGreater

notPrimeNumber:
blt $s1, $s2, afterCheckLess
j afterCheckGreater

quit:

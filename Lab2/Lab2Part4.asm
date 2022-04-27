# Lab Part 4 Arrays

	.data # Data declaration section
	
A:	.word 0, 0, 0, 0, 0
B:	.word 1, 2, 4, 8, 16
i:	.word 0

	.text
main:	# Start of code section

la a0, A # load address of the matrices
la a1, B
lw t1, i # register t1 will hold integer variable i

addi t2, zero, 5 # register t2 will hold the value 5
j for # jump to for

for:
slt t3, t1, t2 # checks if i(t1) < 5(t2); stores binary T/F in register t3
beq t1, t2, cont # if i = 5, break out of the foor loop
addi ra, zero, 4 # register (ra = 4) will be used to offset for the arrays
mul a3, ra, t1 # 4*i is the number needed to offset the arrays to access individual elements
add a4, a0, a3 # certain element of Array A according to i value stored in a4
add a5, a1, a3 # certain element of Array B according to i value stored in a5
lw s6, 0(a5) # loads that element from memeory
addi s6, s6, -1 #B[i] - 1 is stored in a4 (A[i])
sw s6, 0(a4)
addi t1, t1, 1 # i (t1) increment by one
j for

cont:
addi t1, t1, -1 # i-- 
j while

while:
slt t4, zero, t1 # checks if zero < i (while continue while loop if i>=0); stores binary T/F in t4
bne t4, zero, whileContent # if true (i(t4) != 0), branch to whileContent
beqz t1, whileContent # if i=0, branch to whileContent
j Exit 


whileContent:
mul a3, ra, t1 # 4*i is the number needed to offset the arrays to access individual elements
add a4, a0, a3 # certain element of Array A according to i value stored in a4
add a5, a1, a3 # certain element of Array B according to i value stored in a5
lw a6, 0(a4) # loads the value at the address a4 (certain element of A) into register a6 to manipulate
lw a7, 0(a5) # loads the value at the address a5 (certain element of B) into register a7 to manipulate
add s10, a6, a7 # A[i] + B[i] stored in s10
addi s11, zero, 2 # intializes s11 = 2
mul s10, s10, s11 # (A[i]+B[i] * 2)
sw s10, 0(a4)  # Stores the value held in s10(new A[i]) and stores at the addrress of a4 (corresponding place in the array)
addi t1, t1, -1 # i--
j while


Exit:

# Lab Part 3 Loops

	.data # Data declaration section
	
i:	.word 
z:	.word 2

	.text
main:	# Start of code section

la t1, i 	# loaded addresses into corresponding registers
la t2, z

lw t3, i
lw t4, z

mul t3, t3, zero # i = 0
addi t6, zero, 20 # t6 = 20

if: #AKA the for loop
slt t5, t3, t6 # checks if i(t3) is < 20(t6). stores binary T/F in t5
bne t5, zero, zIncrement # will branch to increment Z command if i(t3) < 20(t6); if true (t5 = 1), jump to zIncrement
beq t3, t6, zIncrement # will branch to increment Z command if i(t3) == 20(t6)
beq t5, zero, while # if false (t5 = 0), branch to do

zIncrement:
addi t4, t4, 1 # z++ ; Z(t4) = Z + 1
addi t3, t3, 2 # i = i+2; t3 = t3 + 2
j if # jump to above if statement

while:
addi s1, zero, 100 # s1 = 100 
slt s0, t4, s1 # checks if z(t4) < s1(100); Binary T/F is stored in s0
bne s0, zero, doZIncrement # if true, (s0 != zero) branch to the increment within the do loop
beq s0, zero, lastWhile # if false (z=>100), branch to last while loop of the program

doZIncrement:
addi t4, t4, 1 # increments Z by one, if z<100
j while # jumps back to while loop above

lastWhile:
slt s2, zero, t3 # checks if 0<i(t3); binary T/F is stored in s2
bne s2, zero, lastWhileContent # if true (s2=1; s2!=0), branch to lastWhile
beq s2, zero, Exit # if false (s2 = 0), branch to Exit

lastWhileContent:
addi s10, zero, 1 # s10=1
sub t4, t4, s10 # z(t4)--
sub t3, t3, s10 # i(t3)--
j lastWhile # jump back to lastWhile

Exit:
sw t3, i, a6
sw t4, z, a7

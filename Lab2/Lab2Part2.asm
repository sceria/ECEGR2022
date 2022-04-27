# Lab Part 2 Branches

	.data # Data declaration section
	
a:	.word 15	
b:	.word 15
c:	.word 10
z:	.word 0	

	.text
main:	# Start of code section

lw t1, a 	# loaded into corresponding registers
lw t2, b
lw t3, c
lw t6, z

if:		# if 
slt t0, t1, t2	# if t1 < t2, t0 will store binary T/F
addi a1, zero, 5 # storing 5 into a register
slt s0, a1, t3 # if t3 > 5, store binary T/F in s0

AND a2, t0, s0 # ANDs t0 and s0 and puts result in a2
beq a2, zero, else_if # if cond. is false, jump to else_if case
addi t6, t6, 1 # if true, Z = 1
j switch # if true, jump to switch

else_if:
slt s1, t2, t1 # if t2 < t1 and stores binary T/F in s1
addi a0, t3, 1 # adds 1 to t3 and stores answer in a0
addi a3, zero, 7 # give register a3 the value of 7
beq a0, a3, newZ2 #if equiv. branch to newZ2
bne a0, a3, else #if not equivalent, branch to else

newZ2:
OR a2, a3, s1 # ORs the two binary T/F results together and stores value in a2
addi t6, t6, 2 # if a2 is true, Z=2
j switch # if true. jump to switch

else:
addi t6, t6, 3 # all else, Z=3

switch:
addi s4, zero, 1 # stores value of 1 in s4
addi s5, zero, 2 # stores value of 2 in s5
addi s6, zero, 3 # stores value of 3 in s

 
sw t1, a, s7 # stores variable A into s7 in memory
sw t2, b, s8 # stores var. B into s8 in memory
sw t3, c, s9 # stores var. C into s9 in memory

beq t6, s4, case1 # if Z == 1, branch to case1
beq t6, s5, case2 # if Z==2, branch to case2
beq t6, s6, case3 # if Z==3, branch to case3
j default # if all else, jump to default

case1:
addi t6, t6, -2 # Z = -1

j Exit

case2:
addi t6, t6, -4 # Z = -2
j Exit

case3:
addi t6, t6, -6 # Z = -3
j Exit

default:
mul t6, t6, zero
j Exit

Exit:
sw t6, z ,s11
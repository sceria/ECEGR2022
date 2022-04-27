# Lab Part 5 Function Calling

	.data # Data declaration section
	
a:	.word 0
b:	.word 0
c:	.word 0
i:	.word 5
j:	.word 10
x:	.word 0

	.text
main:	# Start of code section

lw t0, i
lw t1, j
lw t2, a
lw t3, b
lw t4, c

addi sp, sp, -8 # adjust stack for two items: i = t0 and j = t1
sw t0, 4(sp) #put t0 = i onto the stack
sw t1, 0(sp)# put t1 = j onto the stack
add t5, zero, t0 # n = i = 5 and we are about to call the function with the argument n = 5
jal additup
sw t1, a, t2 # stores the result of the function (which is x (t1)) and stores it into variable a

lw t1, 0(sp) # loading t1 from the stack (j=10) into t1
add t5, zero, t1 # n = j = 10 and we are about to call the function with the argument n = 10
jal additup
sw t1, b, t3 # stores the result of the function (x or t1) and stores it into variable b
lw a3, a
lw a4, b
add s3, a3, a4 
sw s3, c, t4

addi sp, sp, 8 # pop items off the stack
li a7, 10 
ecall



additup:
mul t0, s7, zero # addi t0, zero, zero # initializing int. i = 0 into t0 
lw t1, x # loading int. x into t1
j for

for:
slt s11, t0, t5 # checks if i(t0) < n(t5); binary T/F saved into s11
beqz s11, return # branch if above statement is false
addi s10, t0, 1 # operation: i + 1
add t1, t1, s10 # x = x + (i + 1)
addi t0, t0, 1 # incrementing: i++
j for


return:
ret 




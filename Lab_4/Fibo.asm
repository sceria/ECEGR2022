	.data
a:	.word 3 
b:	.word 10
c:	.word 20
value:	.word 0
n:	.word 0
		
	.text
main:	
li s5, 1

# For when n = 3
lw a1, a
lw a2, value
jal Fibonacci
add t3, s2, zero #t3 = 2
# MUST RETURN THIS VALUE

# For when n = 10
lw a1, b
lw a2, value
jal Fibonacci
add t4, s2, zero

# For when n = 20
lw a1, c
lw a2, value
jal Fibonacci
add t5, s2, zero

j se_acabo

#-----------------------------
Fibonacci:

blez a1, if
beq s5, a1, elseif #if s10 is equal to one, go to valueDeux

addi sp, sp, -4 # making room for one word on the stack
sw ra, 0(sp) # stores current return address
addi sp, sp, -4
sw a1, 0(sp) # save current address

# MAIN CODE HERE
addi a1, a1, -1 # variable n is now (n-1)

jal Fibonacci

add t0, zero, s2 # t0 holds value of fibo(n-1)

#add t0, a2, zero # t0 is a temporary result register
# add t0, t0, s2 #----------------------------------------------------------
lw a1, 0(sp)
addi sp, sp, 4 # restores the stack
lw ra, 0(sp)
addi sp, sp, 4

# now we'll make new space for the registers for fibo(n-2)
addi sp, sp, -4
sw ra, 0(sp)
addi sp, sp, -4
sw a1, 0(sp)
# must also save t0  value since we will be needing it for another sum
addi sp, sp, -4
sw t0, 0(sp)

addi a1, a1, -2 # a1 = n-2 AKA a1 = a1 - 2

jal Fibonacci

add t2, s2, zero

# must restore stack; remember t0 is currently on the top of the stack
lw t0, 0(sp)
addi sp, sp, 4
lw t6, 0(sp) # must load it into a new register so it isn't lost when program reiterates through again
addi sp, sp, 4
lw ra, 0(sp)
addi sp, sp, 4


add s2, t0, t2
ret


if:
addi s2, zero, 0
ret

elseif:
addi s2, zero, 1
ret

se_acabo:
li a7, 10
ecall


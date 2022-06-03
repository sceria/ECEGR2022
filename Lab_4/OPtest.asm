	.data
datain_a:	.word 19088743
datain_b:	.word 287454020
			
	.text
main:	

lw t0, datain_a
lw t1, datain_b

#add
add t2, t0, t1

#and
and t2, t0, t1

#or
or t2, t0, t1

#sub
sub t2, t0, t1

#SLL by 1
li t3, 1
sll t2, t0, t3

#SLL by 2
li t3, 2
sll t2, t0, t3

#SLL by 3
li t3, 3
sll t2, t0, t3

#SRL by 1
li t3, 1
srl t2, t0, t3

#SRL by 2
li t3, 2
srl t2, t0, t3

#SRL by 3 
li t3, 3
srl t2, t0, t3

#--------------------IMMEDIATES	
#addi
addi t2, t0, 1

#andi
andi t2, t0, 1

#ori
ori t2, t0, 1

#slli
slli t2, t0, 1

#srli
srli t2, t0, 1


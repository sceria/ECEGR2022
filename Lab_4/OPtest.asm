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
and t4, t0, t1

#or
or t5, t0, t1

#sub
sub t6, t0, t1

#SLL by 1
li t3, 1
sll a1, t0, t3

#SLL by 2
li t3, 2
sll a2, t0, t3

#SLL by 3
li t3, 3
sll a3, t0, t3

#SRL by 1
li t3, 1
srl a4, t0, t3

#SRL by 2
li t3, 2
srl a5, t0, t3

#SRL by 3 
li t3, 3
srl a6, t0, t3

#--------------------IMMEDIATES	
#addi
addi a7, t0, 1

#andi
andi s2, t0, 1

#ori
ori s3, t0, 1

#slli
slli s4, t0, 1

#srli
srli s5, t0, 1


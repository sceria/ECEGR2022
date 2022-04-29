# Lab Part 1 Arithmetic

	.data # Data declaration section
	
varZ:	.word 0	

	.text
main:	# Start of code section

addi t0, zero, 15 # t0 holds integer A
addi t1, zero, 10  # t1 holds integer B
addi t2, zero, 5 # t2 holds integer C
addi t3, zero, 2 # t3 holds integer D
addi t4, zero, 18 # t4 holds integer E
addi t5, zero, -3 # t5 holds integer F

sub t4, t4, t5 # t4 rewrites old value and now holds E-F
div t5, t0, t2 # t5 rewrites old value and now holds A/C
mul t6, t2, t3 # t6 holds C*D
sub t3, t0, t1 # t3 rewrites old value and now holds A-B

sub t4, t4, t5 # t4 holds (E-F) - (A/C)
add t4, t4, t6
add t4, t4, t3

sw t4, varZ, a0
# now must store this arithmetic in variable z

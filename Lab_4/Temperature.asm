
	.data # Data declaration section
	
c:  .float 32.0
cc:  .float 5.0
ccc:  .float 9.0
k:  .float 273.15
newln:	.asciz	"\r\n"

	.text
main:	# Start of code section

flw ft1, c, t0 # loading c into ft1
flw ft2, cc, t0 # loading cc into ft2
flw ft3, ccc, t0 # loading ccc into ft3
flw ft4, k, t0 # loading k into ft4

li a7,6			#system call for reading floating point
ecall	# stops what the program is doing and waits until it gets a float input from user and is stored in fa0

fmv.s ft0, fa0 # moves the value stored in fa0 (user input) and stores it in ft0

jal celsius

jal kelvin

j exit

celsius:
fsub.s fs9, ft0, ft1 # ft0 - 32.0; stored in fs9
fmul.s fs9, fs9, ft2 # prev. difference * 5.0 (AKA ft2); product stored in fs9
fdiv.s fs9, fs9, ft3 # divide by 9; stored in fs9

fmv.s fa0, fs9 # move value over to fa0 since that's the register used to print floats
li a7, 2 # prints the Celsius value
ecall

li a7, 4
la a0, newln # prints a new line (\n)
ecall

ret

kelvin:
fmv.s fs5, fa0 # move the celsius value that's still stored in fa0 and move it to fs5
fadd.s fs5, fs5, ft4 # celsius + 273.15 (ft4) ;stored in fs5

fmv.s fa0, fs5 # move value back into fa0 since that's the register that gets printed
li a7, 2 # prints the kelvins value
ecall

ret

exit:

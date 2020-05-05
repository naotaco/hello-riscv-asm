.section .text
.globl _start
_start:

	li a0, 0
	li a1, 0x11
	li a2, 0x22
	li a3, 0x333
	li a4, 0x4444

loop:
	j loop

.section .rodata



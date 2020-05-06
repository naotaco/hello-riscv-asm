.equ GPIO_BASE, 0x10012000
.equ GPIO_OFFSET_VALUE,     0x00
.equ GPIO_OFFSET_INPUT_EN,  0x04
.equ GPIO_OFFSET_OUTPUT_EN, 0x08
.equ GPIO_OFFSET_PORT,      0x0C
.equ GPIO_OFFSET_PUE,       0x10
.equ GPIO_OFFSET_OUT_XOR,   0x40

.equ USE_PORTS, (1 << 19) | (1 << 21) | (1 << 22)
.equ WAIT_COUNT, 2000000

.section .text
.globl _start
_start:
	lui sp, 0x80004

init_regs:
	li t3, GPIO_BASE
	li t4, USE_PORTS # flags to write
	sw t4, GPIO_OFFSET_OUTPUT_EN(t3)
	sw t4, GPIO_OFFSET_PORT(t3)
	sw zero, GPIO_OFFSET_OUT_XOR(t3)

loop:
	sw zero, GPIO_OFFSET_PORT(t3) # store zero (GPIO low) to light up.

	li t5, WAIT_COUNT
wait1:
	addi t5, t5, -1
	nop
	bnez t5, wait1 # go to w1 if t5 != zero
	
	sw t4, GPIO_OFFSET_PORT(t3) # turn on again.

	li t5, WAIT_COUNT
wait2:
	addi t5, t5, -1
	nop
	bnez t5, wait2 # go to w1 if t5 != zero
	
	j loop

.section .rodata



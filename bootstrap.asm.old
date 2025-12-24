MBALIGN	equ	1<< 0			; align loaded modules on page boundaries
MEMINFO equ	1<< 0			; provide a memory map
MBFLAGS equ	MBALIGN | MEMINFO	; Multiboot flag
MAGIC	equ 	0x1BADB002		; lets bootloader find the header
CHECKSUM equ -(MAGIC + MBFLAGS)		; checksum of above

; Declare a multiboot section. The bootloader will search for this section
section .multiboot
align 4
	dd MAGIC
	dd MBFLAGS
	dd CHECKSUM

; Set up stack
section .bss
align 16
stack_bottom:
	resb 16384	; 16 Kb
stack_top:

; Set up code section
section .text
global _start:function (_start.end - _start)
_start:

	mov esp, stack_top

	extern kernel_main
	call kernel_main

	cli
.hang:
	hlt
	jmp .hang

.end:


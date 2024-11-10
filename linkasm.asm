global asmfunc
section .data
section .text

asmfunc:
	mov edx, 0xb8000
	mov al, 0x2a
	mov ah, 0x0f
	mov [edx], ax
	ret

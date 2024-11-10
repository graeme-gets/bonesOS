global putChar
section .data
section .text

VGA_BUFFER equ 	0xb8000
VGA_ROW equ	25
VGA_COLS equ	80

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PutCharAt 
; Displayed a character at the next text location
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
putCharAt:
	mov edx, VGA_BUFFER
	mov al, 0x2a
	mov ah, 0x0f
	mov [edx], ax
	ret

global putChar
section .data
section .text

VGA_BUFFER equ 	0xb8000
VGA_ROW equ	25
VGA_COLS equ	80

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PutCharAt 
; Displayed a character at the next text location
; Char to diplay as first parameter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
putChar:
	mov al,[esp+4]
	mov edx, VGA_BUFFER
	mov ah, 0x0f
	mov [edx], ax
	ret

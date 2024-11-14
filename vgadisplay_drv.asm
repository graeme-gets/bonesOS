[bits 32]
global putChar
global vgaInit
section .data
section .text

VGA_BUFFER 	equ 	0xb8000
VGA_ROWS 	equ	25
VGA_COLS 	equ	80

vgaInit:
	mov eax,0
	mov[CURRENT_ROW],eax
	mov[CURRENT_COL],eax
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PutChar 
; Displayed a character at the next text location
; Char to diplay as first parameter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
putChar:
	; Calculate position in buffer
;	mov [CURRENT_ROW],4
	mov eax, [CURRENT_ROW]
;	mov ebx, VGA_ROWS
;	mul ebx
	add eax, [CURRENT_COL]
	mov edx, eax
	mov ah, 0x0d
	mov al,[esp+4]
	mov [VGA_BUFFER + edx], ax
	ret


CURRENT_ROW	dw 0
CURRENT_COL	dw 0


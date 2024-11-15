[bits 32]
global putChar
global vgaInit
section .data
section .text

VGA_BUFFER 	equ 	0xb8000
VGA_ROWS 	equ	80
VGA_COLS 	equ	25

vgaInit:
	mov ax,0x0005
	mov[CURRENT_ROW],al
	mov[CURRENT_COL],ah
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PutChar 
; Displayed a character at the next text location
; Char to diplay as first parameter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
putChar:
	; Calculate position in buffer
	mov dl, [CURRENT_ROW]
	shl dl, 1

	mov eax, VGA_ROWS     ; load 32 bit so as to clear higher unused bits 
	mul dl

	mov dl, [CURRENT_COL]
	shl dl, 1
	
	add al,dl
	mov edx,eax 

	mov ah, 0x0d
	mov al,[esp+4]
	mov ebx,VGA_BUFFER
	add ebx,edx
	mov [ebx], al
	mov [ebx + 1], ah
	mov al, [CURRENT_COL]
	inc al
	mov [CURRENT_COL],al
	ret


CURRENT_ROW	db 0
CURRENT_COL	db 0


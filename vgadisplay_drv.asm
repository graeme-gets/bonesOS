[bits 32]

global put_char
global vga_init
global clear_screen
global cursor_set
global cursor_state_set
global cursor_pos_get
global print_string
section .data
section .text

VGA_BUFFER 	equ 	0xb8000
VGA_ROWS 	equ	80
VGA_COLS 	equ	25
VGA_SIZE	equ	4000


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; vga_init
; Initialises the cga display, clearing the scnreen
; and setting up the default buffer position and colors
; forground color  : esp+8
; background color : esp+4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
vga_init:
	mov ax,0x0
	mov[CURRENT_ROW],al
	mov[CURRENT_COL],al
	mov eax,[esp+8]
	shl eax,4
	add eax,[esp+4]
	
	mov[CURRENT_COLOR],al
	
	call clear_screen 
	ret

clear_screen:
	
	mov ebx,VGA_BUFFER
	mov ah, [CURRENT_COLOR]		; Color
	mov al, 0x20 			; character ' '

	mov ecx, VGA_SIZE
clearL:
	mov [ebx],al
	mov [ebx + 1],ah
	add ebx,2
	loop clearL
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; cursor_pos_get
; retuens the cursor position row = H, col = L
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cursor_pos_get:
	mov eax, [CURRENT_ROW]
	shl eax, 8
	or eax, [CURRENT_COL]
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set_cursor_sate
; Enanle or disable the cursor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cursor_state_set:
	push ebp		; push the base stack pointerp
	mov ebp, esp		; copy stack pointer to base stack pointer
	mov cx,[ebp+8]		; get and store the 1st parameter
	; process arguments
	cmp cx,0
	je curoff
	; process turn cursor on
	mov dx, 0x3d4
	mov al, 0xa
	out dx, al
	mov dx, 0x3d5
	mov ax, [ebp+16]
	or al, 0xc0		; just switch off bit 5
	out dx, al

	mov dx, 0x3d4
	mov al, 0xb
	out dx, al
	mov dx, 0x3d5
	mov ax, [ebp+12]
	or al, 0xe0		; just switch off bit 5
	out dx, al
	pop ebp
	ret
curoff:
	mov dx, 0x3d4
	mov al, 0xa
	out dx, al		; Register control
	
	mov dx, 0x3d5
	mov al, 0x20
	out dx, al		; set bit 5 to disable cursor
	
	pop ebp
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set_cursor
; put cursor at current location
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cursor_set:
	call calc_buffer_pos

	mov 	cx, dx
	shr 	cx,1		; divide by 2
	mov	edx,0x03D4	;VGA Index Register
	mov	eax,0x0E0F	;Commands
	out	dx,al		;Send "Set LOW" Command
	inc	edx
	mov	al,cl
	out	dx,al		;Send LOW BYTE
	dec	edx
	mov	al,ah
	out	dx,al		;Send "Set HIGH" Command
	inc	edx
	mov	al,ch
	out	dx,al		;Send HIGH BYTE
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print_string
; prints a NULL terminated string
; string pointer as first parameter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_string:
	call calc_buffer_pos
	mov ecx, [esp+4]
	mov esi,ecx
	mov ah, [CURRENT_COLOR]		; Color
prloop:
	lodsb				; Load the byte at address in SI to AL and Inc SI
	cmp al,0xd
	je cr
	cmp al,0xa
	je nl
	cmp al,0			; check for end of line
	je printStringEnd
		
	mov ebx,VGA_BUFFER
	add ebx,edx
	mov [ebx], al
	mov [ebx + 1], ah
	mov al, [CURRENT_COL]
	inc al
	mov [CURRENT_COL],al
	add edx,2
	jmp prloop
cr: 	; Process carage return
	mov al,0
	mov [CURRENT_COL],al
	call calc_buffer_pos
	jmp prloop
nl:	; Process New Line
	mov al,[CURRENT_ROW]
	inc al
	mov [CURRENT_ROW],al
	call calc_buffer_pos
	jmp prloop
	
printStringEnd:
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; calc_buffer_pos
; calculates the buffer position gien an x/y coordinate
; dh - x
; dl - y
; The buffer offset is placed in edx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
calc_buffer_pos:
	mov dl, [CURRENT_ROW]
	;shl dl, 1

	mov eax, VGA_ROWS     ; load 32 bit so as to clear higher unused bits 
	mul dl

	mov dl, [CURRENT_COL]
	;shl dl, 1
	add al,dl
	shl eax,1

	mov edx,eax		; use whole register to Zero out unwanted data?
	ret 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PutChar 
; Displayed a character at the next text location
; Char to diplay as first parameter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
put_char:
	; Calculate position in buffe
	call calc_buffer_pos

	mov ah, [CURRENT_COLOR]		; Color
	mov al, [esp+4]			; character
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
CURRENT_COLOR	db 0

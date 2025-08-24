[bits 32]

global put_char
global vga_init
global clear_screen
global cursor_set
global cursor_state_set
global cursor_pos_get
global print_string
global scroll_up
global color_set

section .text
%include "codeHelpers.inc"

VGA_BUFFER 	equ 	0xb8000
VGA_ROWS 	equ		25
VGA_COLS 	equ		80
VGA_COL2	equ		160
VGA_SIZE	equ		4000
CR			equ		0xd
NL			equ		0xa
NULL		equ		0x0

; VGA COMMANDS
VGA_CURSOR_MOVE	equ 0x34D4


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; vga_init
; Initialises the VGA display, clearing the screen
; and setting up the default buffer position and colors
; Param 1 : forground color  : esp+8
; Param 2 : background color : esp+12
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
vga_init:
	push ebp						; save the stack base pointer
	mov ebp, esp					; copy stack pointer to base stack pointer
	push eax
	; set current row and col to 0
	xor ax,ax
	mov[CURRENT_ROW],al
	mov[CURRENT_COL],al
	; set pointer to buffer at begining of buffer
	mov eax,VGA_BUFFER
	mov [CURRENT_BUFFER_PTR], eax
	; set current color parameters
	mov eax,[ebp+12]
	push eax
	mov eax,[ebp+8]
	push eax
	call color_set
	call clear_screen
	; remove the parameters 
	pop eax
	mov esp, ebp
	pop ebp
							; restore the stack base pointer
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; color_set
; Sets the current text color
; Param 1 : forground color  : esp+8
; Param 2 : background color : esp+12
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
color_set:
	push ebp
	mov ebp,esp

	; set current color
	mov eax,[ebp+12]
	shl eax,4
	add eax,[ebp+8]
	mov [CURRENT_COLOR],al

	mov esp, ebp
	pop ebp

	ret

clear_screen:
	push ebx
	mov ebx,VGA_BUFFER
	mov ah, [CURRENT_COLOR]		; Color
	mov al, 0x20 			; character ' '

	mov ecx, VGA_SIZE
clearL:
	mov [ebx],al
	mov [ebx + 1],ah
	add ebx,2
	loop clearL
	pop ebx
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; cursor_pos_get
; returns the cursor position row = H, col = L
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	dec	edx
;;;;;;;;;;;;;;;
cursor_pos_get:
	mov eax, [CURRENT_ROW]
	shl eax, 8
	or eax, [CURRENT_COL]
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Scroll Up
; Move entire screen buffer up by one row
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scroll_up:
	
	mov eax, VGA_BUFFER
	add eax, VGA_COLS
	inc eax
	mov esi, eax
	mov edi, VGA_BUFFER
	
	cld
	mov ecx,12
	
	rep movsb 
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set_cursor_sate
; Enanle or disable the cursor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cursor_state_set:
	push ebp		; push the base stack pointerp
	mov ebp, esp		; copy stack pointer to base stack pointer
	push ecx
	push edx

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
	pop edx
	pop ecx	
	mov esp, ebp
	pop ebp

	ret
curoff:
	mov dx, 0x3d4
	mov al, 0xa
	out dx, al		; Register control
	
	mov dx, 0x3d5
	mov al, 0x20
	out dx, al		; set bit 5 to disable cursor
	
	pop edx
	pop ecx	
	mov esp, ebp
	pop ebp
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set_cursor
; put cursor at current location
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cursor_set:
	push edx
	push ecx
	mov eax,[CURRENT_BUFFER_PTR]
	sub eax, VGA_BUFFER
	mov cx, ax
	shr cx,1		; divide by 2
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
	pop ecx
	pop edx	
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print_string
; prints a NULL terminated string
; string pointer as first parameter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_string:
	push ebp
	mov ebp,esp
	push esi
	push edx
	mov ecx, [ebp+8]
	mov esi,ecx
	mov ah, [CURRENT_COLOR]		; Color
	mov edx,[CURRENT_BUFFER_PTR]			; set up the buffer
prloop:
	lodsb						; Load the byte at address in SI to AL and Inc SI
	cmp al,0					; check for end of line
	je printStringEnd
	cmp al,NL					; check for new line
	je nl
	cmp al,CR					; check for carage return
	je cr
		
	mov [edx], al
	mov [edx + 1], ah
	inc edx
	inc edx
	jmp prloop
cr: ; Process carage return
	push edx
	push ecx
	mov eax,edx					; set up for div
	sub eax, VGA_BUFFER
	xor edx,edx
	mov ecx,VGA_COL2			; mod into ecx
	div ecx
	mov eax,edx
	pop ecx
	pop edx
	sub edx,eax
	jmp prloop
nl:	; Process New Line
	add edx,VGA_COL2
	jmp prloop
	
printStringEnd:
	; save the vga buffer location
	mov [CURRENT_BUFFER_PTR],edx
	pop edx
	pop esi
	mov esp, ebp
	pop ebp
	call cursor_set
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; calc_buffer_pos
; calculates the buffer position given an x/y coordinate
; dh - x - col
; dl - y - row
; x + (y*rows)
; The buffer offset is placed in edx
; position = (y_position * 80) + x_position
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
calc_buffer_pos:
	; y*rows
	xor edx,edx 				; clear edx
	xor eax,eax
	mov dl, byte [CURRENT_ROW]		; y-pos
	mov al, VGA_COLS     		; Load rows into Ax 
	mul dl
	mov dl,byte [CURRENT_COL]
	add al,dl
	; multiply by 2 so cater for color and char
	shl eax,1
	mov edx,eax		; use whole register to Zero out unwanted data?
	ret 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PutChar 
; Displayed a character at the next text location
; Char to diplay as first parameter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
put_char:
	frameStart
	mov ah, [CURRENT_COLOR]		; Color
	mov al, [ebp+8]			; character
	mov edx,[CURRENT_BUFFER_PTR]
	
	cmp al,NULL					; check for end of line
	je putEnd
	cmp al,NL					; check for new line
	je putNL
	cmp al,CR					; check for carage return
	je putCR
		
	mov [edx], al
	mov [edx + 1], ah
	inc edx
	inc edx
	je putEnd
putCR: ; Process carage return
	push edx
	push ecx
	mov eax,edx					; set up for div
	sub eax, VGA_BUFFER
	xor edx,edx
	mov ecx,VGA_COL2			; mod into ecx
	div ecx
	mov eax,edx
	pop ecx
	pop edx
	sub edx,eax
	jmp prloop
putNL:	; Process New Line
	add edx,VGA_COL2
	jmp prloop
	
putEnd:
	; save the vga buffer location
	mov [CURRENT_BUFFER_PTR],edx
	pop edx
	pop esi
	call cursor_set
	frameEnd
	
	ret


section .data
CURRENT_ROW	db 0
CURRENT_COL	db 0
CURRENT_COLOR	db 0
CURRENT_BUFFER_PTR dd 0

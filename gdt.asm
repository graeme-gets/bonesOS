

global gdt_load
global CODE_SEG
;                       Pr  Priv    1   Ex  DC  RW
; 0x9A == 1001 1010 ==  1   00      1   1   0   1
; 0x92 == 1001 0010 ==  1   00      1   0   0   1

;                       G   D   ; offset 0x0 (0 bytes)
gdt_start:
null_descriptor: 
    dd 0x0
    dd 0x0

;offset 0x8 (8 bytes)
code_desriptor:    ; cs should point ro this descriptor
    dw 0xffff       ; Segment Limit 
    dw 0x0          ; base first 0-15 bits
    db 0x0          ; base 16-23 bits
    db 0b10011010   ; Access Flags
                    ; Code  Conform     readable    accessed 
                    ; 1     0           0           1  
                    ; low 4 bits 
                    ; Gran  32Bit   64Bits  AVL
                    ; 1     1       0       0
                    ; Granularity Limit X 0x1000
    db 0b11001111   ; What is this flag
    db 0x0          ; base 24-32 bits

data_descriptor:   ; ds,es,fs,gs,ss should point here
    dw 0xffff       ; segment limit 0-15 bits
    dw 0x0          ; base frist 0-15 bits
    db 0x0          ; base 16-23 bits
    db 0b10010010         ; access Flags
    db 0b11001111   ; High bits flags
                    ; Code  Direction   Writable    accessed 
                    ; 0     0           1           0  
                    ; low 4 bits ?? heck these!!
                    ; Gran  32Bit   64Bits  AVL
                    ; 1     1       0       0
                    ; Direction 1 = grows downwards? Check
    db 0x0
gdt_end:

gdt_descriptor:
        dw gdt_end - gdt_start -1
        dd gdt_start

CODE_SEG    equ code_desriptor-gdt_start
DATA_SEG    equ data_descriptor-gdt_start

gdt_load:
    cli
    lgdt [gdt_descriptor]    ; set the gdt table
    ; change last bit of cr0 Reg to move into 32bit protected mode
    mov eax,cr0
    or eax, 1
    mov cr0,eax
    ; jmp to code segment
    jmp CODE_SEG:start_protected_mode

    [bits 32]
    start_protected_mode:
    
    mov al,'3'
    mov ah,0x0f     ; black on white
    mov [0xb8000], ax
    mov al,'2'
    mov [0xb8002], ax
    mov al,' '
    mov [0xb8004], ax
    mov al,'B'
    mov [0xb8006], ax
    mov al,'I'
    mov [0xb8008], ax
    mov al,'T'
    mov [0xb800a], ax
    mov al,' '
    mov [0xb800c], ax
    mov al,'M'
    mov [0xb800e], ax
    mov al,'O'
    mov [0xb8010], ax
    mov al,'D'
    mov [0xb8012], ax
    mov al,'E'
    mov [0xb8014], ax
    mov al,'!'
    mov [0xb8016], ax

    ret
    


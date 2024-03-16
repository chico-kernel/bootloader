[bits 16]
section .text
    global _start
    extern enable_a20
    extern enable_gdt
    extern enable_protected

_start:
    ; Set video mode to mode 3 (80x25 text mode)
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    mov ah, 0x0e
    mov al, 'A'
    int 0x10 

    ; Set up the stack
    mov ax, 0
    mov ss, ax
    mov sp, 0x7C00

    mov ah, 0x0e
    mov al, 'B'
    int 0x10 

    ; Enable A20
    call enable_a20

    mov ah, 0x0e
    mov al, 'C'
    int 0x10 

    ; Get kernel sector
    mov ax, 0
    mov es, ax
    mov ah, 0x02
    mov al, 10
    mov di, 0x7E00
    mov ch, 0
    mov dh, 0
    mov cl, 2
    int 0x13

    jc kernel_load_error

    mov ah, 0x0e
    mov al, 'D'
    int 0x10 
    
    call enable_gdt
    jmp 8:0x7E00

kernel_load_error:
    mov ah, 0x0E
    mov al, '!'
    int 0x10
    hlt
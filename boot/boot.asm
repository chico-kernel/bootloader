; Entry file for the Chico Bootloader

[bits 16]
section .text
    global _start
    extern enable_a20
    extern enable_gdt
    extern enable_protected

_start:
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

    call enable_a20
    call enable_gdt
    jmp 0x0008:0x7E00
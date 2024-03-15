; Copyright © 2024 Kevin Alavik. All rights reserved.

[bits 16]
section .text
    global _start
    extern enable_a20
    extern enable_gdt
    extern enable_protected

_start:
    ; Get kernel sector
    mov ah, 0x02
    mov al, 0x10
    mov ax, 0
    mov es, ax
    mov di, 0x7E00
    mov ch, 0
    mov dh, 0
    mov cl, 2
    int 0x13

    call enable_a20
    call enable_gdt
    call enable_protected
    jmp load_kernel
 
load_kernel:
    jmp 0x7E00

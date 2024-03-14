; Copyright © 2024 Kevin Alavik. All rights reserved.

[bits 16]
section .text
    global _start
    extern enable_a20
    extern enable_gdt
    extern enable_protected

_start:
    call enable_a20
    call enable_gdt
    call enable_protected
    jmp load_kernel
 
load_kernel:
    hlt     ; Load kernel
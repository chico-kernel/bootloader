section .text
    global _start
    extern print_letter

_start:
    mov al, 'A'
    jmp print_letter
    hlt

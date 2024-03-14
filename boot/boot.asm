section .data
    text db 'Hello, World!', 0

section .text
    global _start
    extern clear_screen
    extern print_letter
    extern print_string

_start:
    call clear_screen
    mov ax, text
    call print_string
    hlt

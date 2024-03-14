section .text
    global _start
    extern clear_screen
    extern print_letter

_start:
    call clear_screen

    mov al, 'C'
    call print_letter
    mov al, 'h'
    call print_letter
    mov al, 'i'
    call print_letter
    mov al, 'c'
    call print_letter
    mov al, 'o'
    call print_letter
    mov al, ' '
    call print_letter
    mov al, 'B'
    call print_letter
    mov al, 'o'
    call print_letter
    mov al, 'o'
    call print_letter
    mov al, 't'
    call print_letter
    mov al, 'l'
    call print_letter
    mov al, 'o'
    call print_letter
    mov al, 'a'
    call print_letter
    mov al, 'd'
    call print_letter
    mov al, 'e'
    call print_letter
    mov al, 'r'
    call print_letter
    mov al, ' '
    call print_letter
    mov al, 'v'
    call print_letter
    mov al, '0'
    call print_letter
    mov al, '.'
    call print_letter
    mov al, '0'
    call print_letter
    mov al, '.'
    call print_letter
    mov al, '1'
    call print_letter
    hlt

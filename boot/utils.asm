
section .text
    global print_letter

print_letter:
    mov ah, 0x0e
    int 0x10
    ret

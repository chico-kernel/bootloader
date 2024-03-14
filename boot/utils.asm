section .text
    global print_letter
    global clear_screen


print_letter:
    mov ah, 0x0e
    mov bh, 0
    mov bl, 0x07
    int 10h
    ret

clear_screen:
    cli
    mov ah, 0
    mov al, 3
    int 10h

    mov ah, 0x02
    xor bh, bh
    xor dh, dh
    xor dl, dl
    int 10h
    ret

section .text
    global print_letter
    global clear_screen
    global print_string

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

[bits 16]
print_string:
    mov si, ax
print_loop:
    mov al, [si]
    test al, al
    jz print_done
    call print_letter
    inc si
    jmp print_loop
print_done:
    ret

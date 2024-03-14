[bits 16]

section .text
    print_string:
        mov ah, 0x0E
    .print_loop:
        lodsb
        cmp al, 0
        je .print_done
        int 0x10
        jmp .print_loop

    .print_done:
        ret

    global _start
    _start:
        mov si, hello_msg
        call print_string

    .hang:
        hlt
        jmp .hang

    section .data
        hello_msg db 'Hello, World!', 0

    times 510 - ($ - $$) db 0
    dw 0xAA55

[bits 16]
[SECTION .boot]
section .data
    gdt_message db 'Loading GDT...', 0
section .text
    extern kernel_main

mov si, gdt_message
call puts
dq 0x00
dw 0xFFFF
dw 0x0000
db 0x00
db 0b10011011
db 0b11001111
db 0x00

dw 0xFFFF
dw 0x0000
db 0x00
db 0b10010011
db 0b11001111
db 0x00
dw 0x17
dd 0x7E00 ; Offset to where the kernel is loaded in memory

cli
lgdt [0x7E18]
mov eax, cr0
or eax, 1
mov cr0, eax
jmp 8:protected

protected:
    mov ax, 16
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ax, 0x0000
    mov es, ax

    mov bx, 0x7E00

    jmp 8:kernel

kernel:
    call kernel_main
    jmp $

puts:
    pusha
next_char:
    lodsb
    or al, al
    jz done
    mov ah, 0x0E
    int 0x10
    jmp next_char
done:
    popa
    ret

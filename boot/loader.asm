[bits 16]
[SECTION .boot]
section .text
    extern kernel_main

mov ah, 0x0E
mov al, 'L'
int 0x10
mov ah, 0x0E
mov al, 'o'
int 0x10
mov ah, 0x0E
mov al, 'a'
int 0x10
mov ah, 0x0E
mov al, 'i'
int 0x10
mov ah, 0x0E
mov al, 'n'
int 0x10
mov ah, 0x0E
mov al, 'g'
int 0x10
mov ah, 0x0E
mov al, ' '
int 0x10
mov ah, 0x0E
mov ah, 0x0E
mov al, 'G'
int 0x10
mov ah, 0x0E
mov al, 'D'
int 0x10
mov ah, 0x0E
mov al, 'T'
int 0x10
mov ah, 0x0E
mov al, '.'
int 0x10
mov ah, 0x0E
mov al, '.'
int 0x10
mov ah, 0x0E
mov al, '.'
int 0x10
mov ah, 0x0E
mov al, 0x0A
int 0x10
mov ah, 0x0E
mov al, 0x0D
int 0x10

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
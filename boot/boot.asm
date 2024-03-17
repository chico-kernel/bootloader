[org 0x7C00]

mov [DISK], dl  ; Save disk number.

; Set video mode to mode 3 (80x25 text mode)
mov ah, 0x00
mov al, 0x03
int 0x10

; Set up stack
mov bp, 0x7C00
mov sp, bp

; Enable A20 line
in al, 0x92
or al, 2
out 0x92, al

; Load first 100 sectors into RAM
mov ax, 0x0000
mov es, ax      ; SEG
mov ah, 2 
mov al, 100     ; Sectors to read
mov bx, 0x7E00  ; OFF
mov dl, [DISK]  ; Disk Number
mov ch, 0       ; Cylinder
mov dh, 0       ; Head
mov cl, 2       ; Sector (2 = Kernel Sector)

int 0x13
jc disk_read_fail
jmp load_kernel

disk_read_fail:
    mov ah, 0x0E
    mov al, 'F'
    int 0x10
    mov ah, 0x0E
    mov al, 'a'
    int 0x10
    mov ah, 0x0E
    mov al, 'i'
    int 0x10
    mov ah, 0x0E
    mov al, 'l'
    int 0x10
    mov ah, 0x0E
    mov al, 'd'
    int 0x10
    mov ah, 0x0E
    mov al, ' '
    int 0x10
    mov ah, 0x0E
    mov al, 'T'
    int 0x10
    mov ah, 0x0E
    mov al, 'o'
    int 0x10
    mov ah, 0x0E
    mov al, ' '
    int 0x10
    mov ah, 0x0E
    mov al, 'R'
    int 0x10
    mov ah, 0x0E
    mov al, 'e'
    int 0x10
    mov ah, 0x0E
    mov al, 'a'
    int 0x10
    mov ah, 0x0E
    mov al, 'd'
    int 0x10
    mov ah, 0x0E
    mov al, ' '
    int 0x10
    mov ah, 0x0E
    mov al, 'D'
    int 0x10
    mov ah, 0x0E
    mov al, 'i'
    int 0x10
    mov ah, 0x0E
    mov al, 's'
    int 0x10
    mov ah, 0x0E
    mov al, 'k'
    int 0x10
    mov ah, 0x0E
    mov al, '!'
    int 0x10
    hlt

load_kernel:
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
    mov al, 'K'
    int 0x10
    mov ah, 0x0E
    mov al, 'e'
    int 0x10
    mov ah, 0x0E
    mov al, 'r'
    int 0x10
    mov ah, 0x0E
    mov al, 'n'
    int 0x10
    mov ah, 0x0E
    mov al, 'e'
    int 0x10
    mov ah, 0x0E
    mov al, 'l'
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

    jmp 0x7E00  ; Jump to kernel

DISK:
    db 0        ; Define the disk number

times 510-($-$$) db 0
dw 0xaa55
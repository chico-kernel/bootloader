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

; Load first 127 sectors into RAM
mov ax, 0x0000
mov es, ax      ; SEG
mov ah, 2 
mov al, 127       ; Sectors to read
mov bx, 0x7E00  ; OFF
mov dl, [DISK]  ; Disk Number
mov ch, 0       ; Cylinder
mov dh, 0       ; Head
mov cl, 2       ; Sector (2 = Kernel Sector)
int 0x13

; Load more sectors. Credits to https://github.com/AptRock327/RaidouOS/tree/main
mov bx, 0

mov ax, 0x17E0
mov es, ax
mov ah, 2
mov al, 127
mov dh, 2
mov cl, 3
int 0x13

mov ax, 0x27C0
mov es, ax
mov ah, 2
mov al, 127
mov dh, 4
mov cl, 4
int 0x13

mov ax, 0x37A0
mov es, ax
mov ah, 2
mov al, 127
mov dh, 6
mov cl, 5
int 0x13

mov ax, 0x4780
mov es, ax
mov ah, 2
mov al, 127
mov dh, 8
mov cl, 6
int 0x13

mov ax, 0x5760
mov es, ax
mov ah, 2
mov al, 127
mov dh, 10
mov cl, 7
int 0x13

mov ax, 0x6740
mov es, ax
mov ah, 2
mov al, 127
mov dh, 12
mov cl, 8
int 0x13

mov ax, 0x7720
mov es, ax
mov ah, 2
mov al, 127
mov dh, 14
mov cl, 9
int 0x13

mov ax, 0x8700
mov es, ax
mov ah, 2
mov al, 127
mov ch, 1
mov dh, 0
mov cl, 10
int 0x13

mov ax, 0x96E0
mov es, ax
mov ah, 2
mov al, 127
mov ch, 1
mov dh, 2
mov cl, 11
int 0x13

jmp 0x801A       ; Jump to kernel loader

DISK db 0        ; Define the disk number

times 510-($-$$) db 0
dw 0xaa55
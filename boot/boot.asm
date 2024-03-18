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

; Load first 127 sectors into RAM (Broken: Why tf cant i read more the 1 sector?)
mov ax, 0x0000
mov es, ax      ; SEG
mov ah, 2
mov al, 127     ; Sectors to read
mov bx, 0x7E00  ; OFF
mov dl, [DISK]  ; Disk Number
mov ch, 0       ; Cylinder
mov dh, 0       ; Head
mov cl, 2       ; Start Sector (2 = First Kernel Sector)
int 0x13

jc load_error   ; Jump to load_error if carry flag is set (indicates error)

jmp 0x7E18      ; Jump to loader (after loading kernel)


load_error:
    mov si, error_message   ; Load address of error message into SI
    call puts               ; Call puts to print error message
    jmp $                   ; Loop indefinitely

error_message db 'Failed To Read Disk!', 0

puts:
    pusha               ; Save registers
next_char:
    lodsb               ; Load byte at SI into AL, increment SI
    or al, al           ; Check if AL is zero (end of string)
    jz done             ; If zero, we're done
    mov ah, 0x0E        ; Print character (Teletype out)
    int 0x10            ; BIOS interrupt for video services
    jmp next_char       ; Loop back to print the next character
done:
    popa                ; Restore registers
    ret                 ; Return from subroutine

DISK db 0        ; Define the disk number

times 510-($-$$) db 0
dw 0xaa55

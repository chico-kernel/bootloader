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

read_loop:
    mov ax, 0x0000
    mov es, ax
    mov ah, 2
    mov al, [SECTORS_TO_READ]
    mov dx, [DISK]

    mov cx, 0
    mov dh, 0

    mov bx, 0x7E00
    mov cl, 2
    int 0x13

    add bx, 512
    dec al
    jnz read_loop

jc load_error   ; Jump to load_error if carry flag is set (indicates error)

jmp 0x7E18      ; Jump to loader (after loading kernel)


load_error:
    mov si, error_message   ; Load address of error message into SI
    call puts               ; Call puts to print error message
    jmp $                   ; Loop indefinitely

error_message db 'error: failed to read disk!', 0

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

DISK db 0               ; Define the disk number
SECTORS_TO_READ db 127  ; Define the ammount of sectors to read

times 510-($-$$) db 0
dw 0xaa55

[bits 16]
[org 0x7c00]

section .text
    global _start

_start:
    ; Set video mode to mode 3 (80x25 text mode)
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    mov ah, 0x0e
    mov al, 'A'
    int 0x10

    ; Set up the stack
    mov ax, 0
    mov ss, ax
    mov sp, 0x7C00

    mov ah, 0x0e
    mov al, 'B'
    int 0x10

    ; Get kernel sector
    mov ax, 0
    mov es, ax
    mov ah, 0x02
    mov al, 10
    mov bx, 0x7E00
    mov ch, 0
    mov dh, 0
    mov cl, 2
    int 0x13

    jc kernel_load_error

    mov ah, 0x0e
    mov al, 'C'
    int 0x10

    ; Enable GDT
    call enable_gdt
    mov ah, 0x0e
    mov al, 'D'
    int 0x10

    jmp kernel_entry

kernel_load_error:
    mov ah, 0x0E
    mov al, '!'
    int 0x10
    hlt

kernel_entry:
    ; Jump to kernel kernel_entry
    jmp 8:0x7E00

enable_a20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

enable_gdt:
    call .set_gdt
    call enable_a20
    cli
    lgdt [gdtr]
    mov eax, cr0
    or al, 0x1
    mov cr0, eax
    jmp 0x08:.reload_cs
    ret

.reload_cs:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    ret

.set_gdt:
    xor eax, eax
    mov ax, ds
    shl eax, 4
    add eax, gdt
    mov [gdtr + 2], eax
    mov eax, gdt_end
    sub eax, gdt
    mov [gdtr], ax
    ret

section .data
    gdt:
        null:
            dd 0x00000000
            dd 0x00000000
            db 0x00
            db 0x00
        kernel_code:
            dd 0x000FFFFF
            dd 0x00000000
            db 0x9A
            db 0xCF
        kernel_data:
            dd 0x000FFFFF
            dd 0x00000000
            db 0x92
            db 0xCF
        user_code:
            dd 0x0000FFFF
            dd 0x00000000
            db 0xFA
            db 0xCF
        user_data:
            dd 0x0000FFFF
            dd 0x00000000
            db 0xF2
            db 0xCF
        task_state:
            dd 0x00000000       ; Replace with pointer to TSS
            dd 0x0000           ; Replace with size of TSS
            db 0x89
            db 0x00

gdt_end equ gdt + 7 * 8 ;

section .data
    gdtr:
        dw 39
        dd gdt

[bits 16]
section .data
    gdt:
        null:
            dd 0x00000000
            dd 0x00000000
            db 0x00
            db 0x00
        kernel_code:
            dd 0x0000FFFF
            dd 0x00000000
            db 0x9A
            db 0xCF
        kernel_data:
            dd 0x0000FFFF
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

section .text
    global enable_protected
    global enable_gdt

enable_protected:
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    ret

enable_gdt:
    call .set_gdt
    call enable_protected
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
    lgdt [gdtr]
    ret
